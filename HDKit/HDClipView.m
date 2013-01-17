//
//  HDClipView.m
//  HDLibraries
//
//  Created by David Hart on 5/18/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "HDClipView.h"
#import "UIImage+HDAdditions.h"
#import "NimbusCore.h"
#import "HDImageInfo.h"
#import <QuartzCore/QuartzCore.h>


@interface HDClipView ()

@property (nonatomic, strong) HDImageInfo* imageInfo;
@property (nonatomic, strong) CALayer* maskLayer;

@end


@implementation HDClipView

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder*)coder
{
	if (self = [super initWithCoder:coder]) {
		[self initialize];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
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

#pragma mark - Properties

- (HDImageInfo*)imageInfo
{
	if (!_imageInfo) {
		[self setImageInfo:[HDImageInfo new]];
	}
	
	return _imageInfo;
}

- (UIImage*)clipImage
{
	return [[self imageInfo] image];
}

- (void)setClipImage:(UIImage*)clipImage
{
	[[self imageInfo] setImage:clipImage];
	
	if (clipImage) {
		CGRect maskFrame = CGRectMake(0, 0, [clipImage size].width, [clipImage size].height);
		[[self maskLayer] setFrame:maskFrame];
		[[self maskLayer] setContents:(id)[clipImage CGImage]];
		[[self maskLayer] setContentsScale:[clipImage scale]];
	}
}

#pragma mark - UIView Methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event; 
{
	NIDASSERT(![self clipImage] || CGSizeEqualToSize([[self clipImage] size], [self bounds].size));
	return [[self imageInfo] pointInside:point];
}

@end