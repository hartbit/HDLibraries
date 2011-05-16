//
//  HDFoundationFunctionsTests.m
//  HDLibrariesTests
//
//  Created by David Hart on 4/6/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDFoundationFunctionsTests.h"
#import "HDFoundationFunctions.h"


typedef enum
{
	TestEnumNone = 0,
	TestEnumFirst = 1,
	TestEnumSecond = 2,
	TestEnumThird = 4,
	TestEnumFourth = 8
} TestEnum;


@implementation HDFoundationFunctionsTests

- (void)testPower
{
	STAssertEquals(Power(0, 0), (NSUInteger)1, @"Power(0, 0) == 1");
	STAssertEquals(Power(0, 1), (NSUInteger)0, @"Power(0, 10) == 0");
	STAssertEquals(Power(5, 0), (NSUInteger)1, @"Power(5, 0) == 1");
	STAssertEquals(Power(7, 3), (NSUInteger)343, @"Power(7, 3) == 343");
}

- (void)testShiftLeftCircular
{
	STAssertEquals(ShiftLeftCircular(TestEnumNone, 1, 4), (NSUInteger)TestEnumNone, @"ShiftLeftCircular(TestEnumNone, 1, 4) == TestEnumNone");
	STAssertEquals(ShiftLeftCircular(TestEnumFirst, 1, 4), (NSUInteger)TestEnumSecond, @"ShiftLeftCircular(TestEnumFirst, 1, 4) == TestEnumSecond");
	STAssertEquals(ShiftLeftCircular(TestEnumFirst, 2, 4), (NSUInteger)TestEnumThird, @"ShiftLeftCircular(TestEnumFirst, 2, 4) == TestEnumThird");
	STAssertEquals(ShiftLeftCircular(TestEnumSecond, 1, 4), (NSUInteger)TestEnumThird, @"ShiftLeftCircular(TestEnumSecond, 1, 4) == TestEnumThird");
	STAssertEquals(ShiftLeftCircular(TestEnumFourth, 1, 4), (NSUInteger)TestEnumFirst, @"ShiftLeftCircular(TestEnumFourth, 1, 4) == TestEnumFirst");
	STAssertEquals(ShiftLeftCircular(TestEnumFourth, 2, 4), (NSUInteger)TestEnumSecond, @"ShiftLeftCircular(TestEnumFourth, 2, 4) == TestEnumSecond");
}

- (void)testShiftRightCircular
{
	STAssertEquals(ShiftRightCircular(TestEnumNone, 1, 4), (NSUInteger)TestEnumNone, @"ShiftRightCircular(TestEnumNone, 1, 4) == TestEnumNone");
	STAssertEquals(ShiftRightCircular(TestEnumFourth, 1, 4), (NSUInteger)TestEnumThird, @"ShiftRightCircular(TestEnumFourth, 1, 4) == TestEnumThird");
	STAssertEquals(ShiftRightCircular(TestEnumFourth, 2, 4), (NSUInteger)TestEnumSecond, @"ShiftRightCircular(TestEnumFourth, 2, 4) == TestEnumSecond");
	STAssertEquals(ShiftRightCircular(TestEnumThird, 1, 4), (NSUInteger)TestEnumSecond, @"ShiftRightCircular(TestEnumThird, 1, 4) == TestEnumSecond");
	STAssertEquals(ShiftRightCircular(TestEnumFirst, 1, 4), (NSUInteger)TestEnumFourth, @"ShiftRightCircular(TestEnumFirst, 1, 4) == TestEnumFourth");
	STAssertEquals(ShiftRightCircular(TestEnumFirst, 2, 4), (NSUInteger)TestEnumThird, @"ShiftRightCircular(TestEnumFirst, 1, 4) == TestEnumThird");
}

@end
