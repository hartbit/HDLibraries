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

@property (nonatomic, readonly, getter=ambianceIsPlaying) BOOL ambiancePlaying;
@property (nonatomic, readonly, getter=voiceIsPlaying) BOOL voicePlaying;

+ (HDAudioPlayer*)sharedInstance;

- (void)playAmbiance:(NSString*)ambianceName;
- (void)stopAmbiance;

- (void)playSfx:(NSString*)sfxName;
- (void)playSfx:(NSString*)sfxName target:(id)target action:(SEL)selector;
- (void)playSfx:(NSString*)sfxName target:(id)target action:(SEL)selector withObject:(id)object;

- (void)playVoice:(NSString*)voiceName;
- (void)playVoice:(NSString*)voiceName target:(id)target action:(SEL)selector;
- (void)playVoice:(NSString*)voiceName target:(id)target action:(SEL)selector withObject:(id)object;

- (void)stopVoice;
- (void)stopAllSfx;
- (void)stopAllSounds;

@end
