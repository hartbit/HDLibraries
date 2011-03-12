//
//  HDImageGridView.m
//  HDFoundation
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
	if (_dataSource != dataSource)
	{
		_dataSource = dataSource;
		[self reloadData];
	}
}

#pragma mark - Public Methods

- (void)reloadData
{
	if (!_dataSource) return;
	
	_cellSize = [_dataSource sizeOfCellsInGridView:self];
	_cellCount = [_dataSource numberOfCellsInGridView:self];
	
	CGSize newSize = CGSizeMake(_cellSize.width * _cellCount.width, _cellSize.height * _cellCount.height);
	[self setFrameSize:newSize];
	
	[self setNeedsDisplay];
}

- (CGRect)frameForCellAtPosition:(HDPoint)position
{
	return CGRectMake(position.x * _cellSize.width, position.y * _cellSize.height, _cellSize.width, _cellSize.height);
}

#pragma mark - UIView Methods

- (void)drawRect:(CGRect)rect
{
	if (!_dataSource) return;
	
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
			
			UIImage* image = [_dataSource gridView:self imageAtPosition:cellPosition];
			[image drawInRect:cellFrame];
		}
	}
}

@end
