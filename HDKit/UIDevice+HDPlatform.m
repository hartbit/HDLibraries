//
//  UIDevice+HDPlatform.m
//  HDLibraries
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIDevice+HDPlatform.h"
#import "HDFoundation.h"


@implementation UIDevice (HDPlatform)

+ (NSSet*)platformSuffixes
{
	static NSSet* kPlatformSuffixes = nil;
	
	if (kPlatformSuffixes == nil)
	{
		kPlatformSuffixes = [NSSet setWithObjects:@"~iphone", @"~ipad", nil];
	}
	
	return kPlatformSuffixes;
}

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
	
	return platformSuffix;
}

@end
