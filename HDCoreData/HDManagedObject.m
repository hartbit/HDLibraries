//
//  HDManagedObject.m
//  HDLibraries
//
//  Created by David Hart on 10/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDManagedObject.h"
#import "HDFoundation.h"


@implementation HDManagedObject

@synthesize immutable = _immutable;

#pragma mark - Class Methods

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	return [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
}

+ (id)insertNewEntityInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
}

#pragma mark - Public Methods

- (NSError*)validationErrorWithDomain:(NSString*)domain reason:(NSString*)reason
{
	HDCheck(isObjectNotNil(domain), HDFailureLevelWarning, return nil);
	HDCheck(isObjectNotNil(reason), HDFailureLevelWarning, return nil);
	
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
	[userInfo setObject:self forKey:NSValidationObjectErrorKey];
	
	if (reason)
	{
		[userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
	}
	
	return [NSError errorWithDomain:domain code:NSManagedObjectValidationError userInfo:userInfo];
}

- (NSError*)errorFromOriginalError:(NSError*)originalError error:(NSError*)secondError
{
	HDAssert(isObjectNotNil(secondError), HDFailureLevelWarning);
	
	if (!originalError || !secondError)
	{
		return secondError;
	}

	NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
	NSMutableArray* errors = [NSMutableArray arrayWithObject:secondError];
	
	if ([originalError code] == NSValidationMultipleErrorsError)
	{
		[userInfo addEntriesFromDictionary:[originalError userInfo]];
		[errors addObjectsFromArray:[userInfo objectForKey:NSDetailedErrorsKey]];
	}
	else
	{
		[errors addObject:originalError];
	}

	[userInfo setObject:errors forKey:NSDetailedErrorsKey];

	return [NSError errorWithDomain:NSCocoaErrorDomain code:NSValidationMultipleErrorsError userInfo:userInfo];
}

#pragma mark - NSManagedObject Methods

- (void)willChangeValueForKey:(NSString*)key
{
	HDAssert(isFalse([self isImmutable]), HDFailureLevelError);
	[super willChangeValueForKey:key];
}

@end
