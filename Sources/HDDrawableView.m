//
//  HDDrawableView.m
//  HDFoundation
//
//  Created by David Hart on 5/18/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDDrawableView.h"
#import "HDMacros.h"
#import "HDFunctions.h"
#import <QuartzCore/QuartzCore.h>


@interface HDDrawableView ()

@property (nonatomic, assign) BOOL mouseSwiped;
@property (nonatomic, readonly) CGFloat brushSize;
@property (nonatomic, readonly) UIColor* brushColor;

- (void)initialize;
- (void)updateLayersWithNewTouches:(NSSet*)touches;
- (void)updateLayersWithContinuedTouches:(NSSet*)touches force:(BOOL)force;
- (CAShapeLayer*)currentLayer;
- (void)startDrawing;
- (void)endDrawing;

@end


@implementation HDDrawableView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize distanceThreshold = _distanceThreshold;
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
	[self setClipsToBounds:YES];
	[self setDistanceThreshold:10];
}

#pragma mark - Properties

- (CGFloat)brushSize
{
	if ([[self dataSource] respondsToSelector:@selector(sizeOfBrushForDrawableView:)])
	{
		return [[self dataSource] sizeOfBrushForDrawableView:self];
	}
	else
	{
		return 20;
	}
}

- (UIColor*)brushColor
{
	if ([[self dataSource] respondsToSelector:@selector(colorOfBrushForDrawableView:)])
	{
		return [[self dataSource] colorOfBrushForDrawableView:self];
	}
	else
	{
		return [UIColor blackColor];
	}
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
	[self updateLayersWithNewTouches:touches];
	[self startDrawing];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self setMouseSwiped:YES];
	[self updateLayersWithContinuedTouches:touches force:NO];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (![self mouseSwiped])
	{
		[self updateLayersWithContinuedTouches:touches force:YES];
	}
	
	[self endDrawing];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self endDrawing];
}

#pragma mark - Private Methods

- (void)updateLayersWithNewTouches:(NSSet*)touches
{
	CGPoint point = [[touches anyObject] locationInView:self];
	CAShapeLayer* currentLayer = [self currentLayer];
	
	CGMutablePathRef path = CGPathCreateMutableCopy([currentLayer path]);
	CGPathMoveToPoint(path, NULL, point.x, point.y);
	[currentLayer setPath:path];
	CGPathRelease(path);
}

- (void)updateLayersWithContinuedTouches:(NSSet*)touches force:(BOOL)force
{
	CGPoint point = [[touches anyObject] locationInView:self];
	CAShapeLayer* currentLayer = [self currentLayer];
	CGFloat deltaDistance = CGPointDistance(CGPathGetCurrentPoint([currentLayer path]), point);
	
	if (force || (deltaDistance > [self distanceThreshold]))
	{
		CGMutablePathRef path = CGPathCreateMutableCopy([currentLayer path]);
		CGPathAddLineToPoint(path, NULL, point.x, point.y);
		[currentLayer setPath:path];
		CGPathRelease(path);
	}
}

- (CAShapeLayer*)currentLayer
{
	CGFloat brushSize = [self brushSize];
	UIColor* brushColor = [self brushColor];
	CAShapeLayer* lastLayer = [[[self layer] sublayers] lastObject];
	
	if (!lastLayer || ([lastLayer lineWidth] != brushSize) || !CGColorEqualToColor([lastLayer strokeColor], [brushColor CGColor]))
	{
		lastLayer = [[CAShapeLayer alloc] init];
		[lastLayer setLineCap:kCALineCapRound];
		[lastLayer setLineJoin:kCALineJoinRound];
		[lastLayer setLineWidth:brushSize];
		[lastLayer setStrokeColor:[brushColor CGColor]];
		[lastLayer setFillColor:[[UIColor clearColor] CGColor]];
		
		CGMutablePathRef path = CGPathCreateMutable();
		[lastLayer setPath:path];
		CGPathRelease(path);
		
		[[self layer] addSublayer:lastLayer];
		[lastLayer release];
	}
	
	return lastLayer;
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
