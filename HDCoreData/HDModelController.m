//
//  HDModelController.m
//  HDLibraries
//
//  Created by David Hart on 17/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDModelController.h"
#import "HDFoundation.h"


@interface HDModelController ()

@property (nonatomic, strong) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end


@implementation HDModelController

@synthesize modelURL = _modelURL;
@synthesize managedObjectModel = _manageObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Lifecycle

SYNTHESIZE_SINGLETON(HDModelController)

#pragma mark - Properties

- (NSManagedObjectModel*)managedObjectModel
{
	if (!_manageObjectModel)
	{
		if ([self modelURL])
		{
			NSManagedObjectModel* newManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelURL]];
			[self setManagedObjectModel:newManagedObjectModel];
		}
		else
		{
			[self setManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
		}
		
		HDAssert(isObjectNotNil(_manageObjectModel), HDFailureLevelError);
	}
	
	return _manageObjectModel;
}

- (NSManagedObjectContext*)managedObjectContext
{
	if (!_managedObjectContext)
	{
		NSManagedObjectContext* newManagedObjectContext = [[NSManagedObjectContext alloc] init];
		[newManagedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
		[self setManagedObjectContext:newManagedObjectContext];
		
		HDAssert(isObjectNotNil(_managedObjectContext), HDFailureLevelError);
	}
	
	return _managedObjectContext;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
	if (!_persistentStoreCoordinator)
	{
		NSPersistentStoreCoordinator* newPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		[self setPersistentStoreCoordinator:newPersistentStoreCoordinator];
		
		HDAssert(isObjectNotNil(_persistentStoreCoordinator), HDFailureLevelError);
	}

	return _persistentStoreCoordinator;
}

#pragma mark - Public Methods

- (void)addStoreWithURL:(NSURL*)storeURL
{
	HDCheck(isObjectNotNil(storeURL), HDFailureLevelWarning, return);
	
	NSMutableDictionary* storeOptions = [NSMutableDictionary dictionary];
	NSFileManager* fileManager = [NSFileManager new];
	
	if ([fileManager fileExistsAtPath:[storeURL path]] && ![fileManager isWritableFileAtPath:[storeURL path]])
	{
		[storeOptions setObject:[NSNumber numberWithBool:YES] forKey:NSReadOnlyPersistentStoreOption];
	}
	
	[storeOptions setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	[storeOptions setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];

	NSError* error = nil;
	[[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error];
	HDCheck(isObjectNil(error), HDFailureLevelError, return);
}

- (void)assignObjectToFirstWritableStore:(NSManagedObject*)object
{
	for (NSPersistentStore* store in [[self persistentStoreCoordinator] persistentStores])
	{
		NSNumber* isReadOnlyNumber = [[store options] objectForKey:NSReadOnlyPersistentStoreOption];
		
		if ((isReadOnlyNumber == nil) || ![isReadOnlyNumber boolValue])
		{
			[[self managedObjectContext] assignObject:object toPersistentStore:store];
			return;
		}
	}
	
	HDFail(@"Could not find a writable persistent store to save object.", HDFailureLevelFatal);
}

- (void)saveContext
{
	NSError* error = nil;
	[self saveContextWithError:&error];
	HDAssert(isObjectNil(error), HDFailureLevelFatal);
}

- (BOOL)saveContextWithError:(NSError**)error
{
	NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
	
	if (managedObjectContext && [managedObjectContext hasChanges])
	{
		return [managedObjectContext save:error];
	}
	else
	{
		return YES;
	}
}

@end
