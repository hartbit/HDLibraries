//
//  HDAnimatedImage.h
//  HDFoundation
//
//  Created by David Hart on 22/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved
//

#import <UIKit/UIKit.h>


@protocol HDAnimatedImageDelegate;

@interface HDAnimatedImage : UIImageView

@property (nonatomic, copy) NSString* animationName;
@property (nonatomic, assign) BOOL stopsOnLastFrame;
@property (nonatomic, assign) IBOutlet id <HDAnimatedImageDelegate> delegate;

@end

@protocol HDAnimatedImageDelegate <NSObject>

@optional
- (void)animatedImageDidFinishAnimating:(HDAnimatedImage*)animatedImage;

@end