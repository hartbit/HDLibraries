//
//  NSArray+HDAdditions.m
//  HDLibraries
//
//  Created by David Hart on 06/05/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSArray+HDAdditions.h"


@implementation NSArray (HDAdditions)

- (id)randomObject
{
	if ([self count] == 0)
	{
		return nil;
	}
	else
	{
		NSUInteger randomIndex = arc4random() % [self count];
		return [self objectAtIndex:randomIndex];
	}
}

@end
