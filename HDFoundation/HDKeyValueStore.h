//
//  HDKeyValueStore.h
//  HDLibraries
//
//  Created by Hart David on 11.08.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, HDKeyValueStoreSychronizationState)
{
	HDKeyValueStoreSychronizationFailed = 0,
	HDKeyValueStoreSychronizationLocal = 1,
	HDKeyValueStoreSychronizationCloud = 2
};


@protocol HDKeyValueStoreDelegate;

@interface HDKeyValueStore : NSObject

@property (nonatomic, strong) NSString* keyPrefix;
@property (nonatomic, unsafe_unretained) id<HDKeyValueStoreDelegate> delegate;

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
- (HDKeyValueStoreSychronizationState)synchronize;
- (NSDictionary*)dictionaryRepresentation;
- (NSString*)fullKeyForKey:(NSString*)key;

- (BOOL)shouldUseCloudForKey:(NSString*)key;
- (id)mergeCloudValue:(id)cloudValue withLocalValue:(id)localValue forKey:(NSString*)key;

@end


@protocol HDKeyValueStoreDelegate <NSObject>

@optional
- (BOOL)keyValueStore:(HDKeyValueStore*)store shouldUseCloudForKey:(NSString*)key;
- (id)keyValueStore:(HDKeyValueStore*)store mergeCloudValue:(id)cloudValue withLocalValue:(id)localValue forKey:(NSString*)key;

@end