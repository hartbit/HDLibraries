//
//  UIImage+HDAdditions.m
//  HDLibraries
//
//  Created by jeff on 3/26/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "UIImage+HDAdditions.h"
#import <CoreGraphics/CoreGraphics.h>
#import "HDFoundation.h"
#import	"UIDevice+HDAdditions.h"


@interface UIImage ()

+ (NSString*)insertRetinaPathModifier:(NSString*)path;
+ (UIImage*)directImageWithName:(NSString*)name inBundle:(NSBundle*)bundle;

@end


@implementation UIImage (HDAdditions)

#pragma mark - Loading

+ (UIImage*)imageWithName:(NSString*)name cached:(BOOL)cached
{
	if ([[name pathExtension] length] == 0)
	{
		name = [name stringByAppendingPathExtension:@"png"];
	}
	
	if (cached)
	{
		return [UIImage imageNamed:name];
	}
	else
	{
		return [UIImage imageWithName:name inBundle:[NSBundle mainBundle]];
	}
}

+ (UIImage*)imageWithName:(NSString*)name inBundle:(NSBundle*)bundle
{
	if ([[name pathExtension] length] == 0)
	{
		name = [name stringByAppendingPathExtension:@"png"];
	}
	
	UIScreen* screen = [UIScreen mainScreen];
	
	if ([screen respondsToSelector:@selector(scale)] && ([screen scale] == 2))
	{
		NSString* retinaName = [UIImage insertRetinaPathModifier:name];
		UIImage* retinaImage = [UIImage directImageWithName:retinaName inBundle:bundle];
		
		if (retinaImage != nil)
		{
			return [UIImage imageWithCGImage:[retinaImage CGImage] scale:2 orientation:UIImageOrientationUp];
		}
	}
	
	return [UIImage directImageWithName:name inBundle:bundle];
}

#pragma mark - Private Methods

+ (NSString*)insertRetinaPathModifier:(NSString*)path
{	
	NSString* pathWithoutExtension = [path stringByDeletingPathExtension];
	NSInteger splitIndex = [pathWithoutExtension length];
	
	for (NSString* modifier in [UIDevice platformSuffixes])
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

+ (UIImage*)directImageWithName:(NSString*)name inBundle:(NSBundle*)bundle
{
	NSString* nameWithoutExtension = [name stringByDeletingPathExtension];
	NSString* extension = [name pathExtension];
	NSString* path = [bundle pathForResource:nameWithoutExtension ofType:extension];
	
	if (path == nil)
	{
		return nil;
	}
	
	return [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
}

#pragma mark - Alpha

- (NSData*)imageData
{
	return (NSData*)objc_retainedObject(CGDataProviderCopyData(CGImageGetDataProvider([self CGImage])));
}

#pragma mark - Orientation

- (UIImage*)imageWithOrientation:(UIImageOrientation)orientation
{
	CGSize size = [self size];
	CGRect bounds = CGRectMake(0, 0, size.width, size.height);

	if ((orientation == UIImageOrientationLeft) || (orientation == UIImageOrientationRight) ||
		(orientation == UIImageOrientationLeftMirrored) || (orientation == UIImageOrientationRightMirrored))
	{
		CGFloat oldHeight = bounds.size.height;  
		bounds.size.height = bounds.size.width;  
		bounds.size.width = oldHeight;
	}
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	switch (orientation)
	{
		case UIImageOrientationUp:
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored:
			transform = CGAffineTransformMakeTranslation(size.width, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;
			
		case UIImageOrientationDown:
			transform = CGAffineTransformMakeTranslation(size.width, size.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformMakeTranslation(0, size.height);
			transform = CGAffineTransformScale(transform, 1, -1);
			break;
			
		case UIImageOrientationLeftMirrored:
			transform = CGAffineTransformMakeTranslation(size.height, size.width);
			transform = CGAffineTransformScale(transform, -1, 1);
			transform = CGAffineTransformRotate(transform, 3 * M_PI / 2);
			break;
			
		case UIImageOrientationLeft:
			transform = CGAffineTransformMakeTranslation(0, size.width);
			transform = CGAffineTransformRotate(transform, 3 * M_PI / 2);
			break;
			
		case UIImageOrientationRightMirrored:
			transform = CGAffineTransformMakeScale(-1, 1);
			transform = CGAffineTransformRotate(transform, M_PI / 2);
			break;
			
		case UIImageOrientationRight:
			transform = CGAffineTransformMakeTranslation(size.height, 0);
			transform = CGAffineTransformRotate(transform, M_PI / 2);
			break;

		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft)
	{
		CGContextScaleCTM(context, -1, 1);
		CGContextTranslateCTM(context, -size.height, 0);
	}
	else if (orientation == UIImageOrientationRightMirrored || orientation == UIImageOrientationLeftMirrored)
	{
		CGContextScaleCTM(context, 1, -1);
		CGContextTranslateCTM(context, 0, -size.height * 2);
	}
	else
	{
		CGContextScaleCTM(context, 1, -1);
		CGContextTranslateCTM(context, 0, -size.height);
	}
	
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height), [self CGImage]);
	
	UIImage* orientedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return orientedImage;  
}

@end
