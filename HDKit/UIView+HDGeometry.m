//
//  UIView+HDGeometry.m
//  HDLibraries
//
//  Created by David Hart on 3/2/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIView+HDGeometry.h"


@implementation UIView (HDGeometry)

#pragma mark - Properties

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

- (CGFloat)frameX
{
	return [self frame].origin.x;
}

- (void)setFrameX:(CGFloat)frameX
{
	CGRect frame = [self frame];
	frame.origin.x = frameX;
	[self setFrame:frame];
}

- (CGFloat)frameY
{
	return [self frame].origin.y;
}

- (void)setFrameY:(CGFloat)frameY
{
	CGRect frame = [self frame];
	frame.origin.y = frameY;
	[self setFrame:frame];
}

- (CGFloat)frameWidth
{
	return [self frame].size.width;
}

- (void)setFrameWidth:(CGFloat)frameWidth
{
	CGRect frame = [self frame];
	frame.size.width = frameWidth;
	[self setFrame:frame];
}

- (CGFloat)frameHeight
{
	return [self frame].size.height;
}

- (void)setFrameHeight:(CGFloat)frameHeight
{
	CGRect frame = [self frame];
	frame.size.height = frameHeight;
	[self setFrame:frame];
}

- (CGFloat)boundsX
{
	return [self bounds].origin.x;
}

- (void)setBoundsX:(CGFloat)boundsX
{
	CGRect bounds = [self bounds];
	bounds.origin.x = boundsX;
	[self setBounds:bounds];
}

- (CGFloat)boundsY
{
	return [self bounds].origin.y;
}

- (void)setBoundsY:(CGFloat)boundsY
{
	CGRect bounds = [self bounds];
	bounds.origin.y = boundsY;
	[self setBounds:bounds];
}

- (CGFloat)boundsWidth
{
	return [self bounds].size.width;
}

- (void)setBoundsWidth:(CGFloat)boundsWidth
{
	CGRect bounds = [self bounds];
	bounds.size.width = boundsWidth;
	[self setBounds:bounds];
}

- (CGFloat)boundsHeight
{
	return [self bounds].size.height;
}

- (void)setBoundsHeight:(CGFloat)boundsHeight
{
	CGRect bounds = [self bounds];
	bounds.size.height = boundsHeight;
	[self setBounds:bounds];
}

#pragma mark - Public Methods

- (void)translate:(CGPoint)offset
{
	CGRect frame = [self frame];
	frame.origin.x += offset.x;
	frame.origin.y += offset.y;
	[self setFrame:frame];
}

@end
