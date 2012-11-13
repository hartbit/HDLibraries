//
//  HDIrregularButton.m
//  HDLibraries
//
//  Created by David Hart on 21.10.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "HDIrregularButton.h"
#import "UIImage+HDAdditions.h"
#import "UIView+HDAdditions.h"
#import "HDImageInfo.h"
#import "NimbusCore.h"


@interface HDIrregularButton ()

@property (nonatomic, strong) HDImageInfo* imageInfo;

@end


@implementation HDIrregularButton

@synthesize imageInfo = _imageInfo;

#pragma mark - Properties

- (HDImageInfo*)imageInfo
{
	if (_imageInfo == nil)
	{
		[self setImageInfo:[HDImageInfo new]];
	}
	
	return _imageInfo;
}

#pragma mark - UIButton Methods

- (void)setBackgroundImage:(UIImage*)image forState:(UIControlState)state
{
	[super setBackgroundImage:image forState:state];
	[self updateImageInfo];
}

- (void)setImage:(UIImage*)image forState:(UIControlState)state
{
	[super setImage:image forState:state];
	[self updateImageInfo];
}

#pragma mark - UIView Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event;
{
	NIDASSERT(CGSizeEqualToSize([[[self imageInfo] image] size], [self bounds].size));
	return [[self imageInfo] pointInside:point];
}

#pragma mark - Private Methods

- (void)updateImageInfo
{
	UIImage* image = [self imageForState:UIControlStateNormal];
	
	if (image == nil)
	{
		image = [self backgroundImageForState:UIControlStateNormal];
	}

	[[self imageInfo] setImage:image];
}

@end
