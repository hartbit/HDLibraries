//
//  HDAssert.h
//  Gravitor
//
//  Created by David Hart on 3/27/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDErrorHandler.h"
#import "HDErrorLocation.h"
#import "HDTypes.h"
#import "NSString+Additions.h"

#pragma mark - Asserts

#define HDFail(message, level) _HDFail((message), (level), self, _cmd, __FILE__, __LINE__)
#define HDCFail(message, level) _HDCFail((message), (level), __PRETTY_FUNCTION__, __FILE__, __LINE__)

static inline void _HDFail(NSString* message, HDFailureLevel level, id object, SEL selector, const char* file, int line)
{
	NSString* fileNameString = [NSString stringWithCString:file encoding:NSUTF8StringEncoding];
	HDErrorLocation* location = [HDErrorLocation errorLocationInObject:object method:selector fileName:fileNameString lineNumber:line];
	[[HDErrorHandler sharedHandler] handleFailureWithMessage:message level:level location:location variables:nil];
}

static inline void _HDCFail(NSString* message, HDFailureLevel level, const char* function, const char* file, int line)
{
	NSString* functionString = [NSString stringWithCString:function encoding:NSUTF8StringEncoding];
	NSString* fileNameString = [NSString stringWithCString:file encoding:NSUTF8StringEncoding];
	HDErrorLocation* location = [HDErrorLocation errorLocationInFunction:functionString fileName:fileNameString lineNumber:line];
	[[HDErrorHandler sharedHandler] handleFailureWithMessage:message level:level location:location variables:nil];
}

#define HDAssert(message, level) if ((message) != nil) { HDFail(message, level); }
#define HDCheck(message, level, action) if ((message) != nil) { HDFail(message, level); action; }

#define HDCAssert(message, level) if ((message) != nil) { HDCFail(message, level); }
#define HDCCheck(message, level, action) if ((message) != nil) { HDCFail(message, level); action; }

#pragma mark - Rich Booleans

#define _HDTest1(condition, aString, aValue) (!(condition)) ? _HDGenerateMessage1(#condition, aString, aValue) : nil
#define _HDTest2(condition, aString, aValue, bString, bValue) (!(condition)) ? _HDGenerateMessage2(#condition, aString, aValue, bString, bValue) : nil

static inline void _HDReplaceVariable(NSMutableString* expression, NSString* variable, NSString* value)
{
	NSString* replacement = [NSString stringWithFormat:@"'%@':<%@>", variable, value];
	[expression replaceOccurrencesOfString:variable withString:replacement options:NSLiteralSearch range:[expression fullRange]];
}

static inline NSString* _HDGenerateMessage1(const char* condition, const char* aString, NSString* aValue)
{
	NSMutableString* mutableCondition = [NSMutableString stringWithCString:condition encoding:NSUTF8StringEncoding];
	_HDReplaceVariable(mutableCondition, [NSString stringWithCString:aString encoding:NSUTF8StringEncoding], aValue);
	return [NSString stringWithFormat:@"Assertion failed (%@)", mutableCondition];
}

static inline NSString* _HDGenerateMessage2(const char* condition, const char* aString, NSString* aValue, const char* bString, NSString* bValue)
{
	NSMutableString* mutableCondition = [NSMutableString stringWithCString:condition encoding:NSUTF8StringEncoding];
	_HDReplaceVariable(mutableCondition, [NSString stringWithCString:aString encoding:NSUTF8StringEncoding], aValue);
	_HDReplaceVariable(mutableCondition, [NSString stringWithCString:bString encoding:NSUTF8StringEncoding], bValue);
	return [NSString stringWithFormat:@"Assertion failed (%@)", mutableCondition];
}

#define HDEqualNSInteger(a, b) _HDTest2(a == b, #a, NSStringFromNSInteger(a), #b, NSStringFromNSInteger(b))
#define HDEqualNSUInteger(a, b) _HDTest2(a == b, #a, NSStringFromNSUInteger(a), #b, NSStringFromNSUInteger(b))
#define HDEqualCGFloat(a, b) _HDTest2(a == b, #a, NSStringFromCGFloat(a), #b, NSStringFromInteger(b))
#define HDEqualCGRect(a, b) _HDTest2(CGRectEqualToRect(a, b), #a, NSStringFromCGRect(a), #b, NSStringFromCGRect(b))
#define HDEqualCGPoint(a, b) _HDTest2(CGSizeEqualToPoint(a, b), #a, NSStringFromCGPoint(a), #b, NSStringFromCGPoint(b))
#define HDEqualCGSize(a, b) _HDTest2(CGSizeEqualToSize(a, b), #a, NSStringFromCGSize(a), #b, NSStringFromCGSize(b))
#define HDNotNil(a) _HDTest1(a != nil, #a, NSStringFromPointer(a))


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