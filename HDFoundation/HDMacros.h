//
//  HDMacros.h
//  Gravicube
//
//  Created by David Hart on 4/6/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname* kSharedInstance = nil; \
\
+ (classname*)sharedInstance \
{ \
	@synchronized(self) \
	{ \
		if (kSharedInstance == nil) \
		{ \
			kSharedInstance = [[super allocWithZone:NULL] init]; \
		} \
	} \
	\
	return kSharedInstance; \
} \
\
+ (id)allocWithZone:(NSZone*)zone \
{ \
	return [[self sharedInstance] retain]; \
} \
\
- (id)copyWithZone:(NSZone*)zone \
{ \
	return self; \
} \
\
- (id)retain \
{ \
	return self; \
} \
\
- (NSUInteger)retainCount \
{ \
	return NSUIntegerMax; \
} \
\
- (void)release \
{ \
} \
\
- (id)autorelease \
{ \
	return self; \
}