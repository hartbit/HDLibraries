//
//  HDKeyValueStore.m
//  HDLibraries
//
//  Created by Hart David on 11.08.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "HDKeyValueStore.h"
#import "NSString+HDAdditions.h"
#import "HDMacros.h"


@interface HDKeyValueStore ()

@property (nonatomic, strong) NSUbiquitousKeyValueStore* cloudStore;

@end


@implementation HDKeyValueStore

#pragma mark - Properties

- (NSUbiquitousKeyValueStore*)cloudStore
{
	if (_cloudStore == nil)
	{
		[self setCloudStore:[NSClassFromString(@"NSUbiquitousKeyValueStore") defaultStore]];		
		[self synchronize];
	}
	
	return _cloudStore;
}

#pragma mark - Public Methods

- (void)registerDefaults:(NSDictionary*)defaults
{
	if ([self keyPrefix] != nil)
	{
		NSMutableDictionary* prefixedDefaults = [NSMutableDictionary dictionary];
		
		[defaults enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL* stop) {
			[prefixedDefaults setObject:object forKey:[self fullKeyForKey:key]];
		}];
		
		defaults = prefixedDefaults;
	}
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (BOOL)boolForKey:(NSString*)key
{
	id object = [self objectForKey:key];
	
	if ([object respondsToSelector:@selector(boolValue)])
	{
		return [object boolValue];
	}
	else
	{
		return NO;
	}
}

- (float)floatForKey:(NSString*)key
{
	id object = [self objectForKey:key];
	
	if ([object respondsToSelector:@selector(floatValue)])
	{
		return [object floatValue];
	}
	else
	{
		return 0;
	}
}

- (double)doubleForKey:(NSString*)key
{
	id object = [self objectForKey:key];
	
	if ([object respondsToSelector:@selector(doubleValue)])
	{
		return [object doubleValue];
	}
	else
	{
		return 0;
	}
}

- (NSInteger)integerForKey:(NSString*)key
{
	id object = [self objectForKey:key];
	
	if ([object respondsToSelector:@selector(integerValue)])
	{
		return [object integerValue];
	}
	else
	{
		return 0;
	}
}

- (NSUInteger)unsignedIntegerForKey:(NSString*)key
{
	id object = [self objectForKey:key];
	
	if ([object respondsToSelector:@selector(unsignedIntegerValue)])
	{
		return [object unsignedIntegerValue];
	}
	else
	{
		return 0;
	}
}

- (NSString*)stringForKey:(NSString*)key
{
	id object = [self objectForKey:key];
	
	if ([object isKindOfClass:[NSString class]])
	{
		return object;
	}
	else
	{
		return nil;
	}
}

- (NSDate*)dateForKey:(NSString*)key
{
	id object = [self objectForKey:key];
	
	if ([object isKindOfClass:[NSDate class]])
	{
		return object;
	}
	else
	{
		return nil;
	}
}

- (id)objectForKey:(NSString*)key
{
	NSString* fullKey = [self fullKeyForKey:key];
	id localValue = [[NSUserDefaults standardUserDefaults] objectForKey:fullKey];
	
	if (![self shouldUseCloudForKey:key])
	{
		return localValue;
	}
	
	id cloudValue = [[self cloudStore] objectForKey:fullKey];
	
	if ([cloudValue isEqual:localValue])
	{
		return localValue;
	}
	
	id mergedValue = [self mergeCloudValue:cloudValue withLocalValue:localValue forKey:key];
	
	if (![cloudValue isEqual:mergedValue])
	{
		[[self cloudStore] setObject:mergedValue forKey:fullKey];
	}
	
	if (![localValue isEqual:localValue])
	{
		[[NSUserDefaults standardUserDefaults] setObject:mergedValue forKey:fullKey];
	}
	
	return mergedValue;
}

- (void)setBool:(BOOL)value forKey:(NSString*)key
{
	[self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void)setFloat:(float)value forKey:(NSString*)key
{
	[self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)setDouble:(double)value forKey:(NSString*)key
{
	[self setObject:[NSNumber numberWithDouble:value] forKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString*)key
{
	[self setObject:[NSNumber numberWithInteger:value] forKey:key];
}

- (void)setUnsignedInteger:(NSUInteger)value forKey:(NSString*)key
{
	[self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:key];
}

- (void)setString:(NSString*)value forKey:(NSString*)key
{
	[self setObject:value forKey:key];
}

- (void)setDate:(NSDate*)value forKey:(NSString*)key
{
	[self setObject:value forKey:key];
}

- (void)setObject:(id)object forKey:(NSString*)key
{
	NSString* fullKey = [self fullKeyForKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:object forKey:fullKey];
	
	if ([self shouldUseCloudForKey:key])
	{
		[[self cloudStore] setObject:object forKey:fullKey];
	}
}

- (void)removeObjectForKey:(NSString*)key
{
	NSString* fullKey = [self fullKeyForKey:key];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:fullKey];
	
	if ([self shouldUseCloudForKey:key])
	{
		[[self cloudStore] removeObjectForKey:fullKey];
	}
}

- (HDKeyValueStoreSychronizationState)synchronize
{
	HDKeyValueStoreSychronizationState state = HDKeyValueStoreSychronizationFailed;
	
	if ([[NSUserDefaults standardUserDefaults] synchronize])
	{
		state |= HDKeyValueStoreSychronizationLocal;
	}
	
	if ([[self cloudStore] synchronize])
	{
		state |= HDKeyValueStoreSychronizationCloud;
	}
	
	return state;
}

- (NSDictionary*)dictionaryRepresentation
{
	NSString* keyPrefix = [self keyPrefix];
	NSUInteger prefixLength = [keyPrefix length];
	NSMutableSet* allKeys = [NSMutableSet set];
	
	void (^filterKeys)(id, id, BOOL*) = ^(id key, id obj, BOOL* stop) {
		if ([key startsWithString:keyPrefix]) {
			[allKeys addObject:[key substringFromIndex:prefixLength]];
		}
	};
	
	[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] enumerateKeysAndObjectsUsingBlock:filterKeys];
	[[[self cloudStore] dictionaryRepresentation] enumerateKeysAndObjectsUsingBlock:filterKeys];

	NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
	
	for (NSString* key in allKeys)
	{
		id value = [self objectForKey:key];
		
		if (value != nil)
		{
			[dictionary setObject:value forKey:key];
		}
	}

	return dictionary;
}

- (NSString*)fullKeyForKey:(NSString*)key
{
	if ([self keyPrefix] != nil)
	{
		return [[self keyPrefix] stringByAppendingString:key];
	}
	else
	{
		return key;
	}
}

- (BOOL)shouldUseCloudForKey:(NSString*)key
{
	if ([[self delegate] respondsToSelector:@selector(keyValueStore:shouldUseCloudForKey:)])
	{
		return [[self delegate] keyValueStore:self shouldUseCloudForKey:key];
	}
	
	return NO;
}

- (id)mergeCloudValue:(id)cloudValue withLocalValue:(id)localValue forKey:(NSString*)key
{
	if ([[self delegate] respondsToSelector:@selector(keyValueStore:mergeCloudValue:withLocalValue:forKey:)])
	{
		return [[self delegate] keyValueStore:self mergeCloudValue:cloudValue withLocalValue:localValue forKey:key];
	}
	
	return (cloudValue != nil) ? cloudValue : localValue;
}

@end
