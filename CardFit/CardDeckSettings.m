//
//  CardDeckSettings.m
//  CardFit
//
//  Created by Braden Gray on 9/14/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardDeckSettings.h"

#define ONE_DECK @"ONE DECK"

@implementation CardDeckSettings

#pragma mark - Properties
//Synthesize for setters and getters
@synthesize numberOfCards = _numberOfCards;

- (NSString *)numberOfCards { //Lazy Instantiate numberOfCards
    if (self.getLocalValue) {
        return _numberOfCards ? _numberOfCards : 0;
    } else {
        return [self valueForKey:self.multiplayer ? MULTIPLAYER_NUMBER_OF_CARDS : NUMBER_OF_CARDS withDefaultString:ONE_DECK];
    }
}

- (void)setNumberOfCards:(NSString *)numberOfCards { //set numberOfCards
    if (self.getLocalValue) {
        _numberOfCards = numberOfCards;
    } else {
        [self save:self.multiplayer ? @{MULTIPLAYER_NUMBER_OF_CARDS : numberOfCards} : @{NUMBER_OF_CARDS  : numberOfCards}];
        [self settingChanged];
    }
}

- (NSArray *)numberOfCardsKeys { //Contains array for numberOfCards Keys
    return @[ONE_DECK];
}

#pragma mark - Abstract Methods
//Get integer value for numberOfcards
- (NSUInteger)getNumberOfCards; { //Abstract
    return [[[self numberOfCardsValuesForKey] objectForKey:self.numberOfCards] unsignedIntegerValue];
}

#pragma mark - Settings Methods

- (NSDictionary *)values {
    return @{NUMBER_OF_CARDS : self.numberOfCards};
}

#pragma mark - Helper Methods

- (NSDictionary *)numberOfCardsValuesForKey { //Dictonary contains integer value for numberOfCardsKeys
    return @{ONE_DECK : @52};
    
}

@end
