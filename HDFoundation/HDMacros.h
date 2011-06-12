//
//  HDMacros.h
//  HDLibraries
//
//  Created by David Hart on 6/9/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#ifndef SYNTHESIZE_SINGLETON
#define SYNTHESIZE_SINGLETON(classname) \
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
		{ \
			kSharedInstance = [super init]; \
		} \
		\
		return kSharedInstance; \
	} \
}
#endif
