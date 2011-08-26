//
//  NSArray+HDAdditions.m
//  HDLibraries
//
//  Created by David Hart on 04/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSMutableArray+HDAdditions.h"
#import "HDAssert.h"


@implementation NSMutableArray (HDAdditions)

- (void)enqueueObject:(id)object
{
	HDCheck(isObjectNotNil(object), HDFailureLevelError, return);
	
	[self addObject:object];
}

- (id)dequeueObject
{
	HDCheck(isCollectionEmpty(self), HDFailureLevelError, return nil);
	
	id object = [self objectAtIndex:0];
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
