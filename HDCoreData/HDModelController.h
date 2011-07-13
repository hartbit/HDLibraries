//
//  HDModelController.h
//  HDLibraries
//
//  Created by David Hart on 17/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface HDModelController : NSObject

@property (nonatomic, strong) NSURL* modelURL;
@property (nonatomic, strong, readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

+ (HDModelController*)sharedInstance;

- (void)addStoreWithURL:(NSURL*)storeURL;
- (void)assignObjectToFirstWritableStore:(NSManagedObject*)object;

- (void)saveContext;
- (BOOL)saveContextWithError:(NSError**)error;

@end
