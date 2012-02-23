//
//  UIImage-HDAdditions.h
//  HDLibraries
//
//  Created by David Hart on 22/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved
//

#import <UIKit/UIKit.h>


@interface UIImage (HDAdditions)

+ (NSString*)insertRetinaPathModifier:(NSString*)path;
+ (UIImage*)directImageWithName:(NSString*)name inBundle:(NSBundle*)bundle;

+ (UIImage*)imageWithName:(NSString*)name cached:(BOOL)cached;
+ (UIImage*)imageWithName:(NSString*)name inBundle:(NSBundle*)bundle;

- (NSData*)imageData;
- (UIImage*)imageWithOrientation:(UIImageOrientation)orientation;

@end
