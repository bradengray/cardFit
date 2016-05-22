//
//  ViewController.h
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardFitViewController : UIViewController

@property (nonatomic) CGFloat cardAspectRatio;
@property (nonatomic) NSUInteger maxCardHeight;
@property (nonatomic) NSUInteger maxCardWidth;
@property (nonatomic) NSUInteger minCardHeight;
@property (nonatomic) NSUInteger minCardWidth;
@property (nonatomic) NSUInteger numberOfCards;

- (Deck *)createDeck; //abstract
- (UIView *)createCardViewWithCard:(Card *)card; //abstract
- (void)updateCardView:(UIView *)cardView withCard:(Card *)card; //abstract
- (NSString *)setTitleForCardView:(Card *)card; //abstract
- (NSNumber *)repsForCard:(Card *)card; //abstract

@end

