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
@property (nonatomic) CGFloat aspectRatio; //Sets the aspect ratio of the card

//optional
@property (nonatomic) CGFloat maxSubViewWidth; //Sets the maximum width for the subview
@property (nonatomic) CGFloat maxSubViewHeight; //Sets the maximum height for the subview
@property (nonatomic) CGFloat minSubViewWidth; //Sets the minimum width for the subview
@property (nonatomic) CGFloat minSubViewHeight; //Sets the minumum height for the subview
@property (nonatomic) BOOL rotated; //Tells if superview has changed orientation

//outputs
@property (nonatomic, readonly) CGSize subViewSize; //Returns the size of card read only

//origin of Frame should be called after each change of orientation of superview
- (CGRect)frameForCardView:(UIView *)cardView; //Returns a rect for the card
- (CGRect)frameForStartButton:(UIButton *)button; //Returns a rect for the start button
- (CGRect)frameForTasklabel:(UILabel *)label; //Returns a rect for the task label
- (CGRect)frameForTimerLabel:(UILabel *)label; //Returns a rect for the timer label

@end
