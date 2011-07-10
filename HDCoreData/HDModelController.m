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
	
	NSError* error = nil;
	[[self persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
	HDCheck(isObjectNil(error), HDFailureLevelError, return);
}

- (void)saveContext
{
	NSError* error = nil;
	[self saveContextWithError:&error];
	HDCheck(isObjectNil(error), HDFailureLevelFatal, return);
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
