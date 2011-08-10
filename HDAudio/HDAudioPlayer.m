//
//  HDAudioPlayer.m
//  TchoupiAnglais
//
//  Created by David Hart on 10/27/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDAudioPlayer.h"
#import "HDAssert.h"


@interface HDAudioPlayer ()

@property (nonatomic, strong) NSMutableArray* sfxPlayers;
@property (nonatomic, strong) NSMutableArray* sfxInvocations;
@property (nonatomic, strong) AVAudioPlayer* musicPlayer;
@property (nonatomic, strong) NSInvocation* musicInvocation;

- (NSInvocation*)invocationForTarget:(id)target andSelector:(SEL)selector withObject:(id)object;
- (AVAudioPlayer*)audioPlayerWithName:(NSString*)name andType:(NSString*)type;
- (AVAudioPlayer*)audioPlayerWithPath:(NSString*)path;

@end


@implementation HDAudioPlayer

@synthesize sfxPlayers = _sfxPlayers;
@synthesize sfxInvocations = _sfxInvocations;
@synthesize musicPlayer = _musicPlayer;
@synthesize musicInvocation = _musicInvocation;

#pragma mark -
#pragma mark Initializing Methods

+ (HDAudioPlayer*)sharedInstance
{
	static HDAudioPlayer* kSharedInstance = nil;
	
	if (kSharedInstance == nil)
	{
		kSharedInstance = [HDAudioPlayer new];
	}
	
	return kSharedInstance;
}

- (id)init
{
	if ((self = [super init]))
	{
		[self setSfxPlayers:[NSMutableArray array]];
		[self setSfxInvocations:[NSMutableArray array]];
	}
	
	return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)playSfx:(NSString*)sfxName
{
	[self playSfx:sfxName target:nil action:NULL withObject:nil];
}

- (void)playSfx:(NSString*)sfxName target:(id)target action:(SEL)selector
{
	[self playSfx:sfxName target:target action:selector withObject:nil];
}

- (void)playSfx:(NSString*)sfxName target:(id)target action:(SEL)selector withObject:(id)object
{
	HDCheck(isObjectNotNil(sfxName), HDFailureLevelWarning, return);

	AVAudioPlayer* sfxPlayer = [self audioPlayerWithName:sfxName andType:@"caf"];
	HDCheck(isObjectNotNil(sfxPlayer), HDFailureLevelWarning, return);
	[[self sfxPlayers] addObject:sfxPlayer];
	
	NSInvocation* sfxInvocation = [self invocationForTarget:target andSelector:selector withObject:object];
	id nullableInvocation = (sfxInvocation != nil) ? (id)sfxInvocation : (id)[NSNull null];
	[[self sfxInvocations] addObject:nullableInvocation];

	[sfxPlayer play];
}

- (void)stopAllSfx
{
	for (AVAudioPlayer* sfxPlayer in [self sfxPlayers])
	{
		[sfxPlayer setDelegate:nil];
		[sfxPlayer stop];
	}
	
	[[self sfxPlayers] removeAllObjects];
	[[self sfxInvocations] removeAllObjects];
}

- (void)playMusic:(NSString*)musicName
{
	[self playMusic:musicName target:nil action:NULL withObject:nil];
}

- (void)playMusic:(NSString*)musicName looping:(BOOL)looping
{
	HDCheck(isObjectNotNil(musicName), HDFailureLevelWarning, return);
	
	AVAudioPlayer* musicPlayer = [self audioPlayerWithName:musicName andType:@"m4a"];
	HDCheck(isObjectNotNil(musicPlayer), HDFailureLevelWarning, return);
	
	[self stopMusic];
	[self setMusicPlayer:musicPlayer];
	
	[musicPlayer setNumberOfLoops:looping ? -1 : 0];
	[musicPlayer play];
}

- (void)playMusic:(NSString*)musicName target:(id)target action:(SEL)selector
{
	[self playMusic:musicName target:target action:selector withObject:nil];
}

- (void)playMusic:(NSString*)musicName target:(id)target action:(SEL)selector withObject:(id)object
{
	[self playMusic:musicName looping:NO];
	[self setMusicInvocation:[self invocationForTarget:target andSelector:selector withObject:object]];
}

- (void)stopMusic
{
	[[self musicPlayer] setDelegate:nil];
	[[self musicPlayer] stop];
	
	[self setMusicPlayer:nil];
	[self setMusicInvocation:nil];
}

- (void)stopAllSounds
{
	[self stopAllSfx];
	[self stopMusic];
}

#pragma mark -
#pragma mark Properties

- (BOOL)musicIsPlaying
{
	return [[self musicPlayer] isPlaying];
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
	if (player == [self musicPlayer])
	{
		NSInvocation* invocation = [[self musicInvocation] retain];
		[self stopMusic];
		[invocation invoke];
		[invocation release];
	}
	else if ([[self sfxPlayers] containsObject:player])
	{
		NSUInteger playerIndex = [[self sfxPlayers] indexOfObject:player];
		id nullableInvocation = [[[self sfxInvocations] objectAtIndex:playerIndex] retain];
		
		if ([nullableInvocation isMemberOfClass:[NSInvocation class]])
		{
			[nullableInvocation invoke];
		}
		
		[nullableInvocation release];
		
		if ([[self sfxPlayers] count] > 0)
		{
			[[self sfxPlayers] removeObjectAtIndex:playerIndex];
			[[self sfxInvocations] removeObjectAtIndex:playerIndex];
		}
	}
	else
	{
		HDFail(@"A unkown sound has finished.", HDFailureLevelWarning);
	}
}

#pragma mark -
#pragma mark Private Methods
	 
- (NSInvocation*)invocationForTarget:(id)target andSelector:(SEL)selector withObject:(id)object
{
	if (!target && !selector)
	{
		return nil;
	}
	
	HDCheck(isObjectNotNil(target), HDFailureLevelWarning, return nil);
	HDCheck(isSelectorNotNull(selector), HDFailureLevelWarning, return nil);
	
	NSMethodSignature* methodSignature = [target methodSignatureForSelector:selector];	
	NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
	[invocation setTarget:target];
	[invocation setSelector:selector];
	
	if (object)
	{
		[invocation setArgument:&object atIndex:2];
	}
	
	return invocation;
}

- (AVAudioPlayer*)audioPlayerWithName:(NSString*)name andType:(NSString*)type
{
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:type];
	HDCheck(isObjectNotNil(path), HDFailureLevelWarning, return nil);
	
	return [self audioPlayerWithPath:path];
}

- (AVAudioPlayer*)audioPlayerWithPath:(NSString*)path
{
	NSData* data = [NSData dataWithContentsOfFile:path];
	
	NSError* error;
	AVAudioPlayer* player = [[[AVAudioPlayer alloc] initWithData:data error:&error] autorelease];
	HDCheck(isObjectNil(error), HDFailureLevelWarning, return nil);
	
	[player setDelegate:self];
	return player;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc
{
	[self stopAllSounds];
	[self setSfxPlayers:nil];
	[self setSfxInvocations:nil];
	
	[super dealloc];
}

@end
