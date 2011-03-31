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
	static HDAudioPlayer* sharedInstance = nil;
	
	if (sharedInstance == nil)
	{
		sharedInstance = [[HDAudioPlayer alloc] init];
	}
	
	return sharedInstance;
}

- (id)init
{
	self = [super init];
	if (!self) return nil;

	[self setSfxPlayers:[NSMutableArray array]];
	[self setSfxInvocations:[NSMutableArray array]];
	
	return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)playAmbiance:(NSString*)ambianceName
{
	HDCheck(isObjectNotNil(ambianceName), HDFailureLevelWarning, return);
	
	[self stopAmbiance];
	[self setAmbiancePlayer:[self audioPlayerWithName:ambianceName andType:@"caf"]];
	
	[_ambiancePlayer setNumberOfLoops:-1];
	[_ambiancePlayer setVolume:0.15];
	[_ambiancePlayer play];
}

- (void)stopAmbiance
{
	[_ambiancePlayer stop];
	[self setAmbiancePlayer:nil];
}

- (void)playSfx:(NSString*)sfxName
{
	[self playSfx:sfxName target:nil action:NULL];
}

- (void)playSfx:(NSString*)sfxName target:(id)target action:(SEL)selector
{
	HDCheck(isObjectNotNil(sfxName), HDFailureLevelWarning, return);
	
	AVAudioPlayer* sfxPlayer = [self audioPlayerWithName:sfxName andType:@"caf"];
	HDCheck(isObjectNotNil(sfxPlayer), HDFailureLevelWarning, return);
	[_sfxPlayers addObject:sfxPlayer];
	
	NSInvocation* sfxInvocation = [self invocationForTarget:target andSelector:selector withObject:nil];
	id nullableInvocation = (sfxInvocation != nil) ? (id)sfxInvocation : (id)[NSNull null];
	[_sfxInvocations addObject:nullableInvocation];
	
	[sfxPlayer play];
}

- (void)stopAllSfx
{
	for (AVAudioPlayer* sfxPlayer in _sfxPlayers)
	{
		[sfxPlayer setDelegate:nil];
		[sfxPlayer stop];
	}
	
	[_sfxPlayers removeAllObjects];
	[_sfxInvocations removeAllObjects];
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
	[_voicePlayer setDelegate:nil];
	[_voicePlayer stop];
	
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
	return [_ambiancePlayer isPlaying];
}

- (BOOL)voiceIsPlaying
{
	return [_voicePlayer isPlaying];
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
	if (player == _voicePlayer)
	{
		NSInvocation* invocation = [_voiceInvocation retain];
		[self stopVoice];
		[invocation invoke];
	}
	else if ([_sfxPlayers containsObject:player])
	{
		NSUInteger playerIndex = [_sfxPlayers indexOfObject:player];
		id nullableInvocation = [_sfxInvocations objectAtIndex:playerIndex];
		
		if ([nullableInvocation isMemberOfClass:[NSInvocation class]])
		{
			[nullableInvocation invoke];
		}
		
		[_sfxPlayers removeObjectAtIndex:playerIndex];
		[_sfxInvocations removeObjectAtIndex:playerIndex];
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
