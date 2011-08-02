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

- (void)enqueue:(id)object
{
	HDCheck(isObjectNotNil(object), HDFailureLevelError, return);
	
	[self addObject:object];
}

- (id)dequeue
{
	HDCheck(isCollectionEmpty(self), HDFailureLevelError, return nil);
	
	id object = [self objectAtIndex:0];
	[self removeObjectAtIndex:0];
	return object;
}

@end
