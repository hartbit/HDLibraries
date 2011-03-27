//
//  HDDrawableView.h
//  HDFoundation
//
//  Created by David Hart on 22/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved
//

#import <UIKit/UIKit.h>


@protocol HDDrawableViewDataSource;
@protocol HDDrawableViewDelegate;

@interface HDDrawableView : UIView

@property (nonatomic, assign) IBOutlet id <HDDrawableViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id <HDDrawableViewDelegate> delegate;
@property (nonatomic, assign) CGFloat distanceThreshold;

- (void)clear;

@end


@protocol HDDrawableViewDataSource <NSObject>

@required
- (CGFloat)sizeOfBrushForDrawableView:(HDDrawableView*)drawableView;
- (UIColor*)colorOfBrushForDrawableView:(HDDrawableView*)drawableView;

@end

@protocol HDDrawableViewDelegate <NSObject>

@optional
- (void)drawableViewWillStartDrawing:(HDDrawableView*)drawableView;
- (void)drawableViewDidEndDrawing:(HDDrawableView*)drawableView;

@end