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

+ (NSEntityDescription*)entity;
+ (id)insertNewObject;
+ (NSSet*)allObjects;
+ (NSSet*)allObjectsWithPredicate:(NSPredicate*)predicate;
+ (NSArray*)allObjectsSortedByKey:(NSString*)key ascending:(BOOL)ascending;
+ (NSArray*)allObjectsWithPredicate:(NSPredicate*)predicate sortedByKey:(NSString*)key ascending:(BOOL)ascending;

- (void)delete;
- (NSError*)validationErrorWithDomain:(NSString*)domain reason:(NSString*)reason;
- (NSError*)errorFromOriginalError:(NSError*)originalError error:(NSError*)secondError;

@end
