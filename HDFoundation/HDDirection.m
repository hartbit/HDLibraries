//
//  HDDirection.m
//  HDLibraries
//
//  Created by David Hart on 21.07.11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDDirection.h"
#import "HDAssert.h"

HDDirection HDDirectionNext(HDDirection direction, BOOL clockwise);
HDDirection HDHDDirectionDirectionOpposite(HDDirection direction);
HDPoint HDPointInDirection(HDPoint point, HDDirection direction);
NSString* NSStringFromHDDirection(HDDirection direction);


HDDirection HDDirectionNext(HDDirection direction, BOOL clockwise)
{
    HDCCheck(isNSIntegerInExclusiveRange(direction, HDDirectionNone, HDDirectionLast), HDFailureLevelError, return direction);
	
    HDDirection returnDirection = HDDirectionNone;
	
    if ((direction == HDDirectionUp) && !clockwise)
    {
        returnDirection = HDDirectionLeft;
    }
    else if ((direction == HDDirectionLeft) && clockwise)
    {
        returnDirection = HDDirectionUp;
    }
    else
    {
        returnDirection = direction + (clockwise ? 1 : -1);
    }
	
    HDCCheck(isNSIntegerInExclusiveRange(returnDirection, HDDirectionNone, HDDirectionLast), HDFailureLevelError, return direction);
    return returnDirection;
}

HDDirection HDDirectionOpposite(HDDirection direction)
{
	return HDDirectionNext(HDDirectionNext(direction, YES), YES);
}

HDPoint HDPointInDirection(HDPoint point, HDDirection direction)
{
	HDCCheck(isNSIntegerInExclusiveRange(direction, HDDirectionNone, HDDirectionLast), HDFailureLevelError, return point);
	
	switch (direction)
	{
		case HDDirectionUp: point.y--; break;
		case HDDirectionRight: point.x++; break;
		case HDDirectionDown: point.y++; break;
		case HDDirectionLeft: point.x--; break;
		default:
			HDCFail(@"Invalid direction", HDFailureLevelError);
			return point;
	}
	
	return point;
}

NSString* NSStringFromHDDirection(HDDirection direction)
{
	switch (direction)
	{
		case HDDirectionNone: return @"None";
		case HDDirectionUp: return @"Up";
		case HDDirectionRight: return @"Right";
		case HDDirectionDown: return @"Down";
		case HDDirectionLeft: return @"Left";
		default:
			NSCAssert(NO, @"Not Implemented");
			return nil;
	}
}
