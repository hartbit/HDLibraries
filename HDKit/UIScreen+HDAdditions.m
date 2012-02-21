//
//  UIScreen+HDAdditions.m
//  HDLibraries
//
//  Created by Hart David on 20.02.12.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@implementation UIScreen (HDAdditions)

- (NSString*)scaleSuffix
{
	if ([self scale] != 1)
	{
		return [NSString stringWithFormat:@"@%ix", [self scale]];
	}
	else
	{
		return @"";
	}
}

@end
