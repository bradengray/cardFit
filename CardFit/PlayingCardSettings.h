//
//  Settings.h
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#define PROTOTYPE_CELL_KEY @"Cell"
#define PROTOTYPE_CELL_1 @"Cell1"
#define PROTOTYPE_CELL_2 @"Cell2"
#define PROTOTYPE_CELL_3 @"Cell3"

#define PROTOTYPE_CELL_1_BOOL_KEY @"Cell1 Bool Key"
#define PROTOTYPE_CELL_2_BOOL_KEY @"Cell2 Bool Key"
#define PROTOTYPE_CELL_3_BOOL_KEY @"Cell3 Bool Key"

#define TEXTLABEL_TITLE_KEY @"Title"
#define TEXTLABEL_DESCRIPTION_KEY @"Label Description"

#define EXERCISE @"Exercise"
#define REPS @"Reps"
#define DEFAULTS @"Restore Defaults"

#define CARD_LABEL @"Card Label"

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

#import <Foundation/Foundation.h>
#import "PlayingCard.h"

@interface PlayingCardSettings : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *sectionsArray;

//@property (nonatomic, strong) NSString *exerciseKey;
//@property (nonatomic, strong) NSString *repsKey;
//@property (nonatomic, strong) NSString *defaultsKey;
//@property (nonatomic, strong) NSString *jokerOptionsKey;

//Strings that hold the names of the exercies for the listed suits and ranks.
@property (nonatomic, strong) NSString *spadesExerciseString;
@property (nonatomic, strong) NSString *clubsExerciseString;
@property (nonatomic, strong) NSString *heartsExerciseString;
@property (nonatomic, strong) NSString *diamondsExerciseString;
@property (nonatomic, strong) NSString *acesExerciseString;
@property (nonatomic, strong) NSString *jokersExerciseString;

//Integers that hold the number of reps for the listed ranks. All cards numbered 2-10 have a rep value equal to the rank.
@property (nonatomic) NSUInteger jacksReps;
@property (nonatomic) NSUInteger queensReps;
@property (nonatomic) NSUInteger kingsReps;
@property (nonatomic) NSUInteger acesReps;
@property (nonatomic) NSUInteger jokersReps;

//Keeps a default number of cards chosen and also keeps track of last chosen number of cards.
@property (nonatomic, strong) NSString *onePlayerNumberOfCards;
@property (nonatomic, strong) NSString *multiplayerNumberOfCards;

//Bool for whether or not deck should have jokers;
@property (nonatomic) BOOL jokers;
@property (nonatomic) BOOL aceExerciseAndRepsLabel;
@property (nonatomic) BOOL jokerExerciseAndRepsLabel;

//Arrays containing string values for Number Of Card Options Menus
@property (nonatomic, strong) NSArray *onePlayerNumberOfCardsOptionStrings;
@property (nonatomic, strong) NSArray *multiplayerNumberOfCardsOptionStrings;

//Dictionary holding values for Number Of Card Options.
//The Keys for the values are the strings held by the Arrays onePlayerNumberOfCardsOptionStrings and twoPlayerNumberOfCardsOptionStrings.
@property (nonatomic, strong) NSDictionary *numberOfCardsOptionValues;

- (void)resetDefaults;
- (NSString *)labelForPlayingCard:(PlayingCard *)playingCard;

@end
