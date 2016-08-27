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
#import "MultiplayerNetworking.h"
#import "FireWorksView.h"

@interface CardFitViewController : UIViewController <MultiplayerNetworkingProtocol>
@property (strong, nonatomic) IBOutlet FireWorksView *fireWorksView;

//Required Set in subclass viewDidLoad
@property (nonatomic) CGFloat cardAspectRatio; //Sets aspect ration for Card
@property (nonatomic) NSUInteger maxCardHeight; //Sets max card height
@property (nonatomic) NSUInteger maxCardWidth; //Sets max card width
//Optional Set in subclass viewDidLoad
@property (nonatomic) NSUInteger minCardHeight; //Sets min card height
@property (nonatomic) NSUInteger minCardWidth; //Sets min card Width

//Required for multiplayer
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine; //Networking engine for multiplayer
@property (nonatomic) BOOL multiplayer; //Required to be set for multiplayer games

//Required
- (Deck *)createDeck; //abstract Creates deck for game play
- (id)settings; //abstract Returns settings object
- (void)recievedSettings:(id)settings; //abstract called if new settings object recieved in multiplayer
- (UIView *)createCardViewWithCard:(Card *)card; //abstract create view for card
- (void)updateCardView:(UIView *)cardView withCard:(Card *)card; //abstract update cardview if selected
- (NSUInteger)numberOfCards; //abstract returns number of cards for game play
- (NSUInteger)pointsForCard:(Card *)card; //abstract returns points for card
- (NSString *)labelForCard:(Card *)card; //abstract returns label for card

@end
