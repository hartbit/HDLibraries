//
//  UIImage+Alpha.m
//  HDLibraries
//
//  Created by jeff on 3/26/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import "UIImage+Alpha.h"
#import <CoreGraphics/CoreGraphics.h>
#import "HDFoundation.h"


@implementation UIImage (HDAlpha)

- (NSData*)imageData
{
	return (NSData*)CGDataProviderCopyData(CGImageGetDataProvider([self CGImage]));
} 

@end
