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

+ (UIImage*)findImageNamed:(NSString*)name cached:(BOOL)caches;

@end


@implementation UIImage (Loading)

#pragma - Public Methods

+ (NSArray*)supportedTypes
{
	static NSArray* kSupportedTypes = nil;
	
	if (!kSupportedTypes)
	{
		kSupportedTypes = [[NSArray alloc] initWithObjects:
						   @"tiff", @"tif",
						   @"jpg", @"jpeg",
						   @"gif",
						   @"png",
						   @"bmp", @"BMPf",
						   @"ico",
						   @"cur",
						   @"xbm", nil];
	}
	
	HDEnsure(kSupportedTypes);
	HDEnsure([kSupportedTypes retainCount] == 1);
	return kSupportedTypes;
}

+ (UIImage*)imageNamed:(NSString*)name cached:(BOOL)cached
{
	HDRequire(name);
	
	NSString* platformSuffix = [[UIDevice currentDevice] platformSuffix];
	NSString* platformName = [name stringByAppendingString:platformSuffix];
	UIImage* image = nil;
	
	image = [UIImage findImageNamed:platformName cached:cached];
	if (image) return image;
	
	image = [UIImage findImageNamed:name cached:cached];
	if (image) return image;
	
	return [UIImage imageNamed:name];
}

#pragma - Private Methods

+ (UIImage*)findImageNamed:(NSString*)name cached:(BOOL)cached
{
	NSBundle* mainBundle = [NSBundle mainBundle];
	
	for (NSString* type in [UIImage supportedTypes])
	{
		NSString* path = [mainBundle pathForResource:name ofType:type];
		
		if (path)
		{		
			if (cached)
			{
				NSString* fullName = [name stringByAppendingFormat:@".%@", type];
				return [UIImage imageNamed:fullName];
			}
			else
			{
				return [UIImage imageWithContentsOfFile:path];
			}
		}
	}
	
	return nil;
}

@end
