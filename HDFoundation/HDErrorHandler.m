//
//  HDErrorHandler.m
//  HDLibrairies
//
//  Created by David Hart on 3/27/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDErrorHandler.h"
#import "HDCodeLocation.h"
#import "HDMacros.h"
#import <UIKit/UIKit.h>


@interface HDErrorHandler ()

@property (nonatomic, strong) NSException* exception;
@property (nonatomic, assign) BOOL shouldTerminateApplication;

- (void)recordMessage:(NSString*)message;
- (void)terminateApplication;
- (void)handleApplicationDidEnterBackground;
- (NSString*)levelStringFromLevel:(HDFailureLevel)level;

@end


@implementation HDErrorHandler

@synthesize exception = _exception;
@synthesize shouldTerminateApplication = _shouldTerminateApplication;

SYNTHESIZE_SINGLETON(HDErrorHandler);

#pragma mark - Lifecycle

+ (void)initialize
{
	[[NSNotificationCenter defaultCenter] addObserver:[self sharedInstance]
											 selector:@selector(handleApplicationDidEnterBackground)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
}

#pragma mark - Properties

- (NSException*)exception
{
	if (_exception == nil)
	{
		[self setException:[NSException exceptionWithName:@"" reason:@"" userInfo:[NSMutableDictionary dictionary]]];
	}
	
	return _exception;
}

#pragma mark - Public Methods

- (void)handleFailureWithMessage:(NSString*)message level:(HDFailureLevel)level location:(HDCodeLocation*)location userInfo:(NSDictionary*)userInfo
{
	NSString* levelString = [[self levelStringFromLevel:level] uppercaseString];
	NSMutableString* description = [NSMutableString stringWithFormat:@"[%@] %@ in %@", levelString, message, location];
	
	if ([location object] != nil)
	{
		[description appendFormat:@"\n\tself: %@", [[location object] description]];
	}
	
	for (NSString* infoKey in [userInfo allKeys])
	{
		[description appendFormat:@"\n\t%@: %@", infoKey, [userInfo objectForKey:infoKey]];
	}

#ifdef DEBUG
	NSLog(@"%@", description);
	abort();
#else
	[self recordMessage:description];
	
	if (level == HDFailureLevelError)
	{
		[self setShouldTerminateApplication:YES];
	}
	else if (level > HDFailureLevelError)
	{
		[self terminateApplication];
	}
#endif
}

#pragma mark - Private Methods

- (void)recordMessage:(NSString*)message
{
	NSMutableDictionary* userInfo = (NSMutableDictionary*)[[self exception] userInfo];
	[userInfo setObject:message forKey:[NSDate date]];
}

- (void)terminateApplication
{
	[[self exception] raise];
}
				 
- (void)handleApplicationDidEnterBackground
{
	if ([self shouldTerminateApplication])
	{
		[self terminateApplication];
	}
}

- (NSString*)levelStringFromLevel:(HDFailureLevel)level
{
	static NSArray* kLevelStringTable = nil;
	
	if (kLevelStringTable == nil)
	{
		kLevelStringTable = [[NSArray alloc] initWithObjects:@"Info", @"Warning", @"Error", @"Fatal", nil];
	}
	
	return [kLevelStringTable objectAtIndex:level];
}

@end
