//
//  HDManagedObject.h
//  HDLibraries
//
//  Created by David Hart on 10/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface HDManagedObject : NSManagedObject

@property (nonatomic, assign, readonly) BOOL isImmutable;

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (id)insertNewEntityInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSSet*)allObjectsInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSSet*)allObjectsInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext withPredicate:(NSPredicate*)predicate;
+ (NSArray*)allObjectsInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext sortedByKey:(NSString*)key ascending:(BOOL)ascending;
+ (NSArray*)allObjectsInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext withPredicate:(NSPredicate*)predicate sortedByKey:(NSString*)key ascending:(BOOL)ascending;

- (void)delete;
- (NSError*)validationErrorWithDomain:(NSString*)domain reason:(NSString*)reason;
- (NSError*)errorFromOriginalError:(NSError*)originalError error:(NSError*)secondError;

@end
