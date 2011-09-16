//
//  HDTypes.m
//  HDLibraries
//
//  Created by Hart David on 16.09.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "HDTypes.h"
#import "NimbusCore.h"


HDDirection HDDirectionNext(HDDirection direction, BOOL clockwise)
{
	NIDASSERT((direction > HDDirectionNone) && (direction < HDDirectionLast));
	
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

	NIDASSERT((returnDirection > HDDirectionNone) && (returnDirection < HDDirectionLast));
	return returnDirection;
}

HDDirection HDDirectionOpposite(HDDirection direction)
{
	return HDDirectionNext(HDDirectionNext(direction, YES), YES);
}

HDPoint HDPointInDirection(HDPoint point, HDDirection direction)
{
	NIDASSERT((direction > HDDirectionNone) && (direction < HDDirectionLast));
	
	switch (direction)
	{
		case HDDirectionUp: point.y--; break;
		case HDDirectionRight: point.x++; break;
		case HDDirectionDown: point.y++; break;
		case HDDirectionLeft: point.x--; break;
		default: return point;
	}
	
	return point;
}

NSString* NSStringFromHDDirection(HDDirection direction)
{
	NIDASSERT((direction > HDDirectionNone) && (direction < HDDirectionLast));
	
	switch (direction)
	{
		case HDDirectionNone: return @"None";
		case HDDirectionUp: return @"Up";
		case HDDirectionRight: return @"Right";
		case HDDirectionDown: return @"Down";
		case HDDirectionLeft: return @"Left";
		default: return nil;
	}
}
