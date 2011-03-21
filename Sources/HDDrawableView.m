//
//  HDDrawableView.m
//  HDFoundation
//
//  Created by David Hart on 5/18/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDDrawableView.h"
#import "HDMacros.h"
#import <QuartzCore/QuartzCore.h>


@interface HDDrawableView ()

@property (nonatomic, assign) BOOL mouseSwiped;

- (void)initialize;
- (void)addNewLayerWithPoint:(CGPoint)point;
- (void)updateLastLayerWithPoint:(CGPoint)point;
- (void)startDrawing;
- (void)endDrawing;

@end


@implementation HDDrawableView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize mouseSwiped = _mouseSwiped;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder*)coder
{
	self = [super initWithCoder:coder];
	if (!self) return nil;
	
	[self initialize];
	
	return self;
}
			   
- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (!self) return nil;
	
	[self initialize];

	return self;
}

- (void)initialize
{
	[self setOpaque:NO];
	[self setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Public Methods

- (void)clear
{
	for (CALayer* sublayer in [[self layer] sublayers])
	{
		[sublayer removeFromSuperlayer];
	}
	
	[self setNeedsDisplay];
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{	
	[self setMouseSwiped:NO];
	[self addNewLayerWithPoint:[[touches anyObject] locationInView:self]];
	[self startDrawing];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self setMouseSwiped:YES];
	[self updateLastLayerWithPoint:[[touches anyObject] locationInView:self]];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (![self mouseSwiped])
	{
		[self updateLastLayerWithPoint:[[touches anyObject] locationInView:self]];
	}
	
	[self endDrawing];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self endDrawing];
}

#pragma mark - Private Methods

- (void)addNewLayerWithPoint:(CGPoint)point
{
	CAShapeLayer* newShapeLayer = [[CAShapeLayer alloc] init];
	[newShapeLayer setLineCap:kCALineCapRound];
	[newShapeLayer setLineJoin:kCALineJoinRound];
	
	// Set Line Width
	
	CGFloat brushSize = 20;
	
	if ([[self dataSource] respondsToSelector:@selector(sizeOfBrushForDrawableView:)])
	{
		brushSize = [[self dataSource] sizeOfBrushForDrawableView:self];
	}
	
	[newShapeLayer setLineWidth:brushSize];
	
	// Get color
	
	UIColor* color = [UIColor blackColor];
	
	if ([[self dataSource] respondsToSelector:@selector(colorOfBrushForDrawableView:)])
	{
		color = [[self dataSource] colorOfBrushForDrawableView:self];
	}
	
	[newShapeLayer setStrokeColor:[color CGColor]];
	
	// Set start position
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	[newShapeLayer setPath:path];
	CGPathRelease(path);
	
	[[self layer] addSublayer:newShapeLayer];
}

- (void)updateLastLayerWithPoint:(CGPoint)point
{
	CAShapeLayer* lastShapeLayer = [[[self layer] sublayers] lastObject];
	
	CGMutablePathRef path = CGPathCreateMutableCopy([lastShapeLayer path]);
	CGPathAddLineToPoint(path, NULL, point.x, point.y);
	[lastShapeLayer setPath:path];
	CGPathRelease(path);
}

- (void)startDrawing
{
	if ([[self delegate] respondsToSelector:@selector(drawableViewWillStartDrawing:)])
	{
		[[self delegate] drawableViewWillStartDrawing:self];
	}
}

- (void)endDrawing
{
	if ([[self delegate] respondsToSelector:@selector(drawableViewDidEndDrawing:)])
	{
		[[self delegate] drawableViewDidEndDrawing:self];
	}
}

@end
