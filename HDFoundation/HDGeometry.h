//
//  HDGeometry.h
//  Gravicube
//
//  Created by David Hart on 12/04/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


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