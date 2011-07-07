//
//  HDDrawableImageView.m
//  HDLibraries
//
//  Created by David Hart on 5/18/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDDrawableImageView.h"
#import "HDFoundation.h"
#import "HDKitFunctions.h"
#import <QuartzCore/QuartzCore.h>


@interface HDDrawableImageView ()

@property (nonatomic, retain) NSData* clipImageData;
@property (nonatomic, assign) BOOL mouseSwiped;
@property (nonatomic, assign) CGPoint lastPoint;

@property (nonatomic, readonly) CGFloat brushSize;
@property (nonatomic, readonly) UIColor* brushColor;

- (void)initialize;

- (void)startDrawing;
- (void)endDrawing;
- (void)drawToPoint:(CGPoint)toPoint;

@end


@implementation HDDrawableImageView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize distanceThreshold = _distanceThreshold;
@synthesize clipImage = _clipImage;
@synthesize clipImageData = _clipImageData;
@synthesize lastPoint = _lastPoint;
@synthesize mouseSwiped = _mouseSwiped;

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
	[self setUserInteractionEnabled:YES];
	[self setDistanceThreshold:10];
	[self clear];
}

- (void)dealloc
{
	[self setClipImage:nil];
}

#pragma mark - Properties

- (void)setClipImage:(UIImage*)clipImage
{
	if (clipImage != _clipImage)
	{
		[_clipImage release];
		_clipImage = [clipImage retain];
		
		if (clipImage)
		{
			[self setClipImageData:[clipImage imageData]];
			[self clear];
		}
	}
}

- (CGFloat)brushSize
{
	if ([[self dataSource] respondsToSelector:@selector(sizeOfBrushForDrawableImageView:)])
	{
		return [[self dataSource] sizeOfBrushForDrawableImageView:self];
	}
	else
	{
		return 20;
	}
}

- (UIColor*)brushColor
{
	if ([[self dataSource] respondsToSelector:@selector(colorOfBrushForDrawableImageView:)])
	{
		return [[self dataSource] colorOfBrushForDrawableImageView:self];
	}
	else
	{
		return [UIColor blackColor];
	}
}

#pragma mark - UIView Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
	NSUInteger width = (NSUInteger)[self bounds].size.width;
	NSUInteger height = (NSUInteger)[self bounds].size.height;
	
	NSAssert(width == [[self clipImage] size].width, @"Image and view width must be equal");
	NSAssert(height == [[self clipImage] size].height, @"Image and view height must be equal");
	
	if ((point.x < 0) || (point.y < 0) || (point.x > (width - 1)) || (point.y > (height - 1)))
	{
		return NO;
	}
	
	NSUInteger pointX = (NSUInteger)point.x;
	NSUInteger pointY = (NSUInteger)point.y;
	
	NSData* imageData = [self clipImageData];
	
	if (imageData == nil)
	{
		return YES;
	}
	
	NSUInteger pixelIndex = (pointY * width) + pointX;
	NSUInteger alphaIndex = pixelIndex * 4 + 3;
	
	char pixelData = 0;
	[imageData getBytes:&pixelData range:NSMakeRange(alphaIndex, 1)];
	return pixelData != 0;
}

#pragma mark - Public Methods

- (void)clear
{
	[self setImage:nil];
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{	
	[self setMouseSwiped:NO];
	
	CGPoint currentPoint = [[touches anyObject] locationInView:self];
	[self setLastPoint:currentPoint];
	
	[self startDrawing];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self setMouseSwiped:YES];
	
	CGPoint lastPoint = [self lastPoint];
	CGPoint currentPoint = [[touches anyObject] locationInView:self];
	CGFloat deltaDistance = CGPointDistance(lastPoint, currentPoint);
	
	if (deltaDistance > [self distanceThreshold])
	{
		[self drawToPoint:currentPoint];
		[self setLastPoint:currentPoint];
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (![self mouseSwiped])
	{
		[self drawToPoint:[self lastPoint]];
	}
	
	[self endDrawing];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self endDrawing];
}

#pragma mark - Private Methods

- (void)drawToPoint:(CGPoint)toPoint
{
	UIGraphicsBeginImageContextWithOptions([self boundsSize], NO, 0.0);
	CGContextRef imageContext = UIGraphicsGetCurrentContext();
	
	[[self image] drawInRect:[self bounds]];
	
	CGContextTranslateCTM(imageContext, 0.0, [self boundsHeight]);
	CGContextScaleCTM(imageContext, 1.0, -1.0);
	CGContextClipToMask(imageContext, [self bounds], [[self clipImage] CGImage]);
	CGContextScaleCTM(imageContext, 1.0, -1.0);
	CGContextTranslateCTM(imageContext, 0.0, -[self boundsHeight]);
	
	CGContextSetLineCap(imageContext, kCGLineCapRound);
	CGContextSetLineWidth(imageContext, [self brushSize]);
	CGContextSetStrokeColorWithColor(imageContext, [[self brushColor] CGColor]);
		
	CGContextBeginPath(imageContext);
	CGContextMoveToPoint(imageContext, [self lastPoint].x, [self lastPoint].y);
	CGContextAddLineToPoint(imageContext, toPoint.x, toPoint.y);
	CGContextStrokePath(imageContext);	

	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	[self setImage:newImage];
	
	UIGraphicsEndImageContext();
}

- (void)startDrawing
{
	if ([[self delegate] respondsToSelector:@selector(drawableImageViewWillStartDrawing:)])
	{
		[[self delegate] drawableImageViewWillStartDrawing:self];
	}
}

- (void)endDrawing
{
	if ([[self delegate] respondsToSelector:@selector(drawableImageViewDidEndDrawing:)])
	{
		[[self delegate] drawableImageViewDidEndDrawing:self];
	}
}

- (CGRect)rectForBrushFromRect:(CGRect)rect
{
	CGFloat brushSize = [self brushSize];
	CGFloat halfBrushSize = brushSize / 2;
	return CGRectMake(CGRectGetMinX(rect) - halfBrushSize, CGRectGetMinY(rect) - halfBrushSize,
					  CGRectGetWidth(rect) + brushSize, CGRectGetHeight(rect) + brushSize);
}

@end
