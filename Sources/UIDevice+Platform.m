//
//  UIDevice+Platform.m
//  HDFoundation
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIDevice+Platform.h"


@implementation UIDevice (Platform)

- (NSString*)platformSuffix
{
	if ([self respondsToSelector:@selector(userInterfaceIdiom)] && ([self userInterfaceIdiom] == UIUserInterfaceIdiomPad))
	{
		return @"~ipad";
	}
	else
	{
		return @"~iphone";
	}
}

@end
