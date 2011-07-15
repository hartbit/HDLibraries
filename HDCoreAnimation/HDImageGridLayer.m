//
//  HDImageGridLayer.m
//  HDLibraries
//
//  Created by David Hart on 3/12/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDImageGridLayer.h"
#import "CALayer+HDGeometry.h"
#import <QuartzCore/QuartzCore.h>


@interface HDImageGridLayer ()

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) HDSize cellCount;
@property (nonatomic, assign) CAShapeLayer* gridLayer;

- (void)updateSize;
- (void)updateGridLayer;

@end


@implementation HDImageGridLayer

@synthesize dataSource = _dataSource;
@synthesize cellSize = _cellSize;
@synthesize cellCount = _cellCount;
@synthesize gridLayer = _gridLayer;

#pragma mark - Initialization

- (id)init
{
	if ((self = [super init]))
	{
		[self setOpaque:YES];
	}
	
	return self;
}

#pragma mark - Properties

- (void)setDataSource:(id<HDImageGridLayerDataSource>)dataSource
{
	if (_dataSource != dataSource)
	{
		_dataSource = dataSource;
		
		if (dataSource != nil)
		{
			[self reloadData];
		}
	}
}

- (CAShapeLayer*)gridLayer
{	
	if (_gridLayer == nil)
	{
		CAShapeLayer* gridLayer = [CAShapeLayer layer];
		[gridLayer setLineWidth:2];
		[gridLayer setStrokeColor:[[UIColor blackColor] CGColor]];
		[gridLayer setHidden:![self isGridVisible]];
		
		[self addSublayer:gridLayer];
		[self setGridLayer:gridLayer];
	}
	
	return _gridLayer;
}

- (BOOL)isGridVisible
{
	if (_gridLayer == nil)
	{
		return NO;
	}
	else
	{
		return ![_gridLayer isHidden];
	}
}

- (void)setGridVisible:(BOOL)gridVisible
{
	[[self gridLayer] setHidden:!gridVisible];
}

#pragma mark - Public Methods

- (void)reloadData
{
	HDCheck(isObjectNotNil([self dataSource]), HDFailureLevelWarning, return);
	
	[self updateSize];
	[self updateGridLayer];
	[self setNeedsDisplay];
}

- (HDPoint)positionOfCellContainingPoint:(CGPoint)point
{
	return HDPointMake(point.x / [self cellSize].width,
					   point.y / [self cellSize].height);
}

- (CGRect)frameForCellAtPosition:(HDPoint)position
{
	return CGRectMake(position.x * [self cellSize].width,
					  position.y * [self cellSize].height,
					  [self cellSize].width,
					  [self cellSize].height);
}

#pragma mark - Private Methods

- (void)updateSize
{
	[self setCellSize:[[self dataSource] sizeOfCellsInGridLayer:self]];
	[self setCellCount:[[self dataSource] numberOfCellsInGridLayer:self]];
	
	CGFloat newWidth = [self cellSize].width * [self cellCount].width;
	CGFloat newHeight = [self cellSize].height * [self cellCount].height;
	CGSize newSize = CGSizeMake(newWidth, newHeight);
	[self setFrameSize:newSize];
}

- (void)updateGridLayer
{	
	CGMutablePathRef path = CGPathCreateMutable();
	
	for (NSUInteger columnIndex = 0; columnIndex <= [self cellCount].width; columnIndex++)
	{
		CGFloat columnPostion = columnIndex * [self cellSize].width;
		CGPathMoveToPoint(path, NULL, columnPostion, 0);
		CGPathAddLineToPoint(path, NULL, columnPostion, [self boundsSize].height);
	}
	
	for (NSUInteger rowIndex = 0; rowIndex <= [self cellCount].height; rowIndex++)
	{
		CGFloat rowPosition = rowIndex * [self cellSize].height;
		CGPathMoveToPoint(path, NULL, 0, rowPosition);
		CGPathAddLineToPoint(path, NULL, [self boundsSize].width, rowPosition);
	}
	
	CAShapeLayer* gridLayer = [self gridLayer];
	[gridLayer setFrame:[self bounds]];
	[gridLayer setPath:path];
	
	CGPathRelease(path);
}

#pragma mark - CALayer Methods

- (void)drawInContext:(CGContextRef)context
{
	if ([self dataSource] == nil)
	{
		return;
	}
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	CGSize cellSize = [self cellSize];
	CGRect clipRect = CGContextGetClipBoundingBox(context);
	NSUInteger minColumn = CGRectGetMinX(clipRect) / cellSize.width;
	NSUInteger maxColumn = CGRectGetMaxX(clipRect) / cellSize.width;
	NSUInteger minRow = CGRectGetMinY(clipRect) / cellSize.height;
	NSUInteger maxRow = CGRectGetMaxY(clipRect) / cellSize.height;

	UIGraphicsPushContext(context);
	
	for (NSUInteger rowIndex = minRow; rowIndex < maxRow; rowIndex++)
	{
		for (NSUInteger columnIndex = minColumn; columnIndex < maxColumn; columnIndex++)
		{
			HDPoint position = HDPointMake(columnIndex, rowIndex);
			UIImage* image = [[self dataSource] gridLayer:self imageAtPosition:position];
			
			if (image != nil)
			{
				CGRect rect = [self frameForCellAtPosition:position];
				[image drawInRect:rect];
			}
		}
	}
	
	UIGraphicsPopContext();
	
	[CATransaction commit];
}

@end
