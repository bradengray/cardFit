//
//  PlayingCardView.h
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger suit; //Contains numeric value for rank 0-4
@property (nonatomic) NSUInteger rank; //Contains numeric value for suit 0-14
@property (nonatomic) BOOL faceUp; //Bool value that determines whether or not the card is face up

@end
