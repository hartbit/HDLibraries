//
//  HDManagedObject.m
//  HDLibraries
//
//  Created by David Hart on 10/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDManagedObject.h"
#import "HDModelController.h"
#import "NimbusCore.h"


@implementation HDManagedObject

#pragma mark - Properties

- (BOOL)isImmutable
{
	return [[[[[self objectID] persistentStore] options] objectForKey:NSReadOnlyPersistentStoreOption] boolValue];
}

#pragma mark - Class Methods

+ (NSEntityDescription*)entity
{
	return [NSEntityDescription entityForName:NSStringFromClass([self class])
					   inManagedObjectContext:[[HDModelController sharedInstance] managedObjectContext]];
}

+ (id)insertNewObject
{
	return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
										 inManagedObjectContext:[[HDModelController sharedInstance] managedObjectContext]];
}

+ (NSSet*)allObjects
{
	return [NSSet setWithArray:[self allObjectsWithPredicate:nil sortedByKey:nil ascending:NO]];
}

+ (NSSet*)allObjectsWithPredicate:(NSPredicate*)predicate
{
	return [NSSet setWithArray:[self allObjectsWithPredicate:predicate sortedByKey:nil ascending:NO]];
}

+ (NSArray*)allObjectsSortedByKey:(NSString*)key ascending:(BOOL)ascending
{
	return [self allObjectsWithPredicate:nil sortedByKey:key ascending:ascending];
}

+ (NSArray*)allObjectsWithPredicate:(NSPredicate*)predicate sortedByKey:(NSString*)key ascending:(BOOL)ascending
{
	NSFetchRequest* request = [NSFetchRequest new];
	[request setEntity:[[self class] entity]];
	
	if (predicate) {
		[request setPredicate:predicate];
	}
	
	if (key) {
		NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
		NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[request setSortDescriptors:sortDescriptors];
	}
	
	NSError* error = nil;
	NSManagedObjectContext* managedObjectContext = [[HDModelController sharedInstance] managedObjectContext];
	NSArray* results = [managedObjectContext executeFetchRequest:request error:&error];
	NIDASSERT(!error);
	
	return results;
}

#pragma mark - Public Methods

- (void)delete
{
	[[self managedObjectContext] deleteObject:self];
}

- (NSError*)validationErrorWithDomain:(NSString*)domain reason:(NSString*)reason
{
	NIDASSERT(domain);
	NIDASSERT(reason);
	
	NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
	[userInfo setObject:self forKey:NSValidationObjectErrorKey];
	
	if (reason) {
		[userInfo setObject:reason forKey:NSLocalizedFailureReasonErrorKey];
	}
	
	return [NSError errorWithDomain:domain code:NSManagedObjectValidationError userInfo:userInfo];
}

- (NSError*)errorFromOriginalError:(NSError*)originalError error:(NSError*)secondError
{
	NIDASSERT(secondError);
	
	if (!originalError || !secondError) {
		return secondError;
	}

	NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
	NSMutableArray* errors = [NSMutableArray arrayWithObject:secondError];
	
	if ([originalError code] == NSValidationMultipleErrorsError) {
		[userInfo addEntriesFromDictionary:[originalError userInfo]];
		[errors addObjectsFromArray:[userInfo objectForKey:NSDetailedErrorsKey]];
	} else {
		[errors addObject:originalError];
	}

	[userInfo setObject:errors forKey:NSDetailedErrorsKey];

	return [NSError errorWithDomain:NSCocoaErrorDomain code:NSValidationMultipleErrorsError userInfo:userInfo];
}

#pragma mark - NSManagedObject Methods

- (void)willChangeValueForKey:(NSString*)key
{
	NIDASSERT(![self isImmutable]);
	[super willChangeValueForKey:key];
}

@end
