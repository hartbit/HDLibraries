//
//  HDAudioPlayer.m
//  TchoupiAnglais
//
//  Created by David Hart on 10/27/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDAudioPlayer.h"
#import "NimbusCore.h"


@interface HDAudioPlayer ()

@property (nonatomic, strong) NSMutableArray* sfxPlayers;
@property (nonatomic, strong) NSMutableArray* sfxBlocks;
@property (nonatomic, strong) AVAudioPlayer* musicPlayer;
@property (nonatomic, copy) void(^musicBlock)(void);

@end


@implementation HDAudioPlayer

#pragma mark -
#pragma mark Initializing Methods

+ (HDAudioPlayer*)sharedInstance
{
	static HDAudioPlayer* kSharedInstance = nil;
	
	if (!kSharedInstance) {
		kSharedInstance = [HDAudioPlayer new];
	}
	
	return kSharedInstance;
}

- (id)init
{
	if (self = [super init]) {
		[self setSfxPlayers:[NSMutableArray array]];
		[self setSfxBlocks:[NSMutableArray array]];
	}
	
	return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)playSfx:(NSString*)sfxName
{
	[self playSfx:sfxName completion:NULL];
}

- (void)playSfx:(NSString*)sfxName completion:(void(^)(void))block
{
	NIDASSERT(sfxName);
	
	AVAudioPlayer* sfxPlayer = [self audioPlayerWithName:sfxName andType:@"caf"];
	NIDASSERT(sfxPlayer);

	[[self sfxPlayers] addObject:sfxPlayer];
	
	id nullableBlock = (block != NULL) ? (id)[block copy] : (id)[NSNull null];
	[[self sfxBlocks] addObject:nullableBlock];
	
	[sfxPlayer play];
}

- (void)stopAllSfx
{
	for (AVAudioPlayer* sfxPlayer in [self sfxPlayers]) {
		[sfxPlayer setDelegate:nil];
		[sfxPlayer stop];
	}
	
	[[self sfxPlayers] removeAllObjects];
	[[self sfxBlocks] removeAllObjects];
}

- (void)playMusic:(NSString*)musicName
{
	[self playMusic:musicName completion:NULL];
}

- (void)playMusic:(NSString*)musicName looping:(BOOL)looping
{
	[self playMusic:musicName completion:NULL];
	[[self musicPlayer] setNumberOfLoops:looping ? -1 : 0];
}

- (void)playMusic:(NSString*)musicName completion:(void(^)(void))block
{
	NIDASSERT(musicName);
	
	AVAudioPlayer* musicPlayer = [self audioPlayerWithName:musicName andType:@"m4a"];
	NIDASSERT(musicPlayer);
	
	[self setMusicPlayer:musicPlayer];
	[self setMusicBlock:block];
	
	[musicPlayer play];
}

- (void)stopMusic
{
	[[self musicPlayer] setDelegate:nil];
	[[self musicPlayer] stop];
	
	[self setMusicPlayer:nil];
	[self setMusicBlock:NULL];
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
	if (player == [self musicPlayer]) {
		void(^musicBlock)(void) = [self musicBlock];
		[self stopMusic];
		
		if (musicBlock != NULL) {
			musicBlock();
		}
	} else if ([[self sfxPlayers] containsObject:player]) {
		NSUInteger playerIndex = [[self sfxPlayers] indexOfObject:player];
		id nullableBlock = [[self sfxBlocks] objectAtIndex:playerIndex];
		
		if (![nullableBlock isMemberOfClass:[NSNull class]]) {
			((void(^)(void))nullableBlock)();
		}
		
		[[self sfxPlayers] removeObjectAtIndex:playerIndex];
		[[self sfxBlocks] removeObjectAtIndex:playerIndex];
	} else {
		NIDERROR(@"A unkown sound has finished.");
	}
}

#pragma mark -
#pragma mark Private Methods

- (AVAudioPlayer*)audioPlayerWithName:(NSString*)name andType:(NSString*)type
{
	NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:type];
	NIDASSERT(path);
	
	return [self audioPlayerWithPath:path];
}

- (AVAudioPlayer*)audioPlayerWithPath:(NSString*)path
{
	NSData* data = [NSData dataWithContentsOfFile:path];
	
	NSError* error = nil;
	AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithData:data error:&error];
	NIDASSERT(!error);
	
	[player setDelegate:self];
	return player;
}

@end
