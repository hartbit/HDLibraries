//
//  HDImageGridLayer.h
//  HDLibraries
//
//  Created by David Hart on 3/12/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDFoundation.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@protocol HDImageGridLayerDataSource;

@interface HDImageGridLayer : CALayer

@property (nonatomic, assign) id <HDImageGridLayerDataSource> dataSource;
@property (nonatomic, assign, getter=isGridVisible) BOOL gridVisible;

- (void)reloadData;
- (HDPoint)cellPositionContainingPoint:(CGPoint)point;
- (CGRect)frameForCellAtPosition:(HDPoint)position;

@end


@protocol HDImageGridLayerDataSource <NSObject>

@required
- (CGSize)sizeOfCellsInGridLayer:(HDImageGridLayer*)gridLayer;
- (HDSize)numberOfCellsInGridLayer:(HDImageGridLayer*)gridLayer;
- (UIImage*)gridLayer:(HDImageGridLayer*)gridLayer imageAtPosition:(HDPoint)position;

@end