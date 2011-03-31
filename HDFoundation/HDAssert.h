//
//  HDAssert.h
//  HDLibrairies
//
//  Created by David Hart on 3/27/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDErrorHandler.h"
#import "HDCodeLocation.h"
#import "HDTypes.h"
#import "NSString+Additions.h"

#pragma mark - Asserts

#define HDFail(message, failureLevel) [[HDErrorHandler sharedHandler] handleFailureWithMessage:message level:failureLevel location:HDCurrentCodeLocation() userInfo:nil]
#define HDCFail(message, failureLevel) [[HDErrorHandler sharedHandler] handleFailureWithMessage:message level:failureLevel location:HDCCurrentCodeLocation() userInfo:nil]

#define HDFailInfo(message, failureLevel, info) [[HDErrorHandler sharedHandler] handleFailureWithMessage:message level:failureLevel location:HDCurrentCodeLocation() userInfo:info]
#define HDCFailInfo(message, failureLevel, info) [[HDErrorHandler sharedHandler] handleFailureWithMessage:message level:failureLevel location:HDCCurrentCodeLocation() userInfo:info]

#define HDAssert(info, level) if ((info) != nil) { HDFailInfo(@"Assertion failed", level, info); }
#define HDCAssert(info, level) if ((info) != nil) { HDCFailInfo(@"Assertion failed", level, info); }

#define HDCheck(info, level, action) if ((info) != nil) { HDFailInfo(@"Check failed", level, info); action; }
#define HDCCheck(info, level, action) if ((info) != nil) { HDCFailInfo(@"Check failed", level, info); action; }

#pragma mark - Rich Booleans

#define _HDTest(condition) (!(condition)) ? _HDGenerateUserInfo(#condition) : nil
#define _HDTest1(condition, aString, aValue) (!(condition)) ? _HDGenerateUserInfo1(#condition, aString, aValue) : nil
#define _HDTest2(condition, aString, aValue, bString, bValue) (!(condition)) ? _HDGenerateUserInfo2(#condition, aString, aValue, bString, bValue) : nil

static inline NSDictionary* _HDGenerateUserInfo(const char* condition)
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSString stringWithCString:condition encoding:NSUTF8StringEncoding], @"expression", nil];
}

static inline NSDictionary* _HDGenerateUserInfo1(const char* condition, const char* aString, id aValue)
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSString stringWithCString:condition encoding:NSUTF8StringEncoding], @"expression",
			aValue, [NSString stringWithCString:aString encoding:NSUTF8StringEncoding], nil];
}

static inline NSDictionary* _HDGenerateUserInfo2(const char* condition, const char* aString, id aValue, const char* bString, id bValue)
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSString stringWithCString:condition encoding:NSUTF8StringEncoding], @"expression",
			aValue, [NSString stringWithCString:aString encoding:NSUTF8StringEncoding],
			bValue, [NSString stringWithCString:bString encoding:NSUTF8StringEncoding], nil];
}

#define isObjectNil(a) _HDTest1(a == nil, #a, a)
#define isObjectNotNil(a) _HDTest(a != nil)

#define isSelectorNull(a) _HDTest1(a == NULL, #a, NSStrinfFromSelector(a))
#define isSelectorNotNull(a) _HDTest(a == NULL)

#define isTrue(a) _HDTest1(a, #a, NSStringFromBoolean(a))
#define isFalse(a) _HDTest1(!a, #a, NSStringFromBoolean(a))

#define isCollectionEmpty(a) _HDTest1([a count] == 0, #a, a)
#define isCollectionNotEmpty(a) _HDTest1([a count] > 0, #a, a)

#define areNSIntegerEqual(a, b) _HDTest2(a == b, #a, NSStringFromNSInteger(a), #b, NSStringFromNSInteger(b))
#define areNSUIntegerEqual(a, b) _HDTest2(a == b, #a, NSStringFromNSUInteger(a), #b, NSStringFromNSUInteger(b))
#define areCGFloatEqual(a, b) _HDTest2(a == b, #a, NSStringFromCGFloat(a), #b, NSStringFromInteger(b))
#define areCGRectEqual(a, b) _HDTest2(CGRectEqualToRect(a, b), #a, NSStringFromCGRect(a), #b, NSStringFromCGRect(b))
#define areCGPointEqual(a, b) _HDTest2(CGSizeEqualToPoint(a, b), #a, NSStringFromCGPoint(a), #b, NSStringFromCGPoint(b))
#define areCGSizeEqual(a, b) _HDTest2(CGSizeEqualToSize(a, b), #a, NSStringFromCGSize(a), #b, NSStringFromCGSize(b))