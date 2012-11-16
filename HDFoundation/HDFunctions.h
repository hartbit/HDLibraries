//
//  HDFunctions.h
//  HDLibraries
//
//  Created by David Hart on 16/11/2012.
//  Copyright (c) 2012 hart[dev]. All rights reserved.
//

#import <dispatch/dispatch.h>


static inline id HDCreateSingleton(id (^block)())
{
	static dispatch_once_t predicate = 0;
	__strong static id singleton = nil;
	dispatch_once(&predicate, ^{
		singleton = block();
	});
	return singleton;
}

