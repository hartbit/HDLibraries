//
//  DrawableImage.m
//  HDFoundation
//
//  Created by David Hart on 5/18/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDDrawableImage.h"


@interface HDDrawableImage ()

@property (nonatomic, retain) UIImage* originalImage;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) BOOL mouseSwiped;

- (void)initialize;
- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
- (void)startDrawing;
- (void)endDrawing;

@end


@implementation HDDrawableImage

@synthesize dataSource;
@synthesize delegate;
@synthesize originalImage;
@synthesize lastPoint;
@synthesize mouseSwiped;

#pragma mark - Initialization

- (id) initWithCoder:(NSCoder*)coder
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
	[self setUserInteractionEnabled:YES];
	[self setOpaque:NO];
	[self setOriginalImage:[self image]];
}

#pragma mark - Public Methods

- (void)clear
{
	[self setImage:[self originalImage]];
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{	
	[self setMouseSwiped:NO];
	
	UITouch* touch = [touches anyObject];	
	[self setLastPoint:[touch locationInView:self]];
	
	[self startDrawing];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self setMouseSwiped:YES];
	
	UITouch* touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self];
	
	[self drawFromPoint:[self lastPoint] toPoint:currentPoint];
	
	[self setLastPoint:currentPoint];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (![self mouseSwiped])
	{
		[self drawFromPoint:[self lastPoint] toPoint:[self lastPoint]];
	}
	
	[self endDrawing];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self endDrawing];
}

#pragma mark - Private Methods

- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
	CGRect bounds = [self bounds];
	
	UIGraphicsBeginImageContext(bounds.size);
	
	[[self image] drawInRect:bounds];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineCap(context, kCGLineCapRound);
	
	if ([[self dataSource] respondsToSelector:@selector(sizeOfBrushForDrawableImage:)])
	{
		CGFloat brushSize = [[self dataSource] sizeOfBrushForDrawableImage:self];
		CGContextSetLineWidth(context, brushSize);
	}
	
	if ([[self dataSource] respondsToSelector:@selector(colorOfBrushForDrawableImage:)])
	{
		UIColor* color = [[self dataSource] colorOfBrushForDrawableImage:self];
		[color setStroke];
	}
	
	CGContextTranslateCTM(context, 0.0, CGRectGetHeight(bounds));
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextClipToMask(context, bounds, [[self image] CGImage]);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextTranslateCTM(context, 0.0, -CGRectGetHeight(bounds));
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
	CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
	
	CGContextStrokePath(context);
	
	[self setImage:UIGraphicsGetImageFromCurrentImageContext()];
	UIGraphicsEndImageContext();
}

- (void)startDrawing
{
	if ([[self delegate] respondsToSelector:@selector(drawableImageWillStartDrawing:)])
	{
		[[self delegate] drawableImageWillStartDrawing:self];
	}
}

- (void)endDrawing
{
	if ([[self delegate] respondsToSelector:@selector(drawableImageDidEndDrawing:)])
	{
		[[self delegate] drawableImageDidEndDrawing:self];
	}
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self setOriginalImage:nil];
	
	[super dealloc];
}

@end
