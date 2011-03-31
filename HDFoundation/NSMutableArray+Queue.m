//
//  NSArray+Queue.m
//  HDLibraries
//
//  Created by David Hart on 04/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSMutableArray+Queue.h"
#import "HDAssert.h"


@implementation NSMutableArray (HDQueue)

- (void)enqueue:(id)object
{
	HDCheck(isNotNil(object), HDFailureLevelError, return);
	
	[self addObject:object];
}

- (id)dequeue
{
	HDCheck(isCollectionEmpty(self), HDFailureLevelError, return nil);
	
	id object = [[self objectAtIndex:0] retain];
	[self removeObjectAtIndex:0];
	return [object autorelease];
}

@end
