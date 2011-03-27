//
//  NSArray+Queue.m
//  GravicubeModel
//
//  Created by David Hart on 04/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSMutableArray+Queue.h"
#import "HDMacros.h"


@implementation NSMutableArray (Queue)

- (void)enqueue:(id)object
{
	HDRequire(object);
	
	[self addObject:object];
}

- (id)dequeue
{
	HDRequire([self count] > 0);
	
	id object = [[self objectAtIndex:0] retain];
	[self removeObjectAtIndex:0];
	
	HDEnsure(object);
	HDEnsure([object retainCount] == 1);
	return [object autorelease];
}

@end
