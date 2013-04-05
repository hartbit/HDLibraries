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
@property (nonatomic, getter = isDragEnabled) BOOL dragEnabled;
@property (nonatomic, readonly) BOOL isDragging;

- (void)saveFrame;
- (void)restoreSavedFrameAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (void)willDrag;
- (void)didDrop;
- (void)didCancelDrag;

@end


@protocol HDDraggableButtonDelegate <NSObject>

@optional
- (void)draggableButtonWillDrag:(HDDraggableButton*)button;
- (void)draggableButtonDidDrop:(HDDraggableButton*)button;
- (void)draggableButtonDidCancelDrag:(HDDraggableButton*)button;

@end