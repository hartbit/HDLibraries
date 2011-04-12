//
//  HDFunctions.h
//  HDLibraries
//
//  Created by David Hart on 3/2/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


static inline UIColor* UIColorMake(NSUInteger r, NSUInteger g, NSUInteger b)
{
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

static inline UIColor* UIColorAlphaMake(NSUInteger r, NSUInteger g, NSUInteger b, NSUInteger a)
{
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}