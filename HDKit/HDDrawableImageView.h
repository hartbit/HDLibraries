//
//  HDDrawableImage.h
//  HDLibraries
//
//  Created by David Hart on 22/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved
//

#import <UIKit/UIKit.h>


@protocol HDDrawableImageViewDataSource;
@protocol HDDrawableImageViewDelegate;

@interface HDDrawableImageView : UIImageView

@property (nonatomic, assign) IBOutlet id <HDDrawableImageViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id <HDDrawableImageViewDelegate> delegate;
@property (nonatomic, retain) UIImage* clipImage;
@property (nonatomic, assign) CGFloat distanceThreshold;

- (void)clear;

@end


@protocol HDDrawableImageViewDataSource <NSObject>

@required
- (CGFloat)sizeOfBrushForDrawableImageView:(HDDrawableImageView*)drawableImageView;
- (UIColor*)colorOfBrushForDrawableImageView:(HDDrawableImageView*)drawableImageView;

@end

@protocol HDDrawableImageViewDelegate <NSObject>

@optional
- (void)drawableImageViewWillStartDrawing:(HDDrawableImageView*)drawableImageView;
- (void)drawableImageViewDidEndDrawing:(HDDrawableImageView*)drawableImageView;

@end