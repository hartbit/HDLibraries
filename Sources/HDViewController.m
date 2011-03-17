//
//  HDViewController.m
//  Library
//
//  Created by David Hart on 07/03/2011.
//  Copyright 2011 hart[dev]. All rights reserved.
//

#import "HDViewController.h"


@interface HDViewController ()

@property (nonatomic, copy) NSString* controllerName;
@property (nonatomic, retain) NSSet* outlets;

- (void)initialize;
- (void)releaseOutlets;

@end


@implementation HDViewController

@synthesize controllerName = _controllerName;
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
	[self setControllerName:nil];
	
	[super dealloc];
}

#pragma mark - UIVIewController Methods

- (void)viewWillDisappear:(BOOL)animated
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[super viewWillDisappear:animated];
}

#pragma mark - Properties

- (NSString*)controllerName
{	
	if (!_controllerName)
	{
		NSString* className = NSStringFromClass([self class]);
		NSRange postfixRange = [className rangeOfString:@"ViewController"];
		BOOL postfixIsAtEnd = postfixRange.location + postfixRange.length == [className length];
		NSAssert(postfixIsAtEnd, @"The view controller '%@' does not end in 'ViewController'.", className);
		
		if (postfixIsAtEnd)
		{
			_controllerName = [[className substringToIndex:postfixRange.location] retain];
		}
	}
	
	return [[_controllerName copy] autorelease];
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