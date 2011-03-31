//
//  UIView+Geometry.m
//  HDLibraries
//
//  Created by David Hart on 3/2/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIView+Geometry.h"


@implementation UIView (HDGeometry)

- (CGPoint)frameOrigin
{
	return [self frame].origin;
}

- (void)setFrameOrigin:(CGPoint)frameOrigin
{
	CGRect frame = [self frame];
	frame.origin = frameOrigin;
	[self setFrame:frame];
}

- (CGSize)frameSize
{
	return [self frame].size;
}

- (void)setFrameSize:(CGSize)frameSize
{
	CGRect frame = [self frame];
	frame.size = frameSize;
	[self setFrame:frame];
}

- (CGPoint)boundsOrigin
{
	return [self bounds].origin;
}

- (void)setBoundsOrigin:(CGPoint)boundsOrigin
{
	CGRect bounds = [self bounds];
	bounds.origin = boundsOrigin;
	[self setBounds:bounds];
}

- (CGSize)boundsSize
{
	return [self bounds].size;
}

- (void)setBoundsSize:(CGSize)boundsSize
{
	CGRect bounds = [self bounds];
	bounds.size = boundsSize;
	[self setBounds:bounds];
}

- (void)translate:(CGPoint)offset
{
	CGRect frame = [self frame];
	frame.origin.x += offset.x;
	frame.origin.y += offset.y;
	[self setFrame:frame];
}

@end
