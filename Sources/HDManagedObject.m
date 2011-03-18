//
//  HDManagedObject.m
//  HDFoundation
//
//  Created by David Hart on 10/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDManagedObject.h"
#import "HDMacros.h"


@implementation HDManagedObject

#pragma mark - Public Methods

- (NSError*)validationErrorWithDomain:(NSString*)domain reason:(NSString*)reason
{
	HDRequire(domain);
	HDRequire(reason);
	
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
	[userInfo setObject:self forKey:NSValidationObjectErrorKey];
	
	if (reason)
	{
		[userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
	}
	
	NSError* error = [NSError errorWithDomain:domain code:NSManagedObjectValidationError userInfo:userInfo];
	
	HDEnsure(error);
	return error;
}

- (NSError*)errorFromOriginalError:(NSError*)originalError error:(NSError*)secondError
{
	HDRequire(secondError);
	
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

	NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:NSValidationMultipleErrorsError userInfo:userInfo];
	
	HDEnsure(error);
	return error;
}

@end
