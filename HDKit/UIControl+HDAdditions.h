//
//  UIControl+HDAdditions.h
//  HDLibraries
//
//  Created by Hart David on 05.10.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIControl (HDAdditions)

- (void)respondToControlEvents:(UIControlEvents)controlEvents usingBlock:(void(^)(void))block;

@end