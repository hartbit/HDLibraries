//
//  NSString+Additions.m
//  HDLibrairies
//
//  Created by David Hart on 3/30/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "NSString+Additions.h"


@implementation NSString (HDAdditions)

- (NSRange)fullRange
{
	return NSMakeRange(0, [self length]);
}

@end
