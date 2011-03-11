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

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize originalImage = _originalImage;
@synthesize lastPoint = _lastPoint;
@synthesize mouseSwiped = _mouseSwiped;

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
	[self setImage:_originalImage];
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{	
	_mouseSwiped = NO;
	
	UITouch* touch = [touches anyObject];	
	_lastPoint = [touch locationInView:self];
	
	[self startDrawing];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	_mouseSwiped = YES;
	
	UITouch* touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self];
	
	[self drawFromPoint:_lastPoint toPoint:currentPoint];
	
	_lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (!_mouseSwiped)
	{
		[self drawFromPoint:_lastPoint toPoint:_lastPoint];
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
	UIGraphicsBeginImageContext([self bounds].size);
	
	[[self image] drawInRect:[self bounds]];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineCap(context, kCGLineCapRound);
	
	if (_dataSource && [_dataSource respondsToSelector:@selector(sizeOfBrushForDrawableImage:)])
	{
		CGFloat brushSize = [_dataSource sizeOfBrushForDrawableImage:self];
		CGContextSetLineWidth(context, brushSize);
	}
	
	if (_dataSource && [_dataSource respondsToSelector:@selector(colorOfBrushForDrawableImage:)])
	{
		UIColor* color = [_dataSource colorOfBrushForDrawableImage:self];
		[color setStroke];
	}
	
	CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextClipToMask(context, self.bounds, self.image.CGImage);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextTranslateCTM(context, 0.0, -self.bounds.size.height);
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
	CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
	
	CGContextStrokePath(context);
	
	[self setImage:UIGraphicsGetImageFromCurrentImageContext()];
	UIGraphicsEndImageContext();
}

- (void)startDrawing
{
	if (_delegate && [_delegate respondsToSelector:@selector(drawableImageWillStartDrawing:)])
	{
		[_delegate drawableImageWillStartDrawing:self];
	}
}

- (void)endDrawing
{
	if (_delegate && [_delegate respondsToSelector:@selector(drawableImageDidEndDrawing:)])
	{
		[_delegate drawableImageDidEndDrawing:self];
	}
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self setOriginalImage:nil];
	[super dealloc];
}

@end
