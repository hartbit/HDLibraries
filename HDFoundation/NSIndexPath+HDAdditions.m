//
//  NSIndexPath+HDAdditions.m
//  HDLibraries
//
//  Created by David Hart on 21.07.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSIndexPath+HDAdditions.h"


@implementation NSIndexPath (HDAdditions)

+ (NSIndexPath*)indexPathWithIndexes:(NSArray*)indexes
{
	return [[NSIndexPath alloc] initWithIndexes:indexes];
}

- (NSIndexPath*)initWithIndexes:(NSArray*)indexes
{
	NSUInteger indexTable[[indexes count]];
	
	for (NSUInteger index = 0; index < [indexes count]; index++) {
		indexTable[index] = [[indexes objectAtIndex:index] unsignedIntegerValue];
	}
	
	return [self initWithIndexes:indexTable length:[indexes count]];
}

- (NSArray*)allIndexes
{
	NSMutableArray* indexes = [NSMutableArray arrayWithCapacity:[self length]];
	
	for (NSUInteger index = 0; index < [self length]; index++) {
		[indexes addObject:[NSNumber numberWithUnsignedInteger:[self indexAtPosition:index]]];
	}

	return indexes;
}

- (NSUInteger)lastIndex
{
	return [self indexAtPosition:[self length] - 1];
}

@end
