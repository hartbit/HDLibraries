//
//  HDFunctions.h
//  HDLibraries
//
//  Created by David Hart on 3/2/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


static inline UIColor* UIColorMake(NSUInteger r, NSUInteger g, NSUInteger b)
{
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

static inline UIColor* UIColorAlphaMake(NSUInteger r, NSUInteger g, NSUInteger b, NSUInteger a)
{
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

static inline CGPoint CGPointAdd(CGPoint first, CGPoint second)
{
	return CGPointMake(first.x + second.x, first.y + second.y);
}

static inline CGPoint CGPointSubstract(CGPoint first, CGPoint second)
{
	return CGPointMake(first.x - second.x, first.y - second.y);
}

static inline CGFloat CGPointDistance(CGPoint first, CGPoint second)
{
	CGFloat x = first.x - second.x;
	CGFloat y = first.y - second.y;
	return sqrt(x * x + y * y);
}