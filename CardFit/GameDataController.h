//
//  GameDataController.h
//  CardFit
//
//  Created by Braden Gray on 9/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "DataController.h"
#import "Card.h"
#import "Settings.h"

//Keys for sections
#define DEFAULTS @"DEFAULTS"
#define OPTIONS @"OPTIONS"
#define SUITS @"SUITS"
#define CARDS @"CARDS"

//Keys for Defaults
#define RESTORE_DEFAULTS @"Restore Defaults"

//Keys for Options
#define PLAY_WITH_JOKERS @"Play With Jokers"

//Keys for Suits
#define SPADE @"♠️"
#define CLUB @"♣️"
#define HEART @"♥️"
#define DIAMOND @"♦️"

//Keys for Cards
#define JACK @"Jack"
#define QUEEN @"Queen"
#define KING @"King"
#define ACE @"Ace"
#define JOKER @"Joker"

@interface GameDataController : DataController

@property (nonatomic) BOOL multiplayer; //Tells whether game is multiplayer or not
@property (nonatomic) NSUInteger numberOfCards; //stores the number of cards for a game

//Returns index of selected numberOfCards object
- (NSInteger)rowForSelectedNumberOfCards; //Abstract
//Returns points for card
- (NSUInteger)pointsForCard:(Card *)card; //Abstract
//Returns label for card
- (NSString *)labelForCard:(Card *)card; //Abstract
//sets new settings object for gameInfo
- (void)settingsForGameInfo:(id)gameInfo; //Abstract
//Returns Settings Object
-(Settings *)getSettings; //Abstract

@end
