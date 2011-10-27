//
//  UIAlertView+HDAdditions.h
//  HDLibraries
//
//  Created by Hart David on 27.10.11.
//  Copyright (c) 2011 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DismissBlock)(NSInteger buttonIndex);
typedef void (^CancelBlock)();


@interface UIAlertView (HDAdditions) <UIAlertViewDelegate>

+ (UIAlertView*)showAlertViewWithTitle:(NSString*)title                    
							   message:(NSString*)message 
					 cancelButtonTitle:(NSString*)cancelButtonTitle
					 otherButtonTitles:(NSArray*)otherButtons
							 onDismiss:(DismissBlock)dismissBlock                   
							  onCancel:(CancelBlock)cancelBlock;

@end
