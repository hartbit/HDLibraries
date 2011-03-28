//
//  HDAssert.h
//  Gravitor
//
//  Created by David Hart on 3/27/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDErrorHandler.h"
#import "HDTypes.h"

#define HDFail(message, level) _HDFail((message), (level), __FILE__, __LINE__, __PRETTY_FUNCTION__)

static inline void _HDFail(NSString* message, HDFailureLevel level, const char* file, int line, const char* function)
{
	[[HDErrorHandler sharedHandler] handleFailureInFunction:[NSString stringWithCString:function encoding:NSUTF8StringEncoding]
													   file:[NSString stringWithCString:file encoding:NSUTF8StringEncoding]
												 lineNumber:line
												description:message
													  level:level];
}

#define HDAssert(message, level) _HDAssert((message), (level), __FILE__, __LINE__, __PRETTY_FUNCTION__)

static inline void _HDAssert(NSString* message, HDFailureLevel level, const char* file, int line, const char* function)
{
	if (message != nil)
	{
		_HDFail(message, level, file, line, function);
	}
}
/*
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