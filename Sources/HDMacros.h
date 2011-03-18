//
//  HDMacros.h
//  HDFoundation
//
//  Created by David Hart on 3/18/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#ifdef DEBUG
	#define HDLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
	#define HDFail(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
	#define HDLog(...) do { } while (0)
	#ifndef NS_BLOCK_ASSERTIONS
		#define NS_BLOCK_ASSERTIONS
	#endif
	#define HDFail(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

#define HDAssert(condition, ...) do { if (!(condition)) { HDFail(__VA_ARGS__); }} while(0)
#define HDRequire(condition) HDAssert(condition, @"Pre-condition failed: %s", #condition)
#define HDEnsure(condition) HDAssert(condition, @"Post-condition failed: %s", #condition)