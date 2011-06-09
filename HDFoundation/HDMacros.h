//
//  HDMacros.h
//  HDLibraries
//
//  Created by David Hart on 6/9/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#define SYNTHESIZE_SINGLETON(classname) \
\
static classname* kSharedInstance = nil; \
\
+ (id)sharedInstance \
{ \
	if (kSharedInstance == nil) \
	{ \
		kSharedInstance = [[classname alloc] init]; \
	} \
	\
	return self; \
} \
\
- (id)init \
{ \
	if (kSharedInstance == nil) \
	{ \
		return self; \
	} \
	else \
	{ \
		return kSharedInstance; \
	} \
} \
