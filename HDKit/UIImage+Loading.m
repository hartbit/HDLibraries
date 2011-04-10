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

+ (UIImage*)loadImageNamed:(NSString*)name cached:(BOOL)caches;
+ (NSString*)pathForImageNamed:(NSString*)name;
+ (id)findPathForImageNamed:(NSString*)name;

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

+ (UIImage*)imageNamed:(NSString*)name cached:(BOOL)cached
{
	HDCheck(isObjectNotNil(name), HDFailureLevelWarning, return nil);
	
	NSString* platformSuffix = [[UIDevice currentDevice] platformSuffix];	
	NSString* platformName = [name stringByAppendingString:platformSuffix];
	UIImage* image = [UIImage loadImageNamed:platformName cached:cached];
	
	if (image)
	{
		return image;
	}
	else
	{
		return [UIImage loadImageNamed:name cached:cached];
	}
}

#pragma - Private Methods

+ (UIImage*)loadImageNamed:(NSString*)name cached:(BOOL)cached
{
	NSString* path = [self pathForImageNamed:name];
	
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

+ (NSString*)pathForImageNamed:(NSString*)name
{
	static NSMutableDictionary* kCachedPaths = nil;
	
	if (kCachedPaths == nil)
	{
		kCachedPaths = [[NSMutableDictionary alloc] init];
	}
	
	id path = [kCachedPaths objectForKey:name];
	
	if (path == nil)
	{
		path = [UIImage findPathForImageNamed:name];
		[kCachedPaths setObject:path forKey:name];
	}
	
	if ([path isKindOfClass:[NSString class]])
	{
		return path;
	}
	else
	{
		return nil;
	}
}

+ (id)findPathForImageNamed:(NSString*)name
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
	
	return [NSNull null];
}

@end
