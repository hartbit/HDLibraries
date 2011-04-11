//
//  UIImage+Loading.m
//  HDLibraries
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIImage+Loading.h"
#import "HDFoundation.h"
#import "UIDevice+Platform.h"


@interface UIImage ()

+ (UIImage*)loadImageWithName:(NSString*)name cached:(BOOL)cached;
+ (UIImage*)loadImageWithName:(NSString*)name andType:(NSString*)type cached:(BOOL)cached;
+ (NSString*)findPathForImageNamed:(NSString*)name;

@end


@implementation UIImage (HDLoading)

#pragma - Public Methods

+ (NSArray*)supportedTypes
{
	static NSArray* kSupportedTypes = nil;
	
	if (kSupportedTypes == nil)
	{
		kSupportedTypes = [[NSArray alloc] initWithObjects:@"png", @"jpg", nil];
	}
	
	return kSupportedTypes;
}

+ (UIImage*)imageWithName:(NSString*)name cached:(BOOL)cached
{
	HDCheck(isObjectNotNil(name), HDFailureLevelWarning, return nil);
	
	NSString* platformSuffix = [[UIDevice currentDevice] platformSuffix];	
	NSString* platformName = [name stringByAppendingString:platformSuffix];
	return [UIImage loadImageWithName:platformName cached:cached];
}

+ (UIImage*)imageWithName:(NSString*)name andType:(NSString*)type cached:(BOOL)cached
{
	HDCheck(isObjectNotNil(name), HDFailureLevelWarning, return nil);
	
	NSString* platformSuffix = [[UIDevice currentDevice] platformSuffix];	
	NSString* platformName = [name stringByAppendingString:platformSuffix];
	return [UIImage loadImageWithName:platformName andType:type cached:cached];
}

#pragma - Private Methods

+ (UIImage*)loadImageWithName:(NSString*)name cached:(BOOL)cached
{
	NSString* path = [self findPathForImageNamed:name];
	
	if (path)
	{
		if (cached)
		{
			NSString* fullName = [name stringByAppendingPathExtension:[path pathExtension]];
			return [UIImage imageNamed:fullName];
		}
		else
		{
			return [UIImage imageWithContentsOfFile:path];
		}
	}
	else
	{
		return nil;
	}
}

+ (UIImage*)loadImageWithName:(NSString*)name andType:(NSString*)type cached:(BOOL)cached
{
	if (cached)
	{
		NSString* fullName = [name stringByAppendingPathExtension:type];
		return [UIImage imageNamed:fullName];
	}
	else
	{
		NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:type];
		
		if (path != nil)
		{
			return [UIImage imageWithContentsOfFile:path];
		}
		else
		{
			return nil;
		}
	}
}

+ (NSString*)findPathForImageNamed:(NSString*)name
{
	NSBundle* mainBundle = [NSBundle mainBundle];
	
	for (NSString* type in [UIImage supportedTypes])
	{
		NSString* path = [mainBundle pathForResource:name ofType:type];
		
		if (path != nil)
		{
			return path;
		}
	}
	
	return nil;
}

@end
