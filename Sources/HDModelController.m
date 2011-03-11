//
//  HDModelController.m
//  HDFoundation
//
//  Created by David Hart on 17/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDModelController.h"


@implementation HDModelController

@synthesize modelURL = _modelURL;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Lifecycle

- (void)dealloc
{
	[_persistentStoreCoordinator release];
	[_managedObjectContext release];
	[_managedObjectModel release];
	
	[super dealloc];
}

#pragma mark - Properties

- (NSManagedObjectModel*)managedObjectModel
{
	if (_managedObjectModel) return _managedObjectModel;
	
	if (_modelURL)
	{
		_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:_modelURL];
	}
	else
	{
		_managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	}
	
	return _managedObjectModel;
}

- (NSManagedObjectContext*)managedObjectContext
{
	if (_managedObjectContext) return _managedObjectContext;

	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	[_managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
	return _managedObjectContext;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
	if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
    
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	return _persistentStoreCoordinator;
}

#pragma mark - Public Methods

- (void)addStoreWithURL:(NSURL*)storeURL
{
	NSError* error = nil;
	NSPersistentStore* store = [[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType
																			   configuration:nil
																						 URL:storeURL
																					 options:nil
																					   error:&error];

	if (!store || error)
	{
		NSLog(@"Store error %@, %@", error, [error userInfo]);
		abort();
	}
}

- (void)saveContext
{
	NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
	
	if (managedObjectContext && [managedObjectContext hasChanges])
	{
		NSError* error = nil;
		BOOL success = [managedObjectContext save:&error];
		
		if (!success || error)
		{
			NSLog(@"Save error %@, %@", error, [error userInfo]);
			abort();
		}
	}
}

@end
