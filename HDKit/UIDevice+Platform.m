//
//  UIDevice+Platform.m
//  HDLibraries
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIDevice+Platform.h"
#import "HDFoundation.h"


@implementation UIDevice (HDPlatform)

- (NSString*)platformSuffix
{
	NSString* platformSuffix = nil;
	
	if ([self respondsToSelector:@selector(userInterfaceIdiom)] && ([self userInterfaceIdiom] == UIUserInterfaceIdiomPad))
	{
		platformSuffix = @"~ipad";
	}
	else
	{
		platformSuffix = @"~iphone";
	}
	
	HDAssert(isObjectNotNil(platformSuffix), HDFailureLevelError);
	return platformSuffix;
}

@end
