//
//  NSString+HDAdditions.m
//  HDLibrairies
//
//  Created by David Hart on 3/30/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSString+HDAdditions.h"


@implementation NSString (HDAdditions)

- (NSRange)fullRange
{
	return NSMakeRange(0, [self length]);
}

- (BOOL)startsWithString:(NSString*)substring
{
	NSRange range = [self rangeOfString:substring];
	return range.location == 0;
}

- (BOOL)endsWithString:(NSString*)substring
{
	NSRange range = [self rangeOfString:substring];
	return (range.location != NSNotFound) && (range.location + range.length == [self length]);
}

@end
