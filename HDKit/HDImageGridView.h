//
//  HDImageGridView.h
//  HDLibraries
//
//  Created by David Hart on 3/12/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDFoundation.h"


@protocol HDImageGridViewDataSource;

@interface HDImageGridView : UIView

@property (nonatomic, assign ) id <HDImageGridViewDataSource> dataSource;

- (void)reloadData;
- (HDPoint)cellPositionContainingPoint:(CGPoint)point;
- (CGRect)frameForCellAtPosition:(HDPoint)position;

@end


@protocol HDImageGridViewDataSource <NSObject>

@required
- (CGSize)sizeOfCellsInGridView:(HDImageGridView*)gridView;
- (HDSize)numberOfCellsInGridView:(HDImageGridView*)gridView;
- (UIImage*)gridView:(HDImageGridView*)gridView imageAtPosition:(HDPoint)position;

@optional
- (CGAffineTransform)gridView:(HDImageGridView*)gridView transformAtPosition:(HDPoint)position;

@end