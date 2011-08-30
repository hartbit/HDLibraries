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

static inline CGPoint CGRectGetTopLeft(CGRect rect)
{
	return rect.origin;
}

static inline CGPoint CGRectGetTopRight(CGRect rect)
{
	return CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
}

static inline CGPoint CGRectGetBottomLeft(CGRect rect)
{
	return CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
}

static inline CGPoint CGRectGetBottomRight(CGRect rect)
{
	return CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
}

static inline CGPoint CGRectGetCenter(CGRect rect)
{
	return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

static inline CGPoint CGRectGetCenterLeft(CGRect rect)
{
	return CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
}

static inline CGPoint CGRectGetCenterRight(CGRect rect)
{
	return CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
}

static inline CGPoint CGRectGetCenterTop(CGRect rect)
{
	return CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
}

static inline CGPoint CGRectGetCenterBottom(CGRect rect)
{
	return CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
}

static inline CGPoint CGPointAdd(CGPoint a, CGPoint b)
{
	return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointSubstract(CGPoint a, CGPoint b)
{
	return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGFloat CGPointDistanceSquared(CGPoint a, CGPoint b)
{
	CGFloat x = a.x - b.x;
	CGFloat y = a.y - b.y;
	return x * x + y * y;
}

static inline CGFloat CGPointDistance(CGPoint a, CGPoint b)
{
	return sqrt(CGPointDistanceSquared(a, b));
}

static inline CGFloat TriangleCosC(CGPoint A, CGPoint B, CGPoint C)
{
	CGFloat aSquared = CGPointDistanceSquared(B, C);
	CGFloat bSquared = CGPointDistanceSquared(A, C);
	CGFloat cSquared = CGPointDistanceSquared(A, B);
	CGFloat a = sqrt(aSquared);
	CGFloat b = sqrt(bSquared);
	CGFloat cosRule = (aSquared + bSquared - cSquared) / (2 * a * b);
	return acos(cosRule);
}

static inline CGFloat TriangleArea2(CGPoint a, CGPoint b, CGPoint c)
{
	return (b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y);
}

static inline CGFloat TriangleArea(CGPoint a, CGPoint b, CGPoint c)
{
	return TriangleArea2(a, b, c) * 0.5f;
}

static inline BOOL CGPointIsLeftOf(CGPoint point, CGPoint lineStart, CGPoint lineEnd)
{
	return TriangleArea2(lineStart, lineEnd, point) > 0;
}

static inline BOOL CGPointIsLeftOn(CGPoint point, CGPoint lineStart, CGPoint lineEnd)
{
	return TriangleArea2(lineStart, lineEnd, point) >= 0;
}

static inline BOOL CGPointIsCollinear(CGPoint point, CGPoint lineStart, CGPoint lineEnd)
{
	return TriangleArea2(lineStart, lineEnd, point) == 0;
}

static inline CGRect CGRectMakeWithEdges(CGFloat left, CGFloat top, CGFloat right, CGFloat bottom)
{
	return (CGRect){left, top, right - left, bottom - top};
}