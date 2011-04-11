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
@property (nonatomic, assign) CAShapeLayer* gridLayer;

- (void)initialize;
- (void)updateSize;
- (void)updateGridLayer;
- (void)updateCellLayers;

@end


@implementation HDImageGridView

@synthesize dataSource = _dataSource;
@synthesize cellSize = _cellSize;
@synthesize cellCount = _cellCount;
@synthesize gridLayer = _gridLayer;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder*)coder
{
	if ((self = [super initWithCoder:coder]))
	{
		[self initialize];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self initialize];
	}
	
	return self;
}

- (void)initialize
{
	[[self layer] setShouldRasterize:YES];
	[self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"dataSource"];
	
	[super dealloc];
}

#pragma mark - Properties

- (CAShapeLayer*)gridLayer
{
	CALayer* viewLayer = [self layer];
	
	if (_gridLayer == nil)
	{
		CAShapeLayer* gridLayer = [CAShapeLayer layer];
		[gridLayer setLineWidth:2];
		[gridLayer setStrokeColor:[[UIColor blackColor] CGColor]];
		[gridLayer setHidden:[self isGridHidden]];
		
		[viewLayer addSublayer:gridLayer];
		[self setGridLayer:gridLayer];
	}
	
	return [[viewLayer sublayers] lastObject];
}

- (BOOL)isGridHidden
{
	if (_gridLayer == nil)
	{
		return YES;
	}
	else
	{
		return [_gridLayer isHidden];
	}
}

- (void)setGridHidden:(BOOL)gridHidden
{
	[[self gridLayer] setHidden:gridHidden];
}

#pragma mark - Public Methods

- (void)reloadData
{
	HDCheck(isObjectNotNil([self dataSource]), HDFailureLevelWarning, return);
	
	[self updateSize];
	[self updateGridLayer];
	[self updateCellLayers];
	[self setNeedsDisplay];
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

#pragma mark - Private Methods

- (void)updateSize
{
	[self setCellSize:[[self dataSource] sizeOfCellsInGridView:self]];
	[self setCellCount:[[self dataSource] numberOfCellsInGridView:self]];
	
	CGSize newSize = CGSizeMake([self cellSize].width * [self cellCount].width, [self cellSize].height * [self cellCount].height);
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

- (void)updateCellLayers
{
	CALayer* viewLayer = [self layer];
	NSArray* sublayers = [viewLayer sublayers];
	HDSize cellCount = [self cellCount];
	
	NSUInteger requiredSublayersCount = cellCount.width * cellCount.height + 1;
	
	if ([sublayers count] < requiredSublayersCount)
	{
		NSUInteger difference = requiredSublayersCount - [sublayers count];
		
		for (NSUInteger index = 0; index < difference; index++)
		{
			[viewLayer insertSublayer:[CALayer layer] below:[self gridLayer]];
		}
	}
	else if ([sublayers count] > requiredSublayersCount)
	{
		NSUInteger difference = [sublayers count] - requiredSublayersCount;
		
		for (NSUInteger index = 0; index < difference; index++)
		{
			[[sublayers objectAtIndex:index] removeFromSuperlayer];
		}
	}
}

- (void)observeValueForKeyPath:(NSString*)path ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
	if ([path isEqualToString:@"dataSource"])
	{
		[self reloadData];
	}
	else
	{
		[super observeValueForKeyPath:path ofObject:object change:change context:context];
	}
}

#pragma mark - UIView Methods

- (void)drawRect:(CGRect)rect
{
	HDCheck(isObjectNotNil([self dataSource]), HDFailureLevelWarning, return);
	
	NSUInteger minColumn = rect.origin.x / _cellSize.width;
	NSUInteger maxColumn = (rect.origin.x + rect.size.width) / _cellSize.width;
	NSUInteger minRow = rect.origin.y / _cellSize.height;
	NSUInteger maxRow = (rect.origin.y + rect.size.height) / _cellSize.height;
	NSArray* sublayers = [[self layer] sublayers];
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	for (NSUInteger columnIndex = minColumn; columnIndex < maxColumn; columnIndex++)
	{
		for (NSUInteger rowIndex = minRow; rowIndex < maxRow; rowIndex++)
		{
			NSUInteger layerIndex = rowIndex * [self cellCount].width + columnIndex;
			CALayer* cellLayer = [sublayers objectAtIndex:layerIndex];
			
			HDPoint cellPosition = HDPointMake(columnIndex, rowIndex);
			UIImage* image = [[self dataSource] gridView:self imageAtPosition:cellPosition];
			
			if (image != nil)
			{
				[cellLayer setFrame:[self frameForCellAtPosition:cellPosition]];
				[cellLayer setContents:(id)[image CGImage]];
				
				if ([[self dataSource] respondsToSelector:@selector(gridView:transformAtPosition:)])
				{
					CGAffineTransform transform = [[self dataSource] gridView:self transformAtPosition:cellPosition];
					[cellLayer setAffineTransform:transform];
				}
			}
		}
	}
	
	[CATransaction commit];
}
 
@end
