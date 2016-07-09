//
//  MultiPlayerCardFitViewController.h
//  CardFit
//
//  Created by Braden Gray on 5/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardFitCard.h"
#import "MultiplayerNetworking.h"

@interface MultiPlayerCardFitViewController : UIViewController <MultiplayerNetworkingProtocol>

@property (nonatomic) CGFloat cardAspectRatio;
@property (nonatomic) NSUInteger maxCardHeight;
@property (nonatomic) NSUInteger maxCardWidth;
@property (nonatomic) NSUInteger minCardHeight;
@property (nonatomic) NSUInteger minCardWidth;
@property (nonatomic) NSUInteger numberOfCards;
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine;
@property (nonatomic) BOOL multiplayer;

- (Deck *)createDeck; //abstract
- (id)settings; //abstract
- (void)recievedSettings:(id)settings; //abstract
- (UIView *)createCardViewWithCard:(Card *)card; //abstract
- (void)updateCardView:(UIView *)cardView withCard:(Card *)card; //abstract

@end
