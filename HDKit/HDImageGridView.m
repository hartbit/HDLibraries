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

- (void)initialize;

@end


@implementation HDImageGridView

@synthesize dataSource = _dataSource;
@synthesize cellSize = _cellSize;
@synthesize cellCount = _cellCount;

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
	[self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"dataSource"];
	
	[super dealloc];
}

#pragma mark - Public Methods

- (void)reloadData
{
	HDCheck(isObjectNotNil([self dataSource]), HDFailureLevelWarning, return);
	
	[self setCellSize:[[self dataSource] sizeOfCellsInGridView:self]];
	[self setCellCount:[[self dataSource] numberOfCellsInGridView:self]];
	
	CGSize newSize = CGSizeMake(_cellSize.width * _cellCount.width, _cellSize.height * _cellCount.height);
	[self setFrameSize:newSize];
	
	CALayer* viewLayer = [self layer];
	NSArray* sublayers = [viewLayer sublayers];
	
	// Add or remove CALayers to have just enough
	
	HDSize cellCount = [self cellCount];
	NSUInteger requiredSublayersCount = cellCount.width * cellCount.height;
	
	if ([sublayers count] < requiredSublayersCount)
	{
		NSUInteger difference = requiredSublayersCount - [sublayers count];
		
		for (NSUInteger index = 0; index < difference; index++)
		{
			[viewLayer addSublayer:[CALayer layer]];
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
	
	// Configure all sublayers
	
	[viewLayer setShouldRasterize:YES];
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
