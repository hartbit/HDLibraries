//
//  HDIrregularImage.m
//  HDFoundation
//
//  Created by David Hart on 5/18/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDIrregularImage.h"
#import "UIImage+Alpha.h"


@interface HDIrregularImage ()

@property (nonatomic, retain) NSData* imageAlphaData;

@end


@implementation HDIrregularImage

@synthesize imageAlphaData = _imageAlphaData;

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
	
	NSData* imageAlphaData = [self imageAlphaData];
	
	if (!imageAlphaData)
	{
		return YES;
	}
	
	char* rawDataBytes = (char*)[imageAlphaData bytes];
	NSUInteger index = pointX + (pointY * width);
	return (rawDataBytes[index] != 0);
}

#pragma mark - Private Methods

- (void)setImage:(UIImage*)image
{
	[self setImageAlphaData:nil];
	[super setImage:image];
}

- (NSData*)imageAlphaData
{
	if (!_imageAlphaData && [self image])
	{
		[self setImageAlphaData:[[self image] alphaData]];
	}
	
	return _imageAlphaData;
}

#pragma mark - Memory Management

- (void)dealloc
{
	[self setImageAlphaData:nil];
	[super dealloc];
}

@end