//
//  HDFunctions.h
//  HDLibraries
//
//  Created by David Hart on 3/2/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDFoundation.h"


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

static inline NSString* NSStringFromDeviceOrientation(UIDeviceOrientation orientation)
{
	switch (orientation)
	{
		case UIDeviceOrientationUnknown: return @"UIDeviceOrientationUnknown";
		case UIDeviceOrientationPortrait: return @"UIDeviceOrientationPortrait";
		case UIDeviceOrientationPortraitUpsideDown: return @"UIDeviceOrientationPortraitUpsideDown";
		case UIDeviceOrientationLandscapeLeft: return @"UIDeviceOrientationLandscapeLeft";
		case UIDeviceOrientationLandscapeRight: return @"UIDeviceOrientationLandscapeRight";
		case UIDeviceOrientationFaceUp: return @"UIDeviceOrientationFaceUp";
		case UIDeviceOrientationFaceDown: return @"UIDeviceOrientationFaceDown";
		default: HDCFail(@"Unkown device orientation", HDFailureLevelError); return nil;
	}
}

static inline NSString* NSStringFromInterfaceOrientation(UIInterfaceOrientation orientation)
{
	switch (orientation)
	{
		case UIInterfaceOrientationPortrait: return @"UIInterfaceOrientationPortrait";
		case UIInterfaceOrientationPortraitUpsideDown: return @"UIInterfaceOrientationPortraitUpsideDown";
		case UIInterfaceOrientationLandscapeLeft: return @"UIInterfaceOrientationLandscapeLeft";
		case UIInterfaceOrientationLandscapeRight: return @"UIInterfaceOrientationLandscapeRight";
		default: HDCFail(@"Unkown interface orientation", HDFailureLevelError); return nil;
	}
}