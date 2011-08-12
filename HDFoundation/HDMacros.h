//
//  HDMacros.h
//  HDLibraries
//
//  Created by David Hart on 6/9/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#define SINGLETON_INIT_BEGIN(classname) \
\
static classname* kSharedInstance = nil; \
\
+ (classname*)sharedInstance \
{ \
	@synchronized(self) \
	{ \
		if (kSharedInstance == nil) \
		{ \
			kSharedInstance = [classname new]; \
		} \
		\
		return kSharedInstance; \
	} \
} \
\
- (id)init \
{ \
	@synchronized(self) \
	{ \
		if (kSharedInstance == nil) \
		{

#define SINGLETON_INIT_END \
			kSharedInstance = self; \
		} \
		\
		return kSharedInstance; \
	} \
}

#define SYNTHESIZE_SINGLETON(classname) \
SINGLETON_INIT_BEGIN(classname) \
	self = [super init]; \
SINGLETON_INIT_END

#ifndef CLAMP
#define CLAMP(value, min, max) MIN(MAX(value, min), max)
#endif