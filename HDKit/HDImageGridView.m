//
//  HDImageGridView.m
//  HDLibraries
//
//  Created by David Hart on 3/12/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDImageGridView.h"
#import "UIView+Geometry.h"


@interface HDImageGridView ()

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) HDSize cellCount;

@end


@implementation HDImageGridView

@synthesize dataSource = _dataSource;
@synthesize cellSize = _cellSize;
@synthesize cellCount = _cellCount;

#pragma mark - Properties

- (void)setDataSource:(id <HDImageGridViewDataSource>)dataSource
{
	if (_dataSource == dataSource)
	{
		return;
	}
	
	_dataSource = dataSource;
	[self reloadData];
}

#pragma mark - Public Methods

- (void)reloadData
{
	HDCheck(isObjectNotNil([self dataSource]), HDFailureLevelWarning, return);
	
	_cellSize = [_dataSource sizeOfCellsInGridView:self];
	_cellCount = [_dataSource numberOfCellsInGridView:self];
	
	CGSize newSize = CGSizeMake(_cellSize.width * _cellCount.width, _cellSize.height * _cellCount.height);
	[self setFrameSize:newSize];
	
	[self setNeedsDisplay];
	[[self superview] setNeedsLayout];
}

- (HDPoint)cellPositionContainingPoint:(CGPoint)point
{
	return HDPointMake(point.x / [self cellSize].width, point.y / [self cellSize].height);
}

- (CGRect)frameForCellAtPosition:(HDPoint)position
{
	return CGRectMake(position.x * [self cellSize].width,
					  position.y * [self cellSize].height,
					  [self cellSize].width,
					  [self cellSize].height);
}

#pragma mark - UIView Methods

- (void)drawRect:(CGRect)rect
{
	HDCheck(isObjectNotNil([self dataSource]), HDFailureLevelWarning, return);
	
	NSUInteger minColumn = rect.origin.x / _cellSize.width;
	NSUInteger maxColumn = (rect.origin.x + rect.size.width) / _cellSize.width;
	NSUInteger minRow = rect.origin.y / _cellSize.height;
	NSUInteger maxRow = (rect.origin.y + rect.size.height) / _cellSize.height;
	
	for (NSUInteger columnIndex = minColumn; columnIndex < maxColumn; columnIndex++)
	{
		for (NSUInteger rowIndex = minRow; rowIndex < maxRow; rowIndex++)
		{
			HDPoint cellPosition = HDPointMake(columnIndex, rowIndex);
			CGRect cellFrame = [self frameForCellAtPosition:cellPosition];
			
			UIImage* image = [[self dataSource] gridView:self imageAtPosition:cellPosition];
			[image drawInRect:cellFrame];
		}
	}
}

@end
