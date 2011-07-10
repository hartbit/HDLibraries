//
//  UIDevice+HDAdditions.h
//  HDLibraries
//
//  Created by David Hart on 23/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDevice (HDAdditions)

+ (NSSet*)platformSuffixes;
- (NSString*)platformSuffix;
- (BOOL)isDeveloperDevice;

@end
