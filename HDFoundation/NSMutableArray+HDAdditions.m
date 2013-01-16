//
//  NSArray+HDAdditions.m
//  HDLibraries
//
//  Created by David Hart on 04/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSMutableArray+HDAdditions.h"
#import "NimbusCore.h"


@implementation NSMutableArray (HDAdditions)

- (void)enqueueObject:(id)object
{
	NIDASSERT(object != nil);
	
	[self addObject:object];
}

- (id)dequeueObject
{
	NIDASSERT([self count] > 0);
	
	id object = self[0];
	[self removeObjectAtIndex:0];
	return object;
}

- (void)pushObject:(id)object
{
	[self addObject:object];
}

- (id)popObject
{
	id object = [self lastObject];
	[self removeLastObject];
	return object;
}

- (id)topObject
{
	return [self lastObject];
}

@end
