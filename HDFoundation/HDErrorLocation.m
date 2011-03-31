//
//  HDErrorLocation.m
//  Imagidoux
//
//  Created by David Hart on 3/30/11.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDErrorLocation.h"


@interface HDErrorLocation ()

- (id)initWithObject:(id)object context:(NSString*)context fileName:(NSString*)fileName lineNumber:(NSUInteger)lineNumber;

@end


@implementation HDErrorLocation

@synthesize object = _object;
@synthesize context = _context;
@synthesize fileName = _fileName;
@synthesize lineNumber = _lineNumber;

#pragma mark - Initializers

+ (id)errorLocationInFunction:(NSString*)function fileName:(NSString*)fileName lineNumber:(NSUInteger)lineNumber
{
	return [[[HDErrorLocation alloc] initWithObject:nil context:function fileName:fileName lineNumber:lineNumber] autorelease];
}

+ (id)errorLocationInObject:(id)object method:(SEL)selector fileName:(NSString*)fileName lineNumber:(NSUInteger)lineNumber
{
	NSString* context = [NSString stringWithFormat:@"[%@ %@]", NSStringFromClass([object class]), NSStringFromSelector(selector)];
	return [[[HDErrorLocation alloc] initWithObject:object context:context fileName:fileName lineNumber:lineNumber] autorelease];
}

#pragma mark - NSObject Methods

- (NSString*)description
{
	return [NSString stringWithFormat:@"%@, %@:%i", [self context], [self fileName], [self lineNumber]];
}

#pragma mark - Private Methods

- (id)initWithObject:(id)object context:(NSString*)context fileName:(NSString*)fileName lineNumber:(NSUInteger)lineNumber
{
	if ((self = [super init]))
	{
		[self setObject:object];
		[self setContext:context];
		[self setFileName:fileName];
		[self setLineNumber:lineNumber];
	}
	
	return self;
}

@end
