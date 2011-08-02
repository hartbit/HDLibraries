//
//  HDMath.h
//  Gravicube
//
//  Created by David Hart on 4/5/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


static inline NSUInteger Power(NSUInteger base, NSUInteger exp)
{
	NSUInteger result = 1;
	
	while (exp != 0)
	{
		if ((exp & 1) != 0)
		{
			result *= base;
		}
		
		exp >>= 1;
		base *= base;
	}
	
	return result;
}

static inline NSUInteger ShiftLeftCircular(NSUInteger value, NSUInteger shift, NSUInteger size)
{
	NSUInteger inverseShift = size - shift;
	NSUInteger carryMask = ((1 << shift) - 1) << inverseShift;
	NSUInteger carry = value & carryMask;
	NSUInteger carryShifted = carry >> inverseShift;
	NSUInteger sizeMask = (1 << size) - 1;
	NSUInteger valueShifted = (value << shift) & sizeMask;
    return valueShifted | carryShifted;
}

static inline NSUInteger ShiftRightCircular(NSUInteger value, NSUInteger shift, NSUInteger size)
{
	NSUInteger inverseShift = size - shift;
	NSUInteger carryMask = (1 << shift) - 1;
	NSUInteger carry = value & carryMask;
	NSUInteger carryShifted = carry << inverseShift;
	NSUInteger valueShifted = value >> shift;
    return valueShifted | carryShifted;
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