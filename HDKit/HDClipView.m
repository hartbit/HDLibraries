//
//  HDClipView.m
//  HDLibraries
//
//  Created by David Hart on 5/18/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDClipView.h"
#import "UIImage+Alpha.h"
#import <QuartzCore/QuartzCore.h>


@interface HDClipView ()

@property (nonatomic, strong) NSData* clipImageData;
@property (nonatomic, strong) CALayer* maskLayer;

- (void)initialize;

@end


@implementation HDClipView

@synthesize clipImage = _clipImage;
@synthesize clipImageData = _clipImageData;
@synthesize maskLayer = _maskLayer;

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
	[self setOpaque:NO];
	[self setBackgroundColor:[UIColor clearColor]];

	[self setMaskLayer:[CALayer layer]];
	[[self layer] setMask:[self maskLayer]];
}

#pragma mark - UIView Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event; 
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
 
#pragma mark - Private Methods

- (void)setClipImage:(UIImage*)clipImage
{
	if (clipImage != _clipImage)
	{
		_clipImage = clipImage;
		
		if (clipImage)
		{
			[self setClipImageData:[clipImage imageData]];

			CGRect maskFrame = CGRectMake(0, 0, [clipImage size].width, [clipImage size].height);
			[[self maskLayer] setFrame:maskFrame];
			[[self maskLayer] setContents:(id)objc_unretainedObject([clipImage CGImage])];
		}
	}
}

#pragma mark - Memory Management


@end