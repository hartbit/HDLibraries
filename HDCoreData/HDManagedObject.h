//
//  HDManagedObject.h
//  HDLibraries
//
//  Created by David Hart on 10/02/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface HDManagedObject : NSManagedObject

@property (nonatomic, assign, getter=isImmutable) BOOL immutable;

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (id)insertNewEntityInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;
+ (NSSet*)fetchObjectsInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext withPredicate:(id)stringOrPredicate, ...;

- (NSError*)validationErrorWithDomain:(NSString*)domain reason:(NSString*)reason;
- (NSError*)errorFromOriginalError:(NSError*)originalError error:(NSError*)secondError;

@end
