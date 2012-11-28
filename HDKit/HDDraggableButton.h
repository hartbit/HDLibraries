//
//  HDDraggableButton.h
//  HDLibraries
//
//  Created by David Hart on 5/10/10.
//  Copyright 2010 hart[dev]. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HDDraggableButtonDelegate;

@interface HDDraggableButton : UIButton

@property (nonatomic, unsafe_unretained) IBOutlet id<HDDraggableButtonDelegate> delegate;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray* targetViews;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) BOOL dragEnabled;
@property (nonatomic, assign) CGPoint startOrigin;

- (void)returnToStart;
- (void)returnToStartAnimated:(BOOL)animated;
- (void)willDrag;
- (void)didDropOnTarget:(UIView*)target;
- (void)didReturnToStart;

@end


@protocol HDDraggableButtonDelegate <NSObject>

@optional
- (void)draggableButtonWillDrag:(HDDraggableButton*)button;
- (void)draggableButton:(HDDraggableButton*)button didDropOnTarget:(UIView*)onTarget;
- (void)draggableButtonDidReturnToStart:(HDDraggableButton*)button;

@end