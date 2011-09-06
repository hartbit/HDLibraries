//
//  HDAudioPlayer.h
//  TchoupiAnglais
//
//  Created by David Hart on 10/27/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface HDAudioPlayer : NSObject <AVAudioPlayerDelegate>

@property (nonatomic, readonly, getter=musicIsPlaying) BOOL musicPlaying;

+ (HDAudioPlayer*)sharedInstance;

- (void)playSfx:(NSString*)sfxName;
- (void)playSfx:(NSString*)sfxName completion:(void(^)(void))block;

- (void)playMusic:(NSString*)musicName;
- (void)playMusic:(NSString*)musicName looping:(BOOL)looping;
- (void)playMusic:(NSString*)musicName completion:(void(^)(void))block;

- (void)stopMusic;
- (void)stopAllSfx;
- (void)stopAllSounds;

@end
