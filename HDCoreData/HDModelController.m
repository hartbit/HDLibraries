//
//  HDModelController.m
//  HDFoundation
//
//  Created by David Hart on 17/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDModelController.h"
#import "HDMacros.h"


@interface HDModelController ()

@property (nonatomic, retain) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end


@implementation HDModelController

@synthesize modelURL = _modelURL;
@synthesize managedObjectModel = _manageObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Lifecycle

- (void)dealloc
{
	[self setPersistentStoreCoordinator:nil];
	[self setManagedObjectContext:nil];
	[self setManagedObjectModel:nil];
	
	[super dealloc];
}

#pragma mark - Properties

- (NSManagedObjectModel*)managedObjectModel
{
	if (!_manageObjectModel)
	{
		if ([self modelURL])
		{
			NSManagedObjectModel* newManagedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[self modelURL]];
			[self setManagedObjectModel:newManagedObjectModel];
			[newManagedObjectModel release];
		}
		else
		{
			[self setManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
		}
	}
	
	HDEnsure(_manageObjectModel);
	HDEnsure([_manageObjectModel retainCount] == 1);
	return _manageObjectModel;
}

- (NSManagedObjectContext*)managedObjectContext
{
	if (!_managedObjectContext)
	{
		NSManagedObjectContext* newManagedObjectContext = [[NSManagedObjectContext alloc] init];
		[newManagedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
		[self setManagedObjectContext:newManagedObjectContext];
		[newManagedObjectContext release];
	}
	
	HDEnsure(_managedObjectContext);
	HDEnsure([_managedObjectContext retainCount] == 1);
	return _managedObjectContext;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
	if (!_persistentStoreCoordinator)
	{
		NSPersistentStoreCoordinator* newPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		[self setPersistentStoreCoordinator:newPersistentStoreCoordinator];
		[newPersistentStoreCoordinator release];
	}
	
	HDEnsure(_persistentStoreCoordinator);
	HDEnsure([_persistentStoreCoordinator retainCount] == 1);
	return _persistentStoreCoordinator;
}

#pragma mark - Public Methods

- (void)addStoreWithURL:(NSURL*)storeURL error:(NSError**)error
{
	HDRequire(storeURL);
	
	[[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:error];
}

- (BOOL)saveContextWithError:(NSError**)error
{
	BOOL success = YES;
	NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
	
	if (managedObjectContext && [managedObjectContext hasChanges])
	{
		success = [managedObjectContext save:error];
	}
	
	return success;
}

@end
