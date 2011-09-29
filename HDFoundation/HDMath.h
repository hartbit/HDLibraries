//
//  HDMath.h
//  Gravicube
//
//  Created by David Hart on 4/5/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


NSUInteger HDPower(NSUInteger base, NSUInteger exp);
NSUInteger HDShiftLeftCircular(NSUInteger value, NSUInteger shift, NSUInteger size);
NSUInteger HDShiftRightCircular(NSUInteger value, NSUInteger shift, NSUInteger size);
CGFloat HDQuadCurve(CGFloat p0, CGFloat p1, CGFloat p2, CGFloat t);
CGFloat HDCubicCurve(CGFloat p0, CGFloat p1, CGFloat p2, CGFloat p3, CGFloat t);
CGFloat HDDistanceFromLine(CGPoint lineStart, CGPoint lineEnd, CGPoint point, CGPoint* closestPoint);
CGFloat HDDistanceFromQuadCurve(CGPoint curveStart, CGPoint controlPoint, CGPoint curveEnd, CGPoint point, CGPoint* closestPoint);
CGFloat HDDistanceFromCubicCurve(CGPoint curveStart, CGPoint controlPoint1, CGPoint controlPoint2, CGPoint curveEnd, CGPoint point, CGPoint* closestPoint);