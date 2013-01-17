//
//  HDModelController.m
//  HDLibraries
//
//  Created by David Hart on 17/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDModelController.h"
#import "HDFoundation.h"
#import "NimbusCore.h"


@interface HDModelController ()

@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end


@implementation HDModelController

#pragma mark - Lifecycle

+ (HDModelController*)sharedInstance
{
	return (HDModelController*)HDCreateSingleton(^{
		return [HDModelController new];
	});
}

#pragma mark - Properties

- (NSManagedObjectModel*)managedObjectModel
{
	if (!_managedObjectModel) {
		NSURL* modelURL = [self modelURL];
		
		if (modelURL) {
			NSManagedObjectModel* newManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
			[self setManagedObjectModel:newManagedObjectModel];
		} else {
			[self setManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
		}
		
		NIDASSERT(_managedObjectModel);
	}
	
	return _managedObjectModel;
}

- (NSManagedObjectContext*)managedObjectContext
{
	if (!_managedObjectContext) {
		NSManagedObjectContext* newManagedObjectContext = [[NSManagedObjectContext alloc] init];
		[newManagedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
		[self setManagedObjectContext:newManagedObjectContext];
		
		NIDASSERT(_managedObjectContext);
	}
	
	return _managedObjectContext;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
	if (!_persistentStoreCoordinator) {
		NSPersistentStoreCoordinator* newPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		[self setPersistentStoreCoordinator:newPersistentStoreCoordinator];
		
		NIDASSERT(_persistentStoreCoordinator);
	}

	return _persistentStoreCoordinator;
}

#pragma mark - Public Methods

- (void)addStoreWithURL:(NSURL*)storeURL
{
	BOOL readOnly = NO;
	NSFileManager* fileManager = [NSFileManager new];
	
	if ([fileManager fileExistsAtPath:[storeURL path]] && ![fileManager isWritableFileAtPath:[storeURL path]]) {
		readOnly = YES;
	}
	
	[self addStoreWithURL:storeURL readOnly:readOnly];
}

- (void)addStoreWithURL:(NSURL*)storeURL readOnly:(BOOL)readOnly
{
	NIDASSERT(storeURL);
	
	NSDictionary* storeOptions = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSNumber numberWithBool:readOnly], NSReadOnlyPersistentStoreOption,
								  [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
								  [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	NSError* error = nil;
	[[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error];
	NIDASSERT(!error);
}

- (void)assignObjectToFirstWritableStore:(NSManagedObject*)object
{
	for (NSPersistentStore* store in [[self persistentStoreCoordinator] persistentStores]) {
		NSNumber* isReadOnlyNumber = [[store options] objectForKey:NSReadOnlyPersistentStoreOption];
		
		if (!isReadOnlyNumber || ![isReadOnlyNumber boolValue]) {
			[[self managedObjectContext] assignObject:object toPersistentStore:store];
			return;
		}
	}
	
	NIDERROR(@"Could not find a writable persistent store to assign object.");
}

- (void)saveContext
{
	NSError* error = nil;
	[self saveContextWithError:&error];
	NIDASSERT(!error);
}

- (BOOL)saveContextWithError:(NSError**)error
{
	NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
	
	if (managedObjectContext && [managedObjectContext hasChanges]) {
		return [managedObjectContext save:error];
	} else {
		return YES;
	}
}

@end
