//
//  HDImageGridView.m
//  HDLibraries
//
//  Created by David Hart on 3/12/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDImageGridView.h"
#import "UIView+Geometry.h"
#import <QuartzCore/QuartzCore.h>


@interface HDImageGridView ()

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) HDSize cellCount;
@property (nonatomic, assign) CAShapeLayer* gridLayer;
@property (nonatomic, retain) NSMutableDictionary* layers;

- (void)initialize;
- (void)updateSize;
- (void)updateGridLayer;
- (CALayer*)layerAtPosition:(HDPoint)position;
- (void)removeLayerAtPosition:(HDPoint)position;

@end


@implementation HDImageGridView

@synthesize dataSource = _dataSource;
@synthesize postponesRendering = _postponesRendering;
@synthesize cellSize = _cellSize;
@synthesize cellCount = _cellCount;
@synthesize gridLayer = _gridLayer;
@synthesize layers = _layers;

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
	[self setLayers:[NSMutableDictionary dictionary]];
	
	[self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:NULL];
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self removeObserver:self forKeyPath:@"dataSource"];
	
	[self setLayers:nil];
	
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
		[gridLayer setHidden:![self isGridVisible]];
		
		[viewLayer addSublayer:gridLayer];
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

- (CALayer*)layerAtPosition:(HDPoint)position
{
	NSString* key = NSStringFromHDPoint(position);
	CALayer* layer = [[self layers] objectForKey:key];
	
	if (layer == nil)
	{
		layer = [CALayer layer];
		[layer setFrame:[self frameForCellAtPosition:position]];
		[layer setContentsScale:[[UIScreen mainScreen] scale]];
		[[self layer] insertSublayer:layer below:[self gridLayer]];
		[[self layers] setObject:layer forKey:key];
	}
	
	return layer;
}

- (void)removeLayerAtPosition:(HDPoint)position
{
	NSString* key = NSStringFromHDPoint(position);
	CALayer* layer = [[self layers] objectForKey:key];
	
	if (layer != nil)
	{
		[layer removeFromSuperlayer];
		[[self layers] removeObjectForKey:key];
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
	
	CGSize cellSize = [self cellSize];
	NSUInteger minColumn = rect.origin.x / cellSize.width;
	NSUInteger maxColumn = (rect.origin.x + rect.size.width) / cellSize.width;
	NSUInteger minRow = rect.origin.y / cellSize.height;
	NSUInteger maxRow = (rect.origin.y + rect.size.height) / cellSize.height;
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	for (NSUInteger columnIndex = minColumn; columnIndex < maxColumn; columnIndex++)
	{
		for (NSUInteger rowIndex = minRow; rowIndex < maxRow; rowIndex++)
		{
			HDPoint cellPosition = HDPointMake(columnIndex, rowIndex);
			UIImage* image = [[self dataSource] gridView:self imageAtPosition:cellPosition];
		
			if (image == nil)
			{
				[self removeLayerAtPosition:cellPosition];
				continue;
			}
			
			CALayer* cellLayer = [self layerAtPosition:cellPosition];
			[cellLayer setContents:(id)[image CGImage]];
			
			if ([[self dataSource] respondsToSelector:@selector(gridView:transformAtPosition:)])
			{
				CGAffineTransform transform = [[self dataSource] gridView:self transformAtPosition:cellPosition];
				[cellLayer setAffineTransform:transform];
			}
		}
	}
	
	[CATransaction commit];
}
 
@end
