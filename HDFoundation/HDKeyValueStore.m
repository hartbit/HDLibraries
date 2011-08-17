//
//  HDKeyValueStore.m
//  HDLibraries
//
//  Created by Hart David on 11.08.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "HDKeyValueStore.h"
#import "HDMacros.h"


@interface HDKeyValueStore ()

@property (nonatomic, strong) NSString* keyPrefix;
@property (nonatomic, strong) NSUbiquitousKeyValueStore* cloudStore;

@end


@implementation HDKeyValueStore

@synthesize keyPrefix = _keyPrefix;
@synthesize cloudStore = _cloudStore;

#pragma mark - Lifecycle

- (id)initWithKeyPrefix:(NSString*)keyPrefix
{
	if ((self = [super init]))
	{
		[self setKeyPrefix:keyPrefix];
		[self setCloudStore:[NSClassFromString(@"NSUbiquitousKeyValueStore") defaultStore]];
		[self synchronize];
	}
	
	return self;
}

#pragma mark - Public Methods

- (void)registerDefaults:(NSDictionary*)defaults
{
	if ([self keyPrefix] != nil)
	{
		NSMutableDictionary* prefixedDefaults = [NSMutableDictionary dictionary];
		
		[defaults enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL* stop)
		{
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
	id object = [[self cloudStore] objectForKey:fullKey];
	
	if (object == nil)
	{
		object = [[NSUserDefaults standardUserDefaults] objectForKey:fullKey];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] setObject:object forKey:fullKey];
	}
	
	return object;
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
	[[self cloudStore] setObject:object forKey:fullKey];
}

- (HDKeyValueStoreSychronizationSuccess)synchronize
{
	HDKeyValueStoreSychronizationSuccess success = HDKeyValueStoreSychronizationFailed;
	
	if ([[NSUserDefaults standardUserDefaults] synchronize])
	{
		success |= HDKeyValueStoreSychronizationDisk;
	}
	
	if ([[self cloudStore] synchronize])
	{
		success |= HDKeyValueStoreSychronizationCloud;
	}
	
	return success;
}

- (NSDictionary*)dictionaryRepresentation
{
	NSDictionary* dictionary = [[self cloudStore] dictionaryRepresentation];
	
	if (dictionary == nil)
	{
		dictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
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

@end