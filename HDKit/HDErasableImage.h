//
//  ModifiableImage.h
//  HDLibraries
//
//  Created by David Hart on 28/05/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HDErasableImageDelegate;

@interface HDErasableImage : UIView

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, assign, readonly) BOOL erasing;
@property (nonatomic, assign, readonly) CGFloat completion;
@property (nonatomic, assign) id <HDErasableImageDelegate> delegate;

- (id)initWithImage:(UIImage*)image erasing:(BOOL)erasing;

@end


@protocol HDErasableImageDelegate <NSObject>

@optional
- (void)erasableImageWillStartErasing:(HDErasableImage*)erasableImage;
- (void)erasableImage:(HDErasableImage*)erasableImage isErasingWithCompletionPercentage:(CGFloat)completion;
- (void)erasableImageDidEndErasing:(HDErasableImage*)erasableImage;

@end