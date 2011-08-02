//
//  HDKitFunctions.h
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