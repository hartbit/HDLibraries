//
//  UIDevice+HDAdditions.m
//  HDLibraries
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIDevice+HDAdditions.h"
#import "HDFoundation.h"


@implementation UIDevice (HDAdditions)

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

- (BOOL)isDeveloperDevice
{
#if TARGET_IPHONE_SIMULATOR
	return YES;
#else
	NSString* developerDictionaryPath = [[NSBundle mainBundle] pathForResource:@"Developers" ofType:@"plist"];
	
	if (developerDictionaryPath != nil)
	{
		NSDictionary* developerDictionary = [NSDictionary dictionaryWithContentsOfFile:developerDictionaryPath];
		
		for (id value in [developerDictionary allValues])
		{
			if ([value isKindOfClass:[NSString class]] && [value isEqualToString:[self uniqueIdentifier]])
			{
				return YES;
			}
		}
	}
	
	return NO;
#endif
}

@end