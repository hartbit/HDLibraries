//
//  HDMacros.h
//  HDLibraries
//
//  Created by David Hart on 6/9/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <dispatch/dispatch.h>

#define SYNTHESIZE_SINGLETON(block) \
	static dispatch_once_t __predicate = 0; \
	__strong static id __singleton = nil; \
	dispatch_once(&__predicate, ^{ \
		__singleton = block(); \
	}); \
	return __singleton;

#define __NSStringFromMacro(f) @#f
#define NSStringFromMacro(f) __NSStringFromMacro(f)