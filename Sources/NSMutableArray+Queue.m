//
//  NSArray+Queue.m
//  GravicubeModel
//
//  Created by David Hart on 04/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSMutableArray+Queue.h"


@implementation NSMutableArray (Queue)

- (void)enqueue:(id)object
{
	[self addObject:object];
}

- (id)dequeue
{
	id object = [[self objectAtIndex:0] retain];
	[self removeObjectAtIndex:0];
	return [object autorelease];
}

@end
