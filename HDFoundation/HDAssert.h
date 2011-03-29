//
//  HDAssert.h
//  Gravitor
//
//  Created by David Hart on 3/27/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDErrorHandler.h"
#import "HDTypes.h"

#pragma mark - Asserts

#define HDFail(message, level) _HDFail((message), (level), _cmd, self, __FILE__, __LINE__, __PRETTY_FUNCTION__)

static inline void _HDFail(NSString* message, HDFailureLevel level, SEL selector, id object, const char* file, int line, const char* function)
{
	[[HDErrorHandler sharedHandler] handleFailureInMethod:selector
												   object:object
													 file:[NSString stringWithCString:file encoding:NSUTF8StringEncoding]
											   lineNumber:__LINE__
												  message:message
													level:level];
}

#define HDCFail(message, level) _HDCFail((message), (level), __FILE__, __LINE__, __PRETTY_FUNCTION__)

static inline void _HDCFail(NSString* message, HDFailureLevel level, const char* file, int line, const char* function)
{
	[[HDErrorHandler sharedHandler] handleFailureInFunction:[NSString stringWithCString:function encoding:NSUTF8StringEncoding]
													   file:[NSString stringWithCString:file encoding:NSUTF8StringEncoding]
												 lineNumber:__LINE__
													message:message
													  level:level];
}


#define HDAssert(message, level) if ((message) != nil) { HDFail(message, level); }
#define HDCheck(message, level, action) if ((message) != nil) { HDFail(message, level); action; }

#define HDCAssert(message, level) if ((message) != nil) { HDCFail(message, level); }
#define HDCCheck(message, level, action) if ((message) != nil) { HDCFail(message, level); action; }

#pragma mark - Rich Booleans

#define _HDTest(condition) (!(condition)) ? _HDGenerateMessage(#condition) : nil

static inline NSString* _HDGenerateMessage(const char* condition)
{
	return [NSString stringWithFormat:@"Assertion failed (%s)", condition];
}

#define HDIntegerEqual(a, b) _HDTest(a == b)
#define HDUIntegerEqual(a, b) _HDTest(a == b)
#define HDFloatEqual(a, b) _HDTest(a == b)
#define HDTimeIntervalEqual(a, b) _HDTest(a == b)
#define HDRectEqual(a, b) _HDTest(CGRectEqualToRect(a, b))
#define HDSizeEqual(a, b) _HDTest(CGSizeEqualToSize(a, b))
#define HDNotNil(a) _HDTest(a != nil)


/*
 
return (CGRectEqualToRect(a, b)) ? [NSString stringWithFormat:@"%@ CGrectEqualToRect('%s':<%@>, '%s':<%@>)", ASSERT_MESSAGE, aString, a, bString, b] : nil;
 
#define ASSERT_MESSAGE @"Assertion failed -"
#define COMPARE(a, b, op) do { if (!((a) op (b))) { [NSString stringWithFormat:@"%@ '%s':<%@> %s '%s':<%@>", ASSERT_MESSAGE, #a, #op, NSStringFrom(a), #b, NSStringFrom(b)]; }} while (0)

#define HDEqual(a, b) COMPARE(a, b, ==)
#define HDLess(a, b) COMPARE(a, b, <)
#define HDLessOrEqual(a, b) COMPARE(a, b, <=)
#define HDMore(a, b) COMPARE(a, b, >)
#define HDMoreOrEqual(a, b) COMPARE(a, b, >=)
#define HDNotEqual(a, b) COMPARE(a, b, !=)
#define HDInterval(value, low, high) do { if (!((low < (value)) && ((value) < high))) { [NSString stringWithFormat:@"%@ '%s':<%@> < '%s':<%@> < '%s':<%@>", ASSERT_MESSAGE, #low, NSStringFrom(low), #value, NSStringFrom(value), #high, NSStringFrom(high)]; }} while (0)

static inline NSString* _HDEqual(int a, int b, const char* aString, const char* bString)
{
	return (a != b) ? [NSString stringWithFormat:@"%@ '%s':<%@> == '%s':<%@>", ASSERT_MESSAGE, aString, a, bString, b] : nil;
}

static inline NSString* NSStringFrom(
*/