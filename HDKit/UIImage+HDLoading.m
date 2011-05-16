//
//  UIImage+HDLoading.m
//  HDLibraries
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "UIImage+HDLoading.h"
#import "HDFoundation.h"


@interface UIImage ()

+ (NSString*)insertRetinaPathModifier:(NSString*)path;
+ (UIImage*)imageWithName:(NSString*)name;

@end


@implementation UIImage (HDLoading)

#pragma - Public Methods

+ (UIImage*)imageWithName:(NSString*)name cached:(BOOL)cached
{
	if (cached)
	{
		return [UIImage imageNamed:name];
	}
	else
	{
		UIScreen* screen = [UIScreen mainScreen];
		
		if ([screen respondsToSelector:@selector(scale)] && ([screen scale] == 2))
		{
			NSString* retinaName = [UIImage insertRetinaPathModifier:name];
			UIImage* retinaImage = [UIImage imageWithName:retinaName];
			
			if (retinaImage != nil)
			{
				return [UIImage imageWithCGImage:[retinaImage CGImage] scale:2 orientation:UIImageOrientationUp];
			}
		}
		
		return [UIImage imageWithName:name];
	}
}
#pragma - Private Methods

+ (NSString*)insertRetinaPathModifier:(NSString*)path
{
	const NSArray* deviceModifiers = [NSArray arrayWithObjects:@"~iphone", @"~ipad", nil];
	
	NSString* pathWithoutExtension = [path stringByDeletingPathExtension];
	NSInteger splitIndex = [pathWithoutExtension length];
	
	for (NSString* modifier in deviceModifiers)
	{
		if ([pathWithoutExtension hasSuffix:modifier])
		{
			splitIndex -= [modifier length];
			break;
		}
	}
	
	NSString* leftSplit = [pathWithoutExtension substringToIndex:splitIndex];
	NSString* rightSplit = [pathWithoutExtension substringFromIndex:splitIndex];
	NSString* retinaPath = [NSString stringWithFormat:@"%@@2x%@", leftSplit, rightSplit];
	
	NSString* extension = [path pathExtension];
	return [retinaPath stringByAppendingPathExtension:extension];
}

+ (UIImage*)imageWithName:(NSString*)name
{
	NSString* nameWithoutExtension = [name stringByDeletingPathExtension];
	NSString* extension = [name pathExtension];
	NSString* path = [[NSBundle mainBundle] pathForResource:nameWithoutExtension ofType:extension];
	
	if (path == nil)
	{
		return nil;
	}
	
	return [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
}

@end
