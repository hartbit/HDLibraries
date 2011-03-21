//
//  HDClipView.m
//  HDFoundation
//
//  Created by David Hart on 5/18/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDClipView.h"
#import "UIImage+Alpha.h"
#import <QuartzCore/QuartzCore.h>


@interface HDClipView ()

@property (nonatomic, retain) NSData* clipImageData;
@property (nonatomic, retain) CALayer* maskLayer;

- (void)initialize;

@end


@implementation HDClipView

@synthesize clipImage = _clipImage;
@synthesize clipImageData = _clipImageData;
@synthesize maskLayer = _maskLayer;

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
	[self setMaskLayer:[CALayer layer]];
	[[self layer] setMask:[self maskLayer]];
}

#pragma mark - UIView Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event; 
{
	NSUInteger width = (NSUInteger)[self bounds].size.width;
	NSUInteger height = (NSUInteger)[self bounds].size.height;
	
	if ((point.x < 0) || (point.y < 0) || (point.x > (width - 1)) || (point.y > (height - 1)))
	{
		return NO;
	}
	
	NSUInteger pointX = (NSUInteger)point.x;
	NSUInteger pointY = (NSUInteger)point.y;
	
	NSData* imageAlphaData = [self clipImageData];
	
	if (!imageAlphaData)
	{
		return YES;
	}
	
	char* rawDataBytes = (char*)[imageAlphaData bytes];
	NSUInteger index = pointX + (pointY * width);
	return (rawDataBytes[index] == 0);
}
/*
- (void)didAddSubview:(UIView*)subview
{
	[[subview layer] setMask:[self maskLayer]];
}

- (void)willRemoveSubview:(UIView*)subview
{
	[[subview layer] setMask:nil];
}
*/
#pragma mark - Private Methods

- (void)setClipImage:(UIImage*)clipImage
{
	if (clipImage != _clipImage)
	{
		[_clipImage release];
		_clipImage = [clipImage retain];
		
		[self setClipImageData:nil];
		[[self maskLayer] setContents:clipImage];
	}
}

- (NSData*)clipImageData
{
	if (!_clipImageData && [self clipImage])
	{
		[self setClipImageData:[[self clipImage] alphaData]];
	}
	
	return _clipImageData;
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self setClipImageData:nil];
	[self setMaskLayer:nil];
	
	[super dealloc];
}

@end