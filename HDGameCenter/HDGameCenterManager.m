//
//  HDGameKit.m
//  GraviMaze
//
//  Created by Hart David on 15.09.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "HDGameCenterManager.h"
#import "NimbusCore.h"
#import "UIDevice+HDAdditions.h"


NSString* const HDGameCenterUnsentAchievementsKey = @"HDUnsentAchievements";
NSString* const HDGameCenterUnsentScoresKey = @"HDUnsentScores";


static HDGameCenterManager* kSharedInstance = nil;


@interface HDGameCenterManager ()

@property (nonatomic, strong) NSMutableDictionary* serverAchievements;
@property (nonatomic, strong) NSMutableDictionary* unsentAchievements;
@property (nonatomic, strong) NSMutableDictionary* unsentScores;

+ (NSString*)archivePath;
+ (UIViewController*)rootViewController;

- (void)addObservers;
- (void)updateGameCenter;
- (void)updateScores;
- (void)updateAchievements;
- (void)reportAchievement:(GKAchievement*)achievement;
- (void)reportScore:(GKScore*)score;

- (void)presentViewController:(UIViewController*)viewController;
- (void)dismissModalViewController;

@end


@implementation HDGameCenterManager

@synthesize serverAchievements = _serverAchievements;
@synthesize unsentAchievements = _unsentAchievements;
@synthesize unsentScores = _unsentScores;

#pragma mark - Class Methods

+ (BOOL)isAvailable
{
	BOOL isClassAvailable = NSClassFromString(@"GKLocalPlayer") != nil;
	BOOL isOSSufficient = [[UIDevice currentDevice] isOSVersionAtLeast:@"4.1"];
	return isClassAvailable && isOSSufficient;
}

+ (HDGameCenterManager*)sharedInstance
{
	@synchronized (self)
	{
		if (kSharedInstance == nil)
		{
			kSharedInstance = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
			
			if (kSharedInstance == nil)
			{
				kSharedInstance = [HDGameCenterManager new];
			}
		}

		return kSharedInstance;
	}
}

+ (NSString*)archivePath
{
	NSString* supportPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];	
	return [supportPath stringByAppendingPathComponent:@"GameCenter.plist"];
}

+ (UIViewController*)rootViewController
{
	return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

#pragma mark - Initialization

- (id)init
{
	if ((self = [super init]))
	{
		[self setUnsentScores:[NSMutableDictionary dictionary]];
		[self setUnsentAchievements:[NSMutableDictionary dictionary]];
		[self addObservers];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
	if ((self = [super init]))
	{
		NSMutableDictionary* scores = [decoder decodeObjectForKey:HDGameCenterUnsentScoresKey];
		NIDASSERT(scores != nil);
		
		NSMutableDictionary* achievements = [decoder decodeObjectForKey:HDGameCenterUnsentAchievementsKey];
		NIDASSERT(achievements != nil);
		
		[self setUnsentScores:scores];
		[self setUnsentAchievements:achievements];
		[self addObservers];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self save];
}

#pragma mark - Properties

- (BOOL)isAuthenticated
{
	return [[self class] isAvailable] && [[GKLocalPlayer localPlayer] isAuthenticated];
}

#pragma mark - Public Methods

- (void)authenticate
{
	if (![[self class] isAvailable])
	{
		return;
	}
	
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	
	if (![localPlayer isAuthenticated])
	{
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError* error) {
			if (error != nil)
			{
				NIDINFO(@"GameCenter authenticateWithCompletionHandler - %@", [error localizedDescription]);
			}
		}];
	}
}

- (void)updateScore:(int64_t)value onLeaderboard:(NSString*)category
{
	if (![[self class] isAvailable])
	{
		return;
	}
	
	GKScore* score = [[self unsentScores] objectForKey:category];
	
	if (score == nil)
	{
		score = [[GKScore alloc] initWithCategory:category];
		[[self unsentScores] setObject:score forKey:category];
	}
	
	[score setValue:value];
	
	if ([[GKLocalPlayer localPlayer] isAuthenticated])
	{
		[self reportScore:score];
	}
}

- (void)updateAchievement:(NSString*)identifier percentComplete:(double)percentComplete
{
	if (![[self class] isAvailable])
	{
		return;
	}
	
	NIDASSERT((percentComplete >= 0.0) && (percentComplete <= 100.0));
	percentComplete = MIN(MAX(percentComplete, 0), 100);
	
	GKAchievement* achievement = [[self unsentAchievements] objectForKey:identifier];
	
	if (achievement == nil)
	{
		achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
		[[self unsentAchievements] setObject:achievement forKey:identifier];		
	}
	
	if ((NSUInteger)percentComplete > (NSUInteger)[achievement percentComplete])
	{
		[achievement setPercentComplete:percentComplete];
		
		if ([[GKLocalPlayer localPlayer] isAuthenticated])
		{
			[self reportAchievement:achievement];
		}
	}
}

- (void)completeAllAchievements
{
	if (![self isAuthenticated])
	{
		return;
	}
	
	[GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray* descriptions, NSError* error) {
		if (error != nil)
		{
			NIDINFO(@"GameCenter loadAchievementDescriptionsWithCompletionHandler - %@", [error localizedDescription]);
			return;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[descriptions enumerateObjectsUsingBlock:^(GKAchievementDescription* achievementDescription, NSUInteger idx, BOOL* stop) {
				NSString* identifier = [achievementDescription identifier];
				[self updateAchievement:identifier percentComplete:100];
			}];
		});
	}];
}

- (void)resetAllAchievements
{
	if (![self isAuthenticated])
	{
		return;
	}
	
	[GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
		if (error != nil)
		{
			NIDINFO(@"GameCenter resetAchievementsWithCompletionHandler - %@", [error localizedDescription]);
			return;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[[self unsentAchievements] removeAllObjects];
		});
	}];
}

- (void)save
{
	[NSKeyedArchiver archiveRootObject:self toFile:[[self class] archivePath]];
}

- (void)showLeaderboards
{
	if (![[self class] isAvailable])
	{
		return;
	}
	
	GKLeaderboardViewController* leaderboardViewController = [GKLeaderboardViewController new];
	[leaderboardViewController setLeaderboardDelegate:self];
	[self presentViewController:leaderboardViewController];
}

- (void)showAchievements
{
	if (![[self class] isAvailable])
	{
		return;
	}
	
	GKAchievementViewController* achievementViewController = [GKAchievementViewController new];
	[achievementViewController setAchievementDelegate:self];
	[self presentViewController:achievementViewController];
}

#pragma mark - NSCoding Methods

- (void)encodeWithCoder:(NSCoder*)encoder
{
	[encoder encodeObject:[self unsentScores] forKey:HDGameCenterUnsentScoresKey];
	[encoder encodeObject:[self unsentAchievements] forKey:HDGameCenterUnsentAchievementsKey];
}

#pragma mark - GKLeaderboardViewControllerDelegate Methods

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController
{
	[self dismissModalViewController];
}

#pragma mark - GKAchievementViewControllerDelegate Methods

- (void)achievementViewControllerDidFinish:(GKAchievementViewController*)viewController
{
	[self dismissModalViewController];
}

#pragma mark - Private Methods

- (void)addObservers
{
	NIDASSERT([[self class] isAvailable]);
	
	NSString* playerNotification = GKPlayerAuthenticationDidChangeNotificationName;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGameCenter) name:playerNotification object:nil];
	
	NSString* backgroundNotification = UIApplicationDidEnterBackgroundNotification;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:backgroundNotification object:nil];
}

- (void)updateGameCenter
{
	if (![[GKLocalPlayer localPlayer] isAuthenticated])
	{
		return;
	}
	
	[self updateScores];
	[self updateAchievements];
}

- (void)updateScores
{
	for (GKScore* score in [[self unsentScores] allValues])
	{
		[self reportScore:score];
	}
}

- (void)updateAchievements
{
	[self setServerAchievements:nil];
	
	[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray* achievements, NSError* error) {
		if (error != nil)
		{
			NIDINFO(@"GameCenter loadAchievementsWithCompletionHandler - %@", [error localizedDescription]);
			return;
		}
		
		NSMutableDictionary* serverAchievements = [NSMutableDictionary dictionary];
		
		[achievements enumerateObjectsUsingBlock:^(GKAchievement* achievement, NSUInteger idx, BOOL* stop) {
			[serverAchievements setObject:achievement forKey:[achievement identifier]];
		}];
		
		dispatch_async(dispatch_get_main_queue(), ^{	
			[self setServerAchievements:serverAchievements];
			
			for (GKAchievement* achievement in [[self unsentAchievements] allValues])
			{
				[self reportAchievement:achievement];
			}
		});
	}];
}

- (void)reportScore:(GKScore*)score
{
	NIDASSERT(dispatch_get_current_queue() == dispatch_get_main_queue());
	
	[score reportScoreWithCompletionHandler:^(NSError* error) {
		if (error != nil)
		{
			NIDINFO(@"GameCenter reportScoreWithCompletionHandler - %@", [error localizedDescription]);
			return;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[[self unsentScores] removeObjectForKey:[score category]];
		});
	}];
}

- (void)reportAchievement:(GKAchievement*)achievement
{
	NIDASSERT(dispatch_get_current_queue() == dispatch_get_main_queue());
	
	if ([self serverAchievements] == nil)
	{
		return;
	}
	
	NSString* identifier = [achievement identifier];
	GKAchievement* serverAchievement = [[self serverAchievements] objectForKey:identifier];
	
	if ((NSUInteger)[serverAchievement percentComplete] >= (NSUInteger)[achievement percentComplete])
	{
		[[self unsentAchievements] removeObjectForKey:identifier];
		return;
	}
	
	if ([achievement respondsToSelector:@selector(setShowsCompletionBanner:)])
	{
		[achievement setShowsCompletionBanner:YES];
	}
	
	[achievement reportAchievementWithCompletionHandler:^(NSError* error) {
		if (error != nil)
		{
			NIDINFO(@"GameCenter reportAchievementWithCompletionHandler - %@", [error localizedDescription]);
			return;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (serverAchievement == nil)
			{
				[[self serverAchievements] setObject:achievement forKey:identifier];
			}
			else
			{
				[serverAchievement setPercentComplete:[achievement percentComplete]];
			}
			
			[[self unsentAchievements] removeObjectForKey:identifier];
		});
	}];
}

- (void)presentViewController:(UIViewController*)viewController
{
	[[[self class] rootViewController] presentModalViewController:viewController animated:YES];
}

- (void)dismissModalViewController
{
	[[[self class] rootViewController] dismissModalViewControllerAnimated:YES];
}

@end
