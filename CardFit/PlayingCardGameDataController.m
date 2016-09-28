//
//  PlayingCardGameDataController.m
//  CardFit
//
//  Created by Braden Gray on 9/15/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardGameDataController.h"
#import "PlayingCardDeckSettings.h"
#import "PlayingCardSettings.h"
#import "PlayingCard.h"

#define NUMBER_OF_CARDS_OPTIONS @"Card Options"

@interface PlayingCardGameDataController ()

@property (nonatomic, strong) PlayingCardDeckSettings *deckSettings; //deckSettings object
@property (nonatomic, strong) PlayingCardSettings *cardSettings; //cardSettings object

@end

@implementation PlayingCardGameDataController

#pragma mark - Properties
//Lazy instantiate deckSettings
- (PlayingCardDeckSettings *)deckSettings {
    if (!_deckSettings) {
        _deckSettings = [[PlayingCardDeckSettings alloc] init];
    }
    return _deckSettings;
}

//Lazy instantiate cardSettigns
- (PlayingCardSettings *)cardSettings {
    if (!_cardSettings) {
        _cardSettings = [[PlayingCardSettings alloc] init];
    }
    return _cardSettings;
}

//Return numberOfCards
- (NSUInteger)numberOfCards {
    return [self.deckSettings getNumberOfCards];
}

#pragma mark - Abstract Methods
//CreateData for Deck
- (NSDictionary *)createData {
    self.deckSettings.multiplayer = self.multiplayer;
    self.dataSectionTitles = @[NUMBER_OF_CARDS_OPTIONS];
    return @{NUMBER_OF_CARDS_OPTIONS : self.deckSettings.numberOfCardsKeys};
}

//Indexpath selected
-(void)didSelectIndexPath:(NSIndexPath *)indexPath {
    self.deckSettings.numberOfCards = self.deckSettings.numberOfCardsKeys[indexPath.row];
}

//Return row for selected numberOfCards
- (NSInteger)rowForSelectedNumberOfCards {
    return [self.deckSettings.numberOfCardsKeys indexOfObject:self.deckSettings.numberOfCards];
}

#pragma mark - Labels and Points
//Return points for card
- (NSString *)labelForCard:(Card *)card {
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        NSString *rankKey = [self keyForRank:playingCard.rank];
        NSString *suitKey = [self keyForSuit:playingCard.suit];
        
        if (playingCard.rank < 2 || playingCard.rank > 13) {
            return [self labelForKey:rankKey];
        } else if (playingCard.rank > 10) {
            return [NSString stringWithFormat:@"%@ %@", [self labelForKey:rankKey], [self labelForKey:suitKey]];
        } else {
            return [NSString stringWithFormat:@"%ld %@", playingCard.rank, [self labelForKey:suitKey]];
        }
    } else {
        NSLog(@"GameDataController Error: Incorrect type");
        return nil;
    }
}

//Returns the points for a specific rank
- (NSUInteger)pointsForCard:(Card *)card { //Abstract
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        NSString *key = [self keyForRank:playingCard.rank];
        if (key) {
            return [self pointsForKey:key];
        } else {
            return playingCard.rank;
        }
    } else {
        NSLog(@"GameDataController Error: Incorrect type");
        return 0;
    }
}

#pragma mark - Settings

//Sets new settings object
- (void)settingsForGameInfo:(id)gameInfo { //Abstract
    if ([gameInfo isKindOfClass:[PlayingCardSettings class]]) {
        self.cardSettings = (PlayingCardSettings *)gameInfo;
        self.cardSettings.getLocalValue = YES;
    } else {
        NSLog(@"Invalid Type of settings");
        return;
    }
}

//Returns settings
- (Settings *)getSettings { //Abstract
    return self.cardSettings;
}

#pragma mark - Helper Methods

//Returns a label string for a rank
- (NSString *)keyForRank:(NSUInteger)rank {
    if (rank == 1) {
        return ACE;
    } else if(rank == 11) {
        return JACK;
    } else if (rank == 12) {
        return QUEEN;
    } else if (rank == 13) {
        return KING;
    } else if (rank == 14) {
        return JOKER;
    } else {
        return nil;
    }
}

//Returns the points for a specific Key
- (NSUInteger)pointsForKey:(NSString *)key {
    if ([key isEqualToString: ACE]) {
        return [[self.cardSettings getValueForKey:ACES_POINTS_KEY] unsignedIntegerValue];
    } else if ([key isEqualToString:JACK]) {
        return [[self.cardSettings getValueForKey:JACKS_POINTS_KEY] unsignedIntegerValue];
    } else if ([key isEqualToString:QUEEN]) {
        return [[self.cardSettings getValueForKey:QUEENS_POINTS_KEY] unsignedIntegerValue];
    } else if ([key isEqualToString:KING]) {
        return [[self.cardSettings getValueForKey:KINGS_POINTS_KEY] unsignedIntegerValue];
    } else if ([key isEqualToString:JOKER]) {
        return [[self.cardSettings getValueForKey:JOKERS_POINTS_KEY] unsignedIntegerValue];
    } else {
        return 0;
    }
}

//Returns a card label for a given dictionary key
- (NSString *)labelForKey:(NSString *)key {
    NSString *label = [self exerciseForKey:key];
    if (label) {
        return label;
    } else {
        return [NSString stringWithFormat:@"%ld", [self pointsForKey:key]];
    }
}

//Returns the exercise for a specific Key
- (NSString *)exerciseForKey:(NSString *)key {
    if ([key isEqualToString:SPADE]) {
        return [self.cardSettings getValueForKey:SPADES_EXCERCISE_KEY];
    } else if ([key isEqualToString:CLUB]) {
        return [self.cardSettings getValueForKey:CLUBS_EXCERCISE_KEY];
    } else if ([key isEqualToString:HEART]) {
        return [self.cardSettings getValueForKey:HEARTS_EXCERCISE_KEY];
    } else if ([key isEqualToString:DIAMOND]) {
        return [self.cardSettings getValueForKey:DIAMONDS_EXCERCISE_KEY];
    } else if ([key isEqualToString:ACE]) {
        return [self.cardSettings getValueForKey:ACES_EXERCISE_KEY];
    } else if ([key isEqualToString:JOKER]) {
        return [self.cardSettings getValueForKey:JOKERS_EXERCISE_KEY];
    } else {
        return nil;
    }
}

//Returns a label string for a suit
- (NSString *)keyForSuit:(NSUInteger)suit {
    if (suit == 0) {
        return SPADE;
    } else if (suit == 1) {
        return HEART;
    } else if (suit == 2) {
        return CLUB;
    } else if (suit == 3) {
        return DIAMOND;
    } else {
        return @"";
    }
}

@end
