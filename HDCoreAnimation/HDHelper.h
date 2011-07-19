//
//  HDHelper.h
//  HDLibraries
//
//  Created by David Hart on 19/07/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#pragma mark - Conversions

static inline NSString* NSStringFromCATransform3D(CATransform3D transform)
{
	NSMutableString* string = [NSMutableString string];
	const CGFloat* floatTable = (const CGFloat*)&transform;
	
	for (NSUInteger index = 0; index < 16; index++)
	{
		if ((index > 0) && ((index % 4) == 0))
		{
			[string appendString:@"\n"];
		}
		
		[string appendFormat:@"%7.2f ", *floatTable++];
    }
	
	return string;
}
