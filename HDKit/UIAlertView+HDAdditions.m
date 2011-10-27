//
//  UIAlertView+HDAdditions.m
//  HDLibraries
//
//  Created by Hart David on 27.10.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import "UIAlertView+HDAdditions.h"


static DismissBlock sDismissBlock;
static CancelBlock sCancelBlock;

@implementation UIAlertView (HDAdditions)

#pragma mark - Class Methods

+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title
							   message:(NSString*)message 
					 cancelButtonTitle:(NSString*)cancelButtonTitle
					 otherButtonTitles:(NSArray*)otherButtons
							 onDismiss:(DismissBlock)dismissBlock                   
							  onCancel:(CancelBlock)cancelBlock
{
	sDismissBlock  = [dismissBlock copy];
	sCancelBlock = [cancelBlock copy];
	
	UIAlertView* alert = [[self alloc] initWithTitle:title
											 message:message
											delegate:[self class]
								   cancelButtonTitle:cancelButtonTitle
								   otherButtonTitles:nil];
	
	for (NSString* buttonTitle in otherButtons)
	{
		[alert addButtonWithTitle:buttonTitle];
	}
    
	[alert show];
	return alert;
}

#pragma mark - UIAlertViewDelegate Methods

+ (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == [alertView cancelButtonIndex])
	{
		if (sCancelBlock != NULL)
		{
			sCancelBlock();
		}
	}
	else
	{
		if (sDismissBlock != NULL)
		{
			sDismissBlock(buttonIndex - 1);
		}
	}
}

@end
