//
//  HDImageInfo.h
//  HDLibraries
//
//  Created by David Hart on 13/11/2012.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HDImageInfo : NSObject

- (id)initWithUIImage:(UIImage*)image;

@property (nonatomic, strong) UIImage* image;

- (BOOL)pointInside:(CGPoint)point;

@end
