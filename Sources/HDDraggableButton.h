//
//  HDDraggableButton.h
//  HDFoundation
//
//  Created by David Hart on 5/10/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HDDraggableButtonDelegate;

@interface HDDraggableButton : UIButton

@property (nonatomic, retain) IBOutlet id <HDDraggableButtonDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIView* targetView;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) BOOL dragEnabled;

- (void)returnToStart;

@end


@protocol HDDraggableButtonDelegate <NSObject>

@optional
- (void)draggableButtonWillDrag:(HDDraggableButton*)button;
- (void)draggableButton:(HDDraggableButton*)button didDropOnTarget:(BOOL)onTarget;

@end