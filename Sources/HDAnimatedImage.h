//
//  HDAnimatedImage.h
//  Library
//
//  Created by David Hart on 22/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved
//

#import <UIKit/UIKit.h>


@protocol HDAnimatedImageDelegate;

@interface HDAnimatedImage : UIImageView

@property (nonatomic, copy) NSString* animationName;
@property (nonatomic, assign) NSUInteger framesPerSecond;
@property (nonatomic, assign) BOOL stopsOnLastFrame;
@property (nonatomic, assign) IBOutlet id <HDAnimatedImageDelegate> delegate;

- (void)play;
- (void)stop;

@end

@protocol HDAnimatedImageDelegate <NSObject>

- (void)animatedImageDidFinishPlaying:(HDAnimatedImage*)animatedImage;

@end