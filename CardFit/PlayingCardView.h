//
//  PlayingCardView.h
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;

@end
