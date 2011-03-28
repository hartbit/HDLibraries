//
//  HDErasableImage.m
//  HDLibraries
//
//  Created by David Hart on 28/05/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDErasableImage.h"
#import <CoreGraphics/CoreGraphics.h>


@interface HDErasableImage ()

@property (nonatomic, assign) BOOL erasing;
@property (nonatomic, assign) CGFloat completion;
@property (nonatomic, assign) CGImageRef imageMaskRef;
@property (nonatomic, assign) BOOL mouseSwiped;
@property (nonatomic, assign) CGPoint lastPoint;

- (void)setupImageMask;
- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
- (void)updateCompletion;
- (UIColor*)imageMaskColor;

@end


@implementation HDErasableImage

@synthesize image = _image;
@synthesize erasing = _erasing;
@synthesize completion = _completion;
@synthesize delegate = _delegate;
@synthesize imageMaskRef = _imageMaskRef;
@synthesize mouseSwiped = _mouseSwiped;
@synthesize lastPoint = _lastPoint;

#pragma mark - Initialization

- (id)initWithImage:(UIImage*)image erasing:(BOOL)erasing
{
	CGRect frame = CGRectMake(0, 0, [image size].width, [image size].height);
	self = [super initWithFrame:frame];
	if (!self) return nil;
	
	[self setOpaque:NO];
	[self setImage:image];
	[self setErasing:erasing];
	[self setCompletion:0];

	[self setupImageMask];

	return self;
}

#pragma mark - Memory Management

- (void)dealloc
{
	CGImageRelease(_imageMaskRef);
	[self setImageMaskRef:nil];
	[self setImage:nil];
	
	[super dealloc];
}

#pragma mark - Properties

- (void)setImage:(UIImage*)image
{
	if (image != _image)
	{
		[_image release];
		_image = [image retain];
		[self setNeedsDisplay];
	}
}

#pragma mark - UIResponder Methods

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self setMouseSwiped:NO];
		
	UITouch* touch = [touches anyObject];	
	[self setLastPoint:[touch locationInView:self]];
	
	if (_delegate && [_delegate respondsToSelector:@selector(erasableImageWillStartErasing:)])
	{
		[_delegate erasableImageWillStartErasing:self];
	}
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	[self setMouseSwiped:YES];
	
	UITouch* touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self];
	
	[self drawFromPoint:_lastPoint toPoint:currentPoint];
	[self setLastPoint:currentPoint];
	
	if (_delegate && [_delegate respondsToSelector:@selector(erasableImage:isErasingWithCompletionPercentage:)])
	{
		[_delegate erasableImage:self isErasingWithCompletionPercentage:_completion];
	}
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (!_mouseSwiped)
	{
		[self drawFromPoint:_lastPoint toPoint:_lastPoint];
	}
	
	if (_delegate && [_delegate respondsToSelector:@selector(erasableImageDidEndErasing:)])
	{
		[_delegate erasableImageDidEndErasing:self];
	}
}

#pragma mark - UIView Methods

CGImageRef CreateMaskFromImageMask(CGImageRef imageMask)
{
	size_t width = CGImageGetWidth(imageMask);
	size_t height = CGImageGetHeight(imageMask);
	size_t bitsPerComponent = CGImageGetBitsPerComponent(imageMask);
	size_t bitsPerPixel = CGImageGetBitsPerPixel(imageMask);
	size_t bytesPerRow = CGImageGetBytesPerRow(imageMask);
	CGDataProviderRef dataProvider = CGImageGetDataProvider(imageMask);
	
	return CGImageMaskCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, dataProvider, NULL, false);
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	
	CGImageRef mask = CreateMaskFromImageMask(_imageMaskRef);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClipToMask(context, [self bounds], mask);
	CGContextTranslateCTM(context, 0, [self bounds].size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextDrawImage(context, [self bounds], _image.CGImage);

	CGImageRelease(mask);
}

#pragma mark - Private Methods

CGContextRef CreateImageMaskContext(CGSize size)
{
	size_t width = size.width;
	size_t height = size.height;
	size_t bitsPerComponent = 8;
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little;
	
	size_t components = 4;
	size_t bytesPerRow = (width * bitsPerComponent * components + 7) / 8;
	size_t dataLength = bytesPerRow * height;
	
    void* bitmapData = malloc(dataLength);
	memset(bitmapData, 0, dataLength);
	
    CGContextRef context = CGBitmapContextCreate(bitmapData, width, height, bitsPerComponent, bytesPerRow, colorspace, bitmapInfo);
	CGColorSpaceRelease(colorspace);
	
    if (context == NULL)
	{
		free(bitmapData);
		fprintf(stderr, "Context not created!");
	}
	
	return context;
}

void ReleaseImageMaskContext(CGContextRef context)
{
	void* bitmapData = CGBitmapContextGetData(context);
	free(bitmapData);
}

- (void)setupImageMask
{
	CGContextRef context = CreateImageMaskContext([self bounds].size);
	
	UIColor* fillColor = _erasing ? [UIColor blackColor] : [UIColor whiteColor];
	CGContextSetFillColorWithColor(context, fillColor.CGColor);
	CGContextFillRect(context, [self bounds]);
	
	_imageMaskRef = CGBitmapContextCreateImage(context);
	
	ReleaseImageMaskContext(context);
	CGContextRelease(context);
}

- (void)drawFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
	CGContextRef context = CreateImageMaskContext([self bounds].size);
	
	CGContextDrawImage(context, [self bounds], _imageMaskRef);
	
	UIColor* strokeColor = _erasing ? [UIColor whiteColor] : [UIColor blackColor];
	CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetLineWidth(context, 60);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
	CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
	CGContextStrokePath(context);
	
	CGImageRelease(_imageMaskRef);
	_imageMaskRef = CGBitmapContextCreateImage(context);
	
	ReleaseImageMaskContext(context);
	CGContextRelease(context);
	
	[self updateCompletion];
	[self setNeedsDisplay];
}

- (void)updateCompletion
{
	size_t width = CGImageGetWidth(_imageMaskRef);
	size_t height = CGImageGetHeight(_imageMaskRef);
	size_t bitsPerPixel = CGImageGetBitsPerPixel(_imageMaskRef);
	size_t bytesPerRow = CGImageGetBytesPerRow(_imageMaskRef);
	
	CFDataRef maskData = CGDataProviderCopyData(CGImageGetDataProvider(_imageMaskRef));
	const UInt8* dataPtr = CFDataGetBytePtr(maskData);
	NSUInteger acheivedPixelCount = 0;
	
	UInt8 alphaToAcheive = _erasing ? 255 : 0;
	
	for (size_t row = 0; row < height; row++)
	{
		for (size_t column = 0; column < width; column++)
		{
			const UInt8* pixelPtr = dataPtr + (row * bytesPerRow) + (column * bitsPerPixel / 8);
			
			if (*pixelPtr == alphaToAcheive)
			{
				acheivedPixelCount++;
			}
		}
	}
	
	CFRelease(maskData);
	
	_completion = (CGFloat)acheivedPixelCount / (width * height);
}

- (UIColor*)imageMaskColor
{
	if (_erasing)
	{
		return [UIColor whiteColor];
	}
	else
	{
		return [UIColor blackColor];
	}
}

@end
