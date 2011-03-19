//
//  DrawableImage.h
//  HDFoundation
//
//  Created by David Hart on 22/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved
//

#import <UIKit/UIKit.h>
#import "HDIrregularImage.h"


@protocol HDDrawableImageDataSource;
@protocol HDDrawableImageDelegate;

@interface HDDrawableImage : HDIrregularImage

@property (nonatomic, assign) IBOutlet id <HDDrawableImageDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id <HDDrawableImageDelegate> delegate;

- (void)clear;

@end


@protocol HDDrawableImageDelegate <NSObject>

@optional
- (void)drawableImageWillStartDrawing:(HDDrawableImage*)drawableImage;
- (void)drawableImageDidEndDrawing:(HDDrawableImage*)drawableImage;

@end


@protocol HDDrawableImageDataSource <NSObject>

@required
- (CGFloat)sizeOfBrushForDrawableImage:(HDDrawableImage*)drawableImage;
- (UIColor*)colorOfBrushForDrawableImage:(HDDrawableImage*)drawableImage;

@end