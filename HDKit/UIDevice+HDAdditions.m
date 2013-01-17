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

#pragma mark - Class Methods

+ (NSSet*)platformSuffixes
{
	static NSSet* kPlatformSuffixes = nil;
	
	if (!kPlatformSuffixes) {
		kPlatformSuffixes = [NSSet setWithObjects:@"~iphone", @"~ipad", nil];
	}
	
	return kPlatformSuffixes;
}

#pragma mark - Properties

- (NSString*)platformSuffix
{
	return ([self userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? @"~ipad" : @"~iphone";
}

- (BOOL)isDeveloperDevice
{
#if TARGET_IPHONE_SIMULATOR
	return YES;
#else
	NSString* developerDictionaryPath = [[NSBundle mainBundle] pathForResource:@"Developers" ofType:@"plist"];
	
	if (developerDictionaryPath) {
		NSDictionary* developerDictionary = [NSDictionary dictionaryWithContentsOfFile:developerDictionaryPath];
		
		for (id value in [developerDictionary allValues]) {
			if ([value isKindOfClass:[NSString class]] && [value isEqualToString:[self performSelector:@selector(uniqueIdentifier)]]) {
				return YES;
			}
		}
	}
	
	return NO;
#endif
}

#pragma mark - Public Methods

- (BOOL)isOSVersionAtLeast:(NSString*)version
{
	return [[self systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending;
}

@end
