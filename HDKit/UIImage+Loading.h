//
//  UIImage+Loading.h
//  HDFoundation
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+Platform.h"


@interface UIImage (Loading)

+ (NSArray*)supportedTypes;
+ (UIImage*)imageNamed:(NSString*)name cached:(BOOL)cached;

@end
