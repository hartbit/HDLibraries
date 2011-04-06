//
//  HDFunctions.h
//  Gravicube
//
//  Created by David Hart on 4/5/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stddef.h>


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

static inline NSUInteger ShiftLeftCircular(NSUInteger value, NSUInteger shift)
{
	size_t size = sizeof(value) * 4;
	
	if ((shift &= (size - 1)) == 0)
	{
		return value;
	}
	
	return (value << shift) | (value >> (size - shift));
}

static inline NSUInteger ShiftRightCircular(NSUInteger value, NSUInteger shift)
{
	size_t size = sizeof(value) * 4;
	
	if ((shift &= (size - 1)) == 0)
	{
		return value;
	}
	
	return (value >> shift) | (value << (size - shift));
}