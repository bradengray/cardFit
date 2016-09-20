//
//  CardFitViewController.h
//  CardFit
//
//  Created by Braden Gray on 5/30/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Card.h"
#import "GameDataController.h"
#import "MultiplayerNetworking.h"

@interface CardFitViewController : UIViewController <MultiplayerNetworkingProtocol>

@property (nonatomic, strong) GameDataController *dataSource;

//Required for multiplayer
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine; //Networking engine for multiplayer

//Required
- (Deck *)createDeck; //abstract Creates deck for game play
- (UIView *)createCardViewWithCard:(Card *)card; //abstract create view for card
- (void)updateCardView:(UIView *)cardView withCard:(Card *)card; //abstract update cardview if selected

@end
