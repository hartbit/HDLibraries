//
//  HDViewController.m
//  Library
//
//  Created by David Hart on 07/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDViewController.h"


@interface HDViewController ()

@property (nonatomic, retain) NSSet* outlets;

- (void)initialize;
- (void)releaseOutlets;

@end


@implementation HDViewController

@synthesize outlets = _outlets;

#pragma mark - Iniitlization

- (id)init
{
	self = [super init];
	if (!self) return nil;
	
	[self initialize];
	
	return self;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (!self) return nil;
	
	[self initialize];
	
	return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
	self = [super initWithCoder:coder];
	if (!self) return nil;
	
	[self initialize];
	
	return self;
}

- (void)initialize
{
	[self setOutlets:[self viewOutlets]];
}

#pragma mark - Memory Management

- (void)viewDidUnload
{
	[self releaseOutlets];
	[super viewDidUnload];
}

- (void)dealloc
{
	[self releaseOutlets];
	[self setOutlets:nil];
	[super dealloc];
}

#pragma mark - Public Methods

- (NSSet*)viewOutlets
{
	return [NSSet set];
}

#pragma mark - Private Methods
		 
- (void)releaseOutlets
{
	for (NSString* outlet in _outlets)
	{
		[self setValue:nil forKey:outlet];
	}
}

@end