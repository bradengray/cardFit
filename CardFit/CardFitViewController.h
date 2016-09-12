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
#import "DataController.h"
#import "MultiplayerNetworking.h"

@interface CardFitViewController : UIViewController <MultiplayerNetworkingProtocol>
//@property (strong, nonatomic) IBOutlet FireWorksView *fireWorksView;

@property (nonatomic, strong) DataController *dataSource; //Stores data source

//Required for multiplayer
@property (nonatomic, strong) MultiplayerNetworking *networkingEngine; //Networking engine for multiplayer
@property (nonatomic) BOOL multiplayer; //Required to be set for multiplayer games

//Required
- (Deck *)createDeck; //abstract Creates deck for game play
- (DataController *)createDataSource; //Abstract creates data source
- (UIView *)createCardViewWithCard:(Card *)card; //abstract create view for card
- (void)updateCardView:(UIView *)cardView withCard:(Card *)card; //abstract update cardview if selected

#warning Temporary fix until I find a better way
//Did not work in layout subviews if viewController was entered from landscape orientation
- (void)rotate:(UIView *)cardView;

@end
