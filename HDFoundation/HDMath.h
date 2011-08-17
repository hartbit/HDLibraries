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
