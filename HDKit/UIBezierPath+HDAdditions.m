//
//  UIBezierPath+HDAdditions.m
//  Maternelles
//
//  Created by Hart David on 29.09.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "UIBezierPath+HDAdditions.h"
#import "HDFoundation.h"


void GetCountApplier(void* info, const CGPathElement* element);
void GetCountApplier(void* info, const CGPathElement* element)
{
	(*((NSUInteger*)info))++;
}

static NSUInteger sGetElementIndex = 0;
void GetElementApplier(void* info, const CGPathElement* element);
void GetElementApplier(void* info, const CGPathElement* element)
{
	static NSUInteger sCurrentIndex = 0; 
	
	UIPathElement* outElement = (__bridge UIPathElement*)info;
	
	if (![outElement points]) {
		if (sCurrentIndex == sGetElementIndex) {
			[outElement setWithCGPathElement:*element];
			sCurrentIndex = 0;
		} else {
			sCurrentIndex++;
		}
	}
}


@implementation UIBezierPath (HDAdditions)

- (NSUInteger)elementCount
{
	NSUInteger count = 0;
	CGPathApply([self CGPath], &count, GetCountApplier);
	return count;
}

- (UIPathElement*)elementAtIndex:(NSUInteger)index
{
	sGetElementIndex = index;
	
	UIPathElement* element = [UIPathElement new];
	CGPathApply([self CGPath], (__bridge void*)element, GetElementApplier);
	return element;
}

- (CGFloat)distanceToPoint:(CGPoint)point
{
	CGFloat minimumDistance = CGFLOAT_MAX;
	CGPoint startPoint;
	CGPoint currentPoint;
	
	for (NSUInteger elementIndex = 0; elementIndex < [self elementCount]; elementIndex++) {
		UIPathElement* element = [self elementAtIndex:elementIndex];
		CGFloat distance = CGFLOAT_MAX;
		
		switch ([element type]) {
			case kCGPathElementAddLineToPoint: {
				CGPoint endPoint = [[[element points] objectAtIndex:0] CGPointValue];
				distance = HDDistanceFromLine(currentPoint, endPoint, point, NULL);
				break; }
			case kCGPathElementCloseSubpath: {
				distance = HDDistanceFromLine(currentPoint, startPoint, point, NULL);
				break; }
			case kCGPathElementAddQuadCurveToPoint: {
				CGPoint controlPoint = [[[element points] objectAtIndex:0] CGPointValue];
				CGPoint endPoint = [[[element points] objectAtIndex:1] CGPointValue];
				distance = HDDistanceFromQuadCurve(currentPoint, controlPoint, endPoint, point, NULL);
				break; }
			case kCGPathElementAddCurveToPoint: {
				CGPoint controlPoint1 = [[[element points] objectAtIndex:0] CGPointValue];
				CGPoint controlPoint2 = [[[element points] objectAtIndex:1] CGPointValue];
				CGPoint endPoint = [[[element points] objectAtIndex:2] CGPointValue];
				distance = HDDistanceFromCubicCurve(currentPoint, controlPoint1, controlPoint2, endPoint, point, NULL);
				break; }
			default:
				break;
		}
		
		if (distance < minimumDistance) {
			minimumDistance = distance;
		}
		
		if ([element type] == kCGPathElementCloseSubpath) {
			currentPoint = startPoint;
		} else {
			currentPoint = [[[element points] lastObject] CGPointValue];
		}
		
		if (elementIndex == 0) {
			startPoint = currentPoint;
		}
	}
	
	return minimumDistance;
}

@end


@implementation UIPathElement

- (void)setWithCGPathElement:(CGPathElement)element
{
	_type = element.type;
		
	NSUInteger numberOfPoints = 0;
	switch (element.type)
	{
		case kCGPathElementMoveToPoint:
		case kCGPathElementAddLineToPoint:
			numberOfPoints = 1;
			break;
		case kCGPathElementAddQuadCurveToPoint:
			numberOfPoints = 2;
			break;
		case kCGPathElementAddCurveToPoint:
			numberOfPoints = 3;
			break;
		default:
			break;
	}
		
	_points = [NSMutableArray array];
		
	for (NSUInteger indexOfPoint = 0; indexOfPoint < numberOfPoints; indexOfPoint++)
	{
		CGPoint point = element.points[indexOfPoint];
		[(NSMutableArray*)_points addObject:[NSValue valueWithCGPoint:point]];
	}
}

@end