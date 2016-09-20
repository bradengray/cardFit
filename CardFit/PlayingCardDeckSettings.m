//
//  PlayingCardDeckSettings.m
//  CardFit
//
//  Created by Braden Gray on 9/15/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardDeckSettings.h"
#import "PlayingCardSettings.h"

//Keys for NumberOfCardsOptions
#define TWENTY_CARDS @"20 CARDS"
#define TWENTY_FIVE_CARDS @"25 CARDS"
#define THIRTY_CARDS @"30 CARDS"
#define THIRTY_FIVE_CARDS @"35 CARDS"
#define FORTY_CARDS @"40 CARDS"
#define FORTY_FIVE_CARDS @"45 CARDS"
#define ONE_DECK @"ONE DECK"
#define TWO_DECKS @"TWO DECKS"
#define THREE_DECKS @"THREE DECKS"
#define FOUR_DECKS @"FOUR DECKS"
#define SIX_DECKS @"SIX DECKS"
#define EIGHT_DECKS @"EIGHT DECKS"
#define TEN_DECKS @"TEN DECKS"

@interface PlayingCardDeckSettings ()

@property (nonatomic, strong) PlayingCardSettings *settings; //Contains settings object

@end

@implementation PlayingCardDeckSettings

#pragma mark - Settings Methods

- (NSDictionary *)values { //Return values
    return @{NUMBER_OF_CARDS : self.numberOfCards};
}

#pragma mark - CardDeck Methods

- (NSArray *)numberOfCardsKeys { //Return number of cards keys based on multiplayer
    if (self.multiplayer) {
        return @[TWENTY_CARDS, THIRTY_CARDS, FORTY_CARDS, ONE_DECK, TWO_DECKS, THREE_DECKS, FOUR_DECKS, SIX_DECKS, EIGHT_DECKS, TEN_DECKS];
    } else {
        return @[TWENTY_CARDS, TWENTY_FIVE_CARDS, THIRTY_CARDS, THIRTY_FIVE_CARDS, FORTY_CARDS, FORTY_FIVE_CARDS, ONE_DECK];
    }
}

- (NSUInteger)getNumberOfCards { //Return interger value for numberOfCards
    return [[[self numberOfCardsValuesForKey] objectForKey:self.numberOfCards] unsignedIntegerValue];
}

- (NSDictionary *)numberOfCardsValuesForKey { //Dictonary contains integer value for numberOfCardsKeys
    BOOL playWithJokers = [[self.settings getValueForKey:JOKERS_BOOLEAN_KEY] isKindOfClass:[NSNumber class]] ? [(NSNumber *)[self.settings valueForKey:JOKERS_BOOLEAN_KEY] boolValue]: NO;
    if (self.multiplayer) {
        return @{TWENTY_CARDS : @5, THIRTY_CARDS : @30, FORTY_CARDS : @40, ONE_DECK : playWithJokers ? @54 : @52, TWO_DECKS : playWithJokers ? @108 : @104, THREE_DECKS : playWithJokers ? @162 : @156, FOUR_DECKS : playWithJokers ? @216 : @208, SIX_DECKS : playWithJokers ? @324 : @312, EIGHT_DECKS : playWithJokers ? @432 : @416, TEN_DECKS : playWithJokers ? @540 : @520};
    } else {
        return @{TWENTY_CARDS : @5, TWENTY_FIVE_CARDS : @25, THIRTY_CARDS : @30, THIRTY_FIVE_CARDS : @35, FORTY_CARDS : @40, FORTY_FIVE_CARDS : @45, ONE_DECK : playWithJokers ? @54 : @52};
    }
}

@end
