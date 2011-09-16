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

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	return [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
}

+ (id)insertNewEntityInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSManagedObject* object = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
	[[HDModelController sharedInstance] assignObjectToFirstWritableStore:object];
	return object;
}

+ (NSSet*)allObjectsInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	return [NSSet setWithArray:[self allObjectsInManagedObjectContext:managedObjectContext withPredicate:nil sortedByKey:nil ascending:NO]];
}

+ (NSSet*)allObjectsInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext withPredicate:(NSPredicate*)predicate
{
	return [NSSet setWithArray:[self allObjectsInManagedObjectContext:managedObjectContext withPredicate:predicate sortedByKey:nil ascending:NO]];
}

+ (NSArray*)allObjectsInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext sortedByKey:(NSString*)key ascending:(BOOL)ascending
{
	return [self allObjectsInManagedObjectContext:managedObjectContext withPredicate:nil sortedByKey:key ascending:ascending];
}

+ (NSArray*)allObjectsInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext withPredicate:(NSPredicate*)predicate sortedByKey:(NSString*)key ascending:(BOOL)ascending
{
	NSFetchRequest* request = [NSFetchRequest new];
	
	NSEntityDescription* entity = [[self class] entityInManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	if (predicate != nil)
	{
		[request setPredicate:predicate];
	}
	
	if (key != nil)
	{
		NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
		NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
		[request setSortDescriptors:sortDescriptors];
	}
	
	NSError* error = nil;
	NSArray* results = [managedObjectContext executeFetchRequest:request error:&error];
	NIDASSERT(error == nil);
	
	return results;
}

#pragma mark - Public Methods

- (void)delete
{
	[[self managedObjectContext] deleteObject:self];
}

- (NSError*)validationErrorWithDomain:(NSString*)domain reason:(NSString*)reason
{
	NIDASSERT(domain != nil);
	NIDASSERT(reason != nil);
	
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
	NIDASSERT(secondError != nil);
	
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
	NIDASSERT(![self isImmutable]);
	[super willChangeValueForKey:key];
}

@end
