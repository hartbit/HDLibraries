//
//  NSSet+HDAdditions.m
//  HDLibraries
//
//  Created by David Hart on 6/23/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSSet+HDAdditions.h"


@implementation NSSet (HDAdditions)

- (NSUInteger)numberOfObjectsPassingTest:(BOOL (^)(id obj, BOOL* stop))predicate
{
	NSUInteger count = 0;
	BOOL stop = NO;
	
	for (id obj in self)
	{
		if (predicate(obj, &stop))
		{
			count++;
		}
		
		if (stop)
		{
			break;
		}
	}
	
	return count;
}

@end
