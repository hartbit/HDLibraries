//
//  UIBezierPath+HDAdditions.h
//  Maternelles
//
//  Created by Hart David on 29.09.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIPathElement : NSObject

@property (nonatomic, assign, readonly) CGPathElementType type;
@property (nonatomic, strong, readonly) NSArray* points;

- (void)setWithCGPathElement:(CGPathElement)element;

@end


@interface UIBezierPath (HDAdditions)

- (NSUInteger)elementCount;
- (UIPathElement*)elementAtIndex:(NSUInteger)index;
- (CGFloat)distanceToPoint:(CGPoint)point;

@end