//
//  HDModelController.h
//  HDLibraries
//
//  Created by David Hart on 17/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface HDModelController : NSObject

@property (nonatomic, retain) NSURL* modelURL;
@property (nonatomic, retain, readonly) NSManagedObjectModel* managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;

+ (HDModelController*)sharedInstance;

- (void)addStoreWithURL:(NSURL*)storeURL;
- (void)saveContext;
- (BOOL)saveContextWithError:(NSError**)error;

@end
