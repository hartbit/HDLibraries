//
//  UIView+Geometry.h
//  HDFoundation
//
//  Created by David Hart on 3/2/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (Geometry)

@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGSize frameSize;
@property (nonatomic, assign) CGPoint boundsOrigin;
@property (nonatomic, assign) CGSize boundsSize;

- (void)translate:(CGPoint)offset;

@end
