//
//  CardFitLayoutView.h
//  CardFit
//
//  Created by Braden Gray on 4/7/16.
//  Copyright © 2016 Graycode. All rights reserved.
//
//  Used to layout all most aspects of the CardFitViewController into a super view including the CardView, PauseButton, TaskLabel,
//  Timer Label, and CountDownLabel

#import <UIKit/UIKit.h>

@interface CardFitLayoutView : UIView

//required
@property (nonatomic) CGSize size; //Sets the size of the container view

//optional
@property (nonatomic) BOOL rotated; //Tells if superview has changed orientation

//outputs
@property (nonatomic, readonly) CGSize subViewSize; //Returns the size of card read only

//origin of Frame should be called after each change of orientation of superview
- (CGRect)frameForCardView:(UIView *)cardView; //Returns a rect for the card

@end
