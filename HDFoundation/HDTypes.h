//
//  HDTypes.h
//  HDLibraries
//
//  Created by David Hart on 2/16/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


typedef struct
{
	NSInteger x;
	NSInteger y;
} HDPoint;

typedef struct
{
	NSUInteger width;
	NSUInteger height;
} HDSize;

typedef enum {
    HDDirectionNone   = 0,
    HDDirectionUp     = 1,
    HDDirectionRight  = 2,
    HDDirectionDown   = 3,
    HDDirectionLeft   = 4,
    HDDirectionLast   = 5
} HDDirection;


#pragma mark - HDPoint

static const HDPoint HDPointZero = {0, 0};
static const HDPoint HDPointInfinite = {NSIntegerMax, NSIntegerMax};

static inline HDPoint HDPointMake(NSInteger x, NSInteger y)
{
	return (HDPoint){x, y};
}

static inline BOOL HDPointEquals(HDPoint first, HDPoint second)
{
	return (first.x == second.x) && (first.y == second.y);
}

static inline HDPoint HDPointMultiply(HDPoint point, NSInteger factor)
{
	return HDPointMake(point.x * factor, point.y * factor);
}

static inline CGFloat HDPointDistance(HDPoint first, HDPoint second)
{
	NSUInteger a = second.x - first.x;
	NSUInteger b = second.y - first.y;
	return sqrt(a * a + b * b);
}

#pragma mark - HDSize

static inline HDSize HDSizeMake(NSUInteger width, NSUInteger height)
{
	return (HDSize){ width, height };
}

static inline BOOL HDSizeEquals(HDSize first, HDSize second)
{
	return (first.width == second.width) && (first.height == second.height);
}

static inline HDSize HDSizeMultiply(HDSize size, NSUInteger factor)
{
	return HDSizeMake(size.width * factor, size.height * factor);
}

static inline NSUInteger HDSizeArea(HDSize size)
{
	return size.width * size.height;
}

static inline BOOL HDSizeContainsHDPoint(HDSize size, HDPoint point)
{
	return (point.x >= 0) && (point.y >= 0) && (point.x < size.width) && (point.y < size.height);
}

#pragma mark - HDDirection

HDDirection HDDirectionNext(HDDirection direction, BOOL clockwise);
HDDirection HDDirectionOpposite(HDDirection direction);
HDDirection HDDirectionBetweenPoints(HDPoint fromPoint, HDPoint toPoint);
HDPoint HDPointInDirection(HDPoint point, HDDirection direction);

#pragma mark - Convertions

static inline NSString* NSStringFromNSInteger(NSInteger value)
{
	return [NSString stringWithFormat:@"%i", value];
}

static inline NSString* NSStringFromNSUInteger(NSUInteger value)
{
	return [NSString stringWithFormat:@"%u", value];
}

static inline NSString* NSStringFromCGFloat(CGFloat value)
{
	return [NSString stringWithFormat:@"%f", value];
}

static inline NSString* NSStringFromPointer(void* value)
{
	return [NSString stringWithFormat:@"%p", value];
}

static inline NSString* NSStringFromBoolean(BOOL value)
{
	return value ? @"YES" : @"NO";
}

static inline NSString*	NSStringFromHDPoint(HDPoint point)
{
	return [NSString stringWithFormat:@"(%i, %i)", point.x, point.y];
}

static inline CGPoint CGPointFromHDPoint(HDPoint point)
{
	return CGPointMake(point.x, point.y);
}

static inline NSString* NSStringFromHDSize(HDSize size)
{
	return [NSString stringWithFormat:@"(%i, %i)", size.width, size.height];
}

static inline CGSize CGSizeFromHDSize(HDSize size)
{
	return CGSizeMake(size.width, size.height);
}

NSString* NSStringFromHDDirection(HDDirection direction);