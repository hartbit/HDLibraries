//
//  UIImage+Alpha.m
//  HDFoundation
//
//  Created by jeff on 3/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Alpha.h"
#import <CoreGraphics/CoreGraphics.h>


CGContextRef CreateAlphaBitmapContext(CGImageRef imageRef)
{
	size_t imageWidth = CGImageGetWidth(imageRef);
	size_t imageHeight = CGImageGetHeight(imageRef);

	int bytesPerRow = (imageWidth * 1); // 8bpp
	int byteCount = (bytesPerRow * imageHeight);
    
	void* bitmapData = calloc(1, byteCount);

	if (bitmapData == NULL) 
	{
		return nil;
	}
	
	CGColorSpaceRef colorSpace = NULL;
	CGContextRef context = CGBitmapContextCreate(bitmapData, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGImageAlphaOnly);
	
	if (context == NULL)
	{
		free(bitmapData);
		fprintf(stderr, "Context not created!");
	}

	CGColorSpaceRelease(colorSpace);
	return context;
}


@implementation UIImage (Alpha)

- (NSData*)alphaData
{
	CGContextRef context = CreateAlphaBitmapContext(self.CGImage);

	if (context == NULL)
	{
		return nil;
	}

	size_t imageWidth = CGImageGetWidth(self.CGImage);
	size_t imageHeight = CGImageGetHeight(self.CGImage);
	CGRect imageRect = CGRectMake(0, 0, imageWidth, imageHeight);
	CGContextDrawImage(context, imageRect, self.CGImage); 

	void* bitmapData = CGBitmapContextGetData(context);
	CGContextRelease(context);

	if (bitmapData == NULL)
	{
		return nil;
	}

	size_t dataSize = imageWidth * imageHeight;
	NSData* data = [NSData dataWithBytes:bitmapData length:dataSize];
	
	free(bitmapData);
	return data;
} 

@end
