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

@synthesize modelURL;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

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
	if (!managedObjectModel)
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
	
	HDEnsure(managedObjectModel);
	HDEnsure([managedObjectModel retainCount] == 1);
	return managedObjectModel;
}

- (NSManagedObjectContext*)managedObjectContext
{
	if (!managedObjectContext)
	{
		NSManagedObjectContext* newManagedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
		[self setManagedObjectContext:newManagedObjectContext];
		[newManagedObjectContext release];
	}
	
	HDEnsure(managedObjectContext);
	HDEnsure([managedObjectContext retainCount] == 1);
	return managedObjectContext;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator
{
	if (!persistentStoreCoordinator)
	{
		NSPersistentStoreCoordinator* newPersistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
		[self setPersistentStoreCoordinator:newPersistentStoreCoordinator];
		[newPersistentStoreCoordinator release];
	}
	
	HDEnsure(persistentStoreCoordinator);
	HDEnsure([persistentStoreCoordinator retainCount] == 1);
	return persistentStoreCoordinator;
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
	
	if ([self managedObjectContext] && [[self managedObjectContext] hasChanges])
	{
		success = [managedObjectContext save:error];
	}
	
	return success;
}

@end
