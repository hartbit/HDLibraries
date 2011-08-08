//
//  HDMatrixControl.h
//  HDLibraries
//
//  Created by David Hart on 05.08.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HDMatrixControl : UIView

@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) UIImage* verticalDividerImage;
@property (nonatomic, strong) UIImage* horizontalDividerImage;
@property (nonatomic, assign, readonly) NSUInteger selectedColumn;
@property (nonatomic, assign, readonly) NSUInteger selectedRow;

- (NSString*)titleForSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (void)setTitle:(NSString*)title forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row;

- (UIImage*)imageForSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (void)setImage:(UIImage*)image forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row;

- (UIImage*)backgroundImageForState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage*)image forState:(UIControlState)state;

@end
