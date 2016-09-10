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

@interface Orientation : UIView

//optional
//@property (nonatomic) BOOL rotated; //Tells if superview has changed orientation

+ (BOOL)landscapeOrientation; //Class method returns yes if rotated to landscape

@end
