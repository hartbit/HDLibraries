//
//  HDDirection.h
//  HDLibraries
//
//  Created by David Hart on 21.07.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDTypes.h"


typedef enum {
    HDDirectionNone   = 0,
    HDDirectionUp     = 1,
    HDDirectionRight  = 2,
    HDDirectionDown   = 3,
    HDDirectionLeft   = 4,
    HDDirectionLast   = 5
} HDDirection;


HDDirection HDDirectionNext(HDDirection direction, BOOL clockwise);
HDDirection HDDirectionOpposite(HDDirection direction);
HDPoint HDPointInDirection(HDPoint point, HDDirection direction);
NSString* NSStringFromHDDirection(HDDirection direction);