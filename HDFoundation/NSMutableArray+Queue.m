//
//  NSArray+Queue.m
//  HDLibraries
//
//  Created by David Hart on 04/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSMutableArray+Queue.h"
#import "HDAssert.h"


@implementation NSMutableArray (Queue)

- (void)enqueue:(id)object
{
	HDCheck(HDNotNil(object), HDFailureLevelError, return);
	
	[self addObject:object];
}

- (id)dequeue
{
#warning missing assert
//	HDAssert(HDNotNil(object), HDFailureLevelError);
	
	id object = [[self objectAtIndex:0] retain];
	[self removeObjectAtIndex:0];
	
	HDAssert(HDNotNil(object), HDFailureLevelError);
	return [object autorelease];
}

@end
