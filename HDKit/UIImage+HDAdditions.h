//
//  UIImage-HDAdditions.h
//  HDLibraries
//
//  Created by David Hart on 22/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved
//

#import <UIKit/UIKit.h>


@interface UIImage (HDAlpha)

+ (UIImage*)imageWithName:(NSString*)name cached:(BOOL)cached;
+ (UIImage*)imageWithName:(NSString*)name inBundle:(NSBundle*)bundle;

- (NSData*)imageData;

@end
