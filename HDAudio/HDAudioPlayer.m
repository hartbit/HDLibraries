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

@property (nonatomic, retain) NSMutableArray* sfxPlayers;
@property (nonatomic, retain) NSMutableArray* sfxInvocations;
@property (nonatomic, retain) AVAudioPlayer* ambiancePlayer;
@property (nonatomic, retain) AVAudioPlayer* voicePlayer;
@property (nonatomic, retain) NSInvocation* voiceInvocation;

- (NSInvocation*)invocationForTarget:(id)target andSelector:(SEL)selector withObject:(id)object;
- (AVAudioPlayer*)audioPlayerWithName:(NSString*)name andType:(NSString*)type;
- (AVAudioPlayer*)audioPlayerWithPath:(NSString*)path;

@end


@implementation HDAudioPlayer

@synthesize sfxPlayers = _sfxPlayers;
@synthesize sfxInvocations = _sfxInvocations;
@synthesize ambiancePlayer = _ambiancePlayer;
@synthesize voicePlayer = _voicePlayer;
@synthesize voiceInvocation = _voiceInvocation;

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

- (void)playAmbiance:(NSString*)ambianceName
{
	HDCheck(isObjectNotNil(ambianceName), HDFailureLevelWarning, return);
	
	[self stopAmbiance];
	[self setAmbiancePlayer:[self audioPlayerWithName:ambianceName andType:@"caf"]];
	
	[[self ambiancePlayer] setNumberOfLoops:-1];
	[[self ambiancePlayer] setVolume:0.15];
	[[self ambiancePlayer] play];
}

- (void)stopAmbiance
{
	[[self ambiancePlayer] stop];
	[self setAmbiancePlayer:nil];
}

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

- (void)playVoice:(NSString*)voiceName
{
	[self playVoice:voiceName target:nil action:NULL withObject:nil];
}

- (void)playVoice:(NSString*)voiceName target:(id)target action:(SEL)selector
{
	[self playVoice:voiceName target:target action:selector withObject:nil];
}

- (void)playVoice:(NSString*)voiceName target:(id)target action:(SEL)selector withObject:(id)object
{
	HDCheck(isObjectNotNil(voiceName), HDFailureLevelWarning, return);
	
	AVAudioPlayer* voicePlayer = [self audioPlayerWithName:voiceName andType:@"m4a"];
	HDCheck(isObjectNotNil(voicePlayer), HDFailureLevelWarning, return);
	
	[self stopVoice];
	[self setVoicePlayer:voicePlayer];
	[self setVoiceInvocation:[self invocationForTarget:target andSelector:selector withObject:object]];
	
	[voicePlayer play];
}

- (void)stopVoice
{
	[[self voicePlayer] setDelegate:nil];
	[[self voicePlayer] stop];
	
	[self setVoicePlayer:nil];
	[self setVoiceInvocation:nil];
}

- (void)stopAllSounds
{
	[self stopAmbiance];
	[self stopAllSfx];
	[self stopVoice];
}

#pragma mark -
#pragma mark Properties

- (BOOL)ambianceIsPlaying
{
	return [[self ambiancePlayer] isPlaying];
}

- (BOOL)voiceIsPlaying
{
	return [[self voicePlayer] isPlaying];
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
	if (player == [self voicePlayer])
	{
		NSInvocation* invocation = [[self voiceInvocation] retain];
		[self stopVoice];
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
