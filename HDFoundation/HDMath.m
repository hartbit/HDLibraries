//
//  HDMath.md
//  HDLibraries
//
//  Created by Hart David on 16.09.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "HDMath.h"
#import "NimbusCore.h"


const NSUInteger HDCurveSampleCount = 10;


NSUInteger HDPower(NSUInteger base, NSUInteger exp)
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

NSUInteger HDShiftLeftCircular(NSUInteger value, NSUInteger shift, NSUInteger size)
{
	NSUInteger inverseShift = size - shift;
	NSUInteger carryMask = ((1 << shift) - 1) << inverseShift;
	NSUInteger carry = value & carryMask;
	NSUInteger carryShifted = carry >> inverseShift;
	NSUInteger sizeMask = (1 << size) - 1;
	NSUInteger valueShifted = (value << shift) & sizeMask;
    return valueShifted | carryShifted;
}

NSUInteger HDShiftRightCircular(NSUInteger value, NSUInteger shift, NSUInteger size)
{
	NSUInteger inverseShift = size - shift;
	NSUInteger carryMask = (1 << shift) - 1;
	NSUInteger carry = value & carryMask;
	NSUInteger carryShifted = carry << inverseShift;
	NSUInteger valueShifted = value >> shift;
    return valueShifted | carryShifted;
}

CGFloat HDQuadCurve(CGFloat p0, CGFloat p1, CGFloat p2, CGFloat t)
{
	NIDASSERT((t >= 0) && (t <= 1));
	
	CGFloat inverseT = 1 - t;
	CGFloat inverseT2 = inverseT * inverseT;
	CGFloat t2 = t * t;
	
	return inverseT2*p0 + 2*inverseT*t*p1 + t2*p2;
}

CGFloat HDCubicCurve(CGFloat p0, CGFloat p1, CGFloat p2, CGFloat p3, CGFloat t)
{
	NIDASSERT((t >= 0) && (t <= 1));

	CGFloat inverseT = 1 - t;
	CGFloat inverseT2 = inverseT * inverseT;
	CGFloat inverseT3 = inverseT2 * inverseT;
	CGFloat t2 = t * t;
	CGFloat t3 = t2 * t;
	
	return inverseT3*p0 + 3*inverseT2*t*p1 + 3*inverseT*t2*p2 + t3*p3;
}

// From http://www.codeguru.com/forum/showthread.php?t=194400
CGFloat HDDistanceFromLine(CGPoint lineStart, CGPoint lineEnd, CGPoint point, CGPoint* closestPoint)
{
	CGFloat r_numerator = (point.x-lineStart.x)*(lineEnd.x-lineStart.x) + (point.y-lineStart.y)*(lineEnd.y-lineStart.y);
	CGFloat r_denomenator = (lineEnd.x-lineStart.x)*(lineEnd.x-lineStart.x) + (lineEnd.y-lineStart.y)*(lineEnd.y-lineStart.y);
	CGFloat r = r_numerator / r_denomenator;
	//
    CGFloat px = lineStart.x + r*(lineEnd.x-lineStart.x);
    CGFloat py = lineStart.y + r*(lineEnd.y-lineStart.y);
	//     
    CGFloat s =  ((lineStart.y-point.y)*(lineEnd.x-lineStart.x)-(lineStart.x-point.x)*(lineEnd.y-lineStart.y) ) / r_denomenator;
	
	CGFloat distance = fabs(s)*sqrt(r_denomenator);
	
	if ((r >= 0) && (r <= 1))
	{
		if (closestPoint != NULL)
		{
			*closestPoint = CGPointMake(px, py);
		}
	}
	else
	{
		CGFloat dist1 = (point.x-lineStart.x)*(point.x-lineStart.x) + (point.y-lineStart.y)*(point.y-lineStart.y);
		CGFloat dist2 = (point.x-lineEnd.x)*(point.x-lineEnd.x) + (point.y-lineEnd.y)*(point.y-lineEnd.y);
		
		if (dist1 < dist2)
		{
			distance = sqrtf(dist1);
			
			if (closestPoint != NULL)
			{
				*closestPoint = lineStart;
			}
		}
		else
		{
			distance = sqrtf(dist2);
			
			if (closestPoint != NULL)
			{
				*closestPoint = lineEnd;
			}
		}
	}

	return distance;
}

CGFloat HDDistanceFromQuadCurve(CGPoint curveStart, CGPoint controlPoint, CGPoint curveEnd, CGPoint point, CGPoint* closestPoint)
{
	CGFloat minimumDistance2 = CGFLOAT_MAX;
	
	for (NSUInteger sampleIndex = 0; sampleIndex <= HDCurveSampleCount; sampleIndex++)
	{
		CGFloat t = (CGFloat)sampleIndex / HDCurveSampleCount;
		CGFloat sampleX = HDQuadCurve(curveStart.x, controlPoint.x, curveEnd.x, t);
		CGFloat sampleY = HDQuadCurve(curveStart.y, controlPoint.y, curveEnd.y, t);
		CGFloat distance2 = (point.x-sampleX)*(point.x-sampleX) + (point.y-sampleY)*(point.y-sampleY);
		
		if (distance2 < minimumDistance2)
		{
			minimumDistance2 = distance2;
			
			if (closestPoint != NULL)
			{
				*closestPoint = CGPointMake(sampleX, sampleY);
			}
		}
	}
	
	return sqrtf(minimumDistance2);
}

CGFloat HDDistanceFromCubicCurve(CGPoint curveStart, CGPoint controlPoint1, CGPoint controlPoint2, CGPoint curveEnd, CGPoint point, CGPoint* closestPoint)
{
	CGFloat minimumDistance2 = CGFLOAT_MAX;
	
	for (NSUInteger sampleIndex = 0; sampleIndex <= HDCurveSampleCount; sampleIndex++)
	{
		CGFloat t = (CGFloat)sampleIndex / HDCurveSampleCount;
		CGFloat sampleX = HDCubicCurve(curveStart.x, controlPoint1.x, controlPoint2.x, curveEnd.x, t);
		CGFloat sampleY = HDCubicCurve(curveStart.y, controlPoint1.y, controlPoint2.y, curveEnd.y, t);
		CGFloat distance2 = (point.x-sampleX)*(point.x-sampleX) + (point.y-sampleY)*(point.y-sampleY);
		
		if (distance2 < minimumDistance2)
		{
			minimumDistance2 = distance2;
			
			if (closestPoint != NULL)
			{
				*closestPoint = CGPointMake(sampleX, sampleY);
			}
		}
	}
	
	return sqrtf(minimumDistance2);
}