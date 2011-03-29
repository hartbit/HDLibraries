//
//  HDErrorHandler.m
//  Gravitor
//
//  Created by David Hart on 3/27/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDErrorHandler.h"


@interface HDErrorHandler ()

@property (nonatomic, assign) BOOL shouldTerminateApplication;

- (void)handleFailureWithDescription:(NSString*)description level:(HDFailureLevel)level;
- (void)handleApplicationDidEnterBackground:(NSNotification*)notification;
- (NSString*)levelStringFromLevel:(HDFailureLevel)level;
- (NSString*)descriptionWithLevel:(HDFailureLevel)level message:(NSString*)message location:(NSString*)location file:(NSString*)fileName lineNumber:(NSUInteger)line;

@end


@implementation HDErrorHandler

@synthesize shouldTerminateApplication = _shouldTerminateApplication;

#pragma mark - Singleton Methods

+ (HDErrorHandler*)sharedHandler
{
	static HDErrorHandler* sharedHandler = nil;
	
	if (sharedHandler == nil)
	{
		sharedHandler = [[HDErrorHandler alloc] init];
	}
	
	return sharedHandler;
}

#pragma mark - Lifecycle

- (id)init
{
	if ((self = [super init]))
	{
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleApplicationDidEnterBackground)
													 name:UIApplicationDidEnterBackgroundNotification
												   object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIApplicationDidEnterBackgroundNotification
												  object:nil];
	
	[super dealloc];
}

#pragma mark - Public Methods

- (void)handleFailureInFunction:(NSString*)function file:(NSString*)fileName lineNumber:(NSInteger)line message:(NSString*)message level:(HDFailureLevel)level
{
	NSString* location = [NSString stringWithFormat:@"'%@'", function];
	NSString* description = [self descriptionWithLevel:level message:message location:location file:fileName lineNumber:line];
	[self handleFailureWithDescription:description level:level];
}

- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString*)fileName lineNumber:(NSInteger)line message:(NSString*)message level:(HDFailureLevel)level
{
	NSString* location = [NSString stringWithFormat:@"-[%@ %@]", NSStringFromClass([object class]), NSStringFromSelector(selector)];
	NSString* description = [self descriptionWithLevel:level message:message location:location file:fileName lineNumber:line];
	[self handleFailureWithDescription:description level:level];	
}

#pragma mark - Private Methods

- (void)handleFailureWithDescription:(NSString*)description level:(HDFailureLevel)level
{
	NSLog(@"%@", description);
	
#ifdef DEBUG
	abort();
#else
	if (level == HDFailureLevelError)
	{
		[self setShouldTerminateApplication:YES];
	}
	else if (level > HDFailureLevelError)
	{
		abort();
	}
#endif
}

- (void)handleApplicationDidEnterBackground:(NSNotification*)notification
{
	if ([self shouldTerminateApplication])
	{
		abort();
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

- (NSString*)descriptionWithLevel:(HDFailureLevel)level message:(NSString*)message location:(NSString*)location file:(NSString*)fileName lineNumber:(NSUInteger)line
{
	return [NSString stringWithFormat:@"[%@] %@ in %@, %@:%i", [[self levelStringFromLevel:level] uppercaseString], message, location, [fileName lastPathComponent], line];
}

@end
