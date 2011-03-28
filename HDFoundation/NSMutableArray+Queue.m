//
//  NSArray+Queue.m
//  HDLibraries
//
//  Created by David Hart on 04/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSMutableArray+Queue.h"
#import "HDErrorHandler.h"


@implementation NSMutableArray (Queue)

- (void)enqueue:(id)object
{
//	HDAssert(@"object", HDAssertLevelError);
	
	[self addObject:object];
}

- (id)dequeue
{
//	HDAssert([self count] > 0);
	
	id object = [[self objectAtIndex:0] retain];
	[self removeObjectAtIndex:0];
	
//	HDAssert(object);
	return [object autorelease];
}

@end
