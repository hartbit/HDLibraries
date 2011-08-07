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

- (void)setTitle:(NSString*)title forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row;
- (void)setImage:(UIImage*)image forSegmentAtColumn:(NSUInteger)column row:(NSUInteger)row;

@end
