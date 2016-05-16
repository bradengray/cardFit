//
//  Settings.h
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayingCardSettings : NSObject

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

//Arrays containing string values for Number Of Card Options Menus
@property (nonatomic, strong) NSArray *onePlayerNumberOfCardsOptionStrings;
@property (nonatomic, strong) NSArray *multiplayerNumberOfCardsOptionStrings;

//Dictionary holding values for Number Of Card Options.
//The Keys for the values are the strings held by the Arrays onePlayerNumberOfCardsOptionStrings and twoPlayerNumberOfCardsOptionStrings.
@property (nonatomic, strong) NSDictionary *numberOfCardsOptionValues;

@end
