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
#import "HDFoundation.h"


NSString* const HDGameCenterUnsentAchievementsKey = @"HDUnsentAchievements";
NSString* const HDGameCenterUnsentScoresKey = @"HDUnsentScores";


@interface HDGameCenterManager ()

@property (nonatomic, strong) NSMutableDictionary* serverAchievements;

@end


@implementation HDGameCenterManager

#pragma mark - Class Methods

+ (BOOL)isAvailable
{
	BOOL isClassAvailable = NSClassFromString(@"GKLocalPlayer") != nil;
	BOOL isOSSufficient = [[UIDevice currentDevice] isOSVersionAtLeast:@"4.1"];
	return isClassAvailable && isOSSufficient;
}

+ (HDGameCenterManager*)sharedInstance
{
	return HDCreateSingleton(^{
		return [HDGameCenterManager new];
	});
}

+ (UIViewController*)rootViewController
{
	return [UIApplication sharedApplication].keyWindow.rootViewController;
}

#pragma mark - Initialization

- (id)init
{
	if (self = [super init]) {
		[self addObservers];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (BOOL)isAuthenticated
{
	return [[self class] isAvailable] && [GKLocalPlayer localPlayer].isAuthenticated;
}

#pragma mark - Public Methods

- (void)authenticate
{
	if (![[self class] isAvailable] || [GKLocalPlayer localPlayer].isAuthenticated) {
		return;
	}
	
	[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError* error) {
		if (error != nil) {
			NIDINFO(@"GameCenter authenticateWithCompletionHandler - %@", [error localizedDescription]);
		}
	}];
}

- (void)updateScore:(int64_t)value onLeaderboard:(NSString*)category
{
	if (!self.isAuthenticated) {
		return;
	}
	
	GKScore* score = [[GKScore alloc] initWithCategory:category];
	[score reportScoreWithCompletionHandler:^(NSError* error) {
		if (error != nil) {
			NIDINFO(@"GameCenter reportScoreWithCompletionHandler - %@", [error localizedDescription]);
			return;
		}
	}];
}

- (void)updateAchievement:(NSString*)identifier percentComplete:(double)percentComplete
{
	if (!self.isAuthenticated) {
		return;
	}
	
	NIDASSERT((percentComplete >= 0.0) && (percentComplete <= 100.0));
	percentComplete = MIN(MAX(percentComplete, 0), 100);

	GKAchievement* serverAchievement = self.serverAchievements[identifier];
	
	if ((NSUInteger)serverAchievement.percentComplete >= (NSUInteger)percentComplete) {
		return;
	}
	
	GKAchievement* achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
	achievement.percentComplete = percentComplete;
	
	if ([achievement respondsToSelector:@selector(setShowsCompletionBanner:)]) {
		achievement.showsCompletionBanner = YES;
	}
	
	[achievement reportAchievementWithCompletionHandler:^(NSError* error) {
		if (error != nil) {
			NIDINFO(@"GameCenter reportAchievementWithCompletionHandler - %@", [error localizedDescription]);
			return;
		}
		
		if (serverAchievement != nil) {
			dispatch_async(dispatch_get_main_queue(), ^{
				serverAchievement.percentComplete = percentComplete;
			});
		}
	}];
}

- (void)completeAllAchievements
{
	if (!self.isAuthenticated) {
		return;
	}
	
	[GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray* descriptions, NSError* error) {
		if (error != nil) {
			NIDINFO(@"GameCenter loadAchievementDescriptionsWithCompletionHandler - %@", [error localizedDescription]);
			return;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[descriptions enumerateObjectsUsingBlock:^(GKAchievementDescription* achievementDescription, NSUInteger idx, BOOL* stop) {
				[self updateAchievement:achievementDescription.identifier percentComplete:100];
			}];
		});
	}];
}

- (void)resetAllAchievements
{
	if (!self.isAuthenticated) {
		return;
	}
	
	[GKAchievement resetAchievementsWithCompletionHandler:^(NSError* error) {
		if (error != nil) {
			NIDINFO(@"GameCenter resetAchievementsWithCompletionHandler - %@", [error localizedDescription]);
		}
	}];
}

- (void)showLeaderboards
{
	if (!self.isAuthenticated) {
		return;
	}
	
	GKLeaderboardViewController* leaderboardViewController = [GKLeaderboardViewController new];
	leaderboardViewController.leaderboardDelegate = self;
	[self presentViewController:leaderboardViewController];
}

- (void)showAchievements
{
	if (!self.isAuthenticated) {
		return;
	}
	
	GKAchievementViewController* achievementViewController = [GKAchievementViewController new];
	achievementViewController.achievementDelegate = self;
	[self presentViewController:achievementViewController];
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
	if (![[self class] isAvailable]) {
		return;
	}
	
	NSString* playerNotification = GKPlayerAuthenticationDidChangeNotificationName;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateServerAchievements:) name:playerNotification object:nil];
}

- (void)updateServerAchievements:(NSNotification*)notification
{	
	if (!self.isAuthenticated) {
		return;
	}
	
	[GKAchievement loadAchievementsWithCompletionHandler:^(NSArray* achievements, NSError* error) {
		NSMutableDictionary* serverAchievements = nil;
		
		if (error != nil) {
			NIDINFO(@"GameCenter loadAchievementsWithCompletionHandler - %@", [error localizedDescription]);
		} else {
			serverAchievements = [NSMutableDictionary dictionary];
			[achievements enumerateObjectsUsingBlock:^(GKAchievement* achievement, NSUInteger index, BOOL* stop) {
				serverAchievements[achievement.identifier] = achievement;
			}];
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{	
			self.serverAchievements = serverAchievements;
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
