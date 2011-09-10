//
//  HDKeyValueStore.h
//  HDLibraries
//
//  Created by Hart David on 11.08.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
	HDKeyValueStoreSychronizationFailed = 0,
	HDKeyValueStoreSychronizationDisk = 1,
	HDKeyValueStoreSychronizationCloud = 2
} HDKeyValueStoreSychronizationSuccess;


@interface HDKeyValueStore : NSObject

@property (nonatomic, strong) NSString* keyPrefix;

- (void)registerDefaults:(NSDictionary*)defaults;

- (BOOL)boolForKey:(NSString*)key;
- (float)floatForKey:(NSString*)key;
- (double)doubleForKey:(NSString*)key;
- (NSInteger)integerForKey:(NSString*)key;
- (NSUInteger)unsignedIntegerForKey:(NSString*)key;
- (NSString*)stringForKey:(NSString*)key;
- (NSDate*)dateForKey:(NSString*)key;
- (id)objectForKey:(NSString*)key;

- (void)setBool:(BOOL)value forKey:(NSString*)key;
- (void)setFloat:(float)value forKey:(NSString*)key;
- (void)setDouble:(double)value forKey:(NSString*)key;
- (void)setInteger:(NSInteger)value forKey:(NSString*)key;
- (void)setUnsignedInteger:(NSUInteger)value forKey:(NSString*)key;
- (void)setString:(NSString*)value forKey:(NSString*)key;
- (void)setDate:(NSDate*)value forKey:(NSString*)key;
- (void)setObject:(id)object forKey:(NSString*)key;

- (void)removeObjectForKey:(NSString*)key;
- (HDKeyValueStoreSychronizationSuccess)synchronize;
- (NSDictionary*)dictionaryRepresentation;
- (NSString*)fullKeyForKey:(NSString*)key;

@end
