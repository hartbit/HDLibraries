//
//  HDMath.md
//  HDLibraries
//
//  Created by Hart David on 16.09.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "HDMath.h"


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
