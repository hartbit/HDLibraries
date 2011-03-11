//
//  HDManagedObject.m
//  HDFoundation
//
//  Created by David Hart on 10/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDManagedObject.h"


@implementation HDManagedObject

#pragma mark - Public Methods

- (NSError*)validationErrorWithDomain:(NSString*)domain reason:(NSString*)reason
{
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
	[userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
	[userInfo setObject:self forKey:NSValidationObjectErrorKey];
	
	return [NSError errorWithDomain:domain code:NSManagedObjectValidationError userInfo:userInfo];
}

- (NSError*)errorFromOriginalError:(NSError*)originalError error:(NSError*)secondError
{
	if (!originalError)
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

@end
