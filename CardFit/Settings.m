//
//  Settings.m
//  CardFit
//
//  Created by Braden Gray on 6/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Settings.h"

//Main dictionary key used to store all values in NSUserdefaults.
#define SETTINGS_DICTIONARY_KEY @"Settings Dictionary Key"

#define ONE_PLAYER_NUMBER_OF_CARDS_CHOSEN_KEY @"One Player Number Of Cards Chosen Key"
#define MULTIPLAYER_NUMBER_OF_CARDS_CHOSEN_KEY @"Two Player Number Of Cards Chosen Key"

//Keys for number of cards options strings.
#define TWENTY_CARDS @"20 Cards"
#define TWENTY_FIVE_CARDS @"25 Cards"
#define THIRTY_CARDS @"30 Cards"
#define THIRTY_FIVE_CARDS @"35 Cards"
#define FORTY_CARDS @"40 Cards"
#define FORTY_FIVE_CARDS @"45 Cards"
#define ONE_DECK @"One Deck"
#define TWO_DECKS @"Two Decks"
#define THREE_DECKS @"Three Decks"
#define FOUR_DECKS @"Four Decks"
#define SIX_DECKS @"Six Decks"
#define EIGHT_DECKS @"Eight Decks"
#define TEN_DECKS @"Ten Decks"

@implementation Settings

- (NSString *)valueForKey:(NSString *)key withDefaultString:(NSString *)defaultString { //Returns a value for the Key in NSUserDefaults or returns the default
    
    //Check to see if dictionary exists in NSUserdefaults
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_DICTIONARY_KEY] mutableCopy];
    //If settings doesn't exist return default
    if (!settings) {
        return defaultString;
    }
    //If settings dictionary does contain the key provided return the default value.
    if (![[settings allKeys] containsObject:key]) {
        return defaultString;
    }
    //If a value exists for the Key in the setting dictionary return that value.
    return settings[key];
}

- (void)setStringValue:(NSString *)string forKey:(NSString *)key { //Sets the new value for a key into NSUserdefaults
    
    //Check to see if setting dictionary exists in NSUserdefaults
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_DICTIONARY_KEY] mutableCopy];
    //If it does not then create it.
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    //Set the value in the dictionary for the given key.
    settings[key] = string;
    //Set the dicionary in NSUserdefaults.
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:SETTINGS_DICTIONARY_KEY];
    //Save Changes.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)valueForKey:(NSString *)key withDefaultValue:(NSUInteger)defaultValue { //Returns a value for the Key in NSUserDefaults or returns the default
    
    //Check to see if dictionary exists in NSUserdefaults
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_KEY] mutableCopy];
    //If settings doesn't exist return default
    if (!settings) {
        return defaultValue;
    }
    //If settings dictionary does contain the key provided return the default value.
    if (![[settings allKeys] containsObject:key]) {
        return defaultValue;
    }
    //If a value exists for the Key in the setting dictionary return that value.
    return [settings[key] longValue];
}

- (void)setNSUIntegerValue:(NSUInteger)value forKey:(NSString *)key { //Sets the new value for a key into NSUserdefaults
    
    //Check to see if setting dictionary exists in NSUserdefaults
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_KEY] mutableCopy];
    //If it does not then create it.
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    //Set the value in the dictionary for the given key.
    settings[key] = [NSNumber numberWithLong:value];
    //Set the dicionary in NSUserdefaults.
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:SETTINGS_DICTIONARY_KEY];
    //Save Changes.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Number Of Cards Settings

- (NSString *)onePlayerNumberOfCards { //Returns the number of cards used for OnePlayer Games or a default value.
    return [self valueForKey:ONE_PLAYER_NUMBER_OF_CARDS_CHOSEN_KEY withDefaultString:TWENTY_CARDS];
}

- (void)setOnePlayerNumberOfCards:(NSString *)onePlayerNumberOfCards { //Set the number of cards used for a OnePlayer Game in NSUserdefaults.
    [self setStringValue:onePlayerNumberOfCards forKey:ONE_PLAYER_NUMBER_OF_CARDS_CHOSEN_KEY];
}

- (NSString *)multiplayerNumberOfCards { //Returns the number of cards used for OnePlayer Games or a default value.
    return [self valueForKey:MULTIPLAYER_NUMBER_OF_CARDS_CHOSEN_KEY withDefaultString:ONE_DECK];
}

- (void)setMultiplayerNumberOfCards:(NSString *)multiplayerNumberOfCards { //Set the number of cards used for a OnePlayer Game in NSUserdefaults.
    [self setStringValue:multiplayerNumberOfCards forKey:MULTIPLAYER_NUMBER_OF_CARDS_CHOSEN_KEY];
}

- (NSArray *)onePlayerNumberOfCardsOptionStrings { //Returns an Array of strings used as options for the number of cards to be used in a OnePlayer Game.
    return @[TWENTY_CARDS, TWENTY_FIVE_CARDS, THIRTY_CARDS, THIRTY_FIVE_CARDS, FORTY_CARDS, FORTY_FIVE_CARDS, ONE_DECK, TWO_DECKS];
}

- (NSArray *)multiplayerNumberOfCardsOptionStrings { //Returns an Array of strings used as options for the number of cards to be used in a MultiPlayer Game.
    return @[TWENTY_CARDS, THIRTY_CARDS, FORTY_CARDS, ONE_DECK, TWO_DECKS, THREE_DECKS, FOUR_DECKS, SIX_DECKS, EIGHT_DECKS, TEN_DECKS];
}

- (NSDictionary *)numberOfCardsOptionValues { //Returns a dictionary of values for the number of cards to be used in OnePlayer or MultiPlayer Games.
    
    //Keys used as the values are the same as the strings used in the methods (NSArray *)onePlayerNumberOfCards and (NSArray *)multiPlayerNumberOfCards
    return @{TWENTY_CARDS : @5, TWENTY_FIVE_CARDS : @25, THIRTY_CARDS : @30, THIRTY_FIVE_CARDS : @35, FORTY_CARDS : @40, FORTY_FIVE_CARDS : @45, ONE_DECK : @54, TWO_DECKS : @108, THREE_DECKS : @162, FOUR_DECKS : @216, SIX_DECKS : @324, EIGHT_DECKS : @432, TEN_DECKS : @540};
}

+ (void)resetDefaults {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

#pragma mark - Abtracts

- (NSString *)labelForSuit:(NSUInteger)suit andRank:(NSUInteger)rank {
    return nil;
}

- (void)storeNewSettings:(NSDictionary *)settings { //Abstract
    return;
}

- (void)switchChanged:(BOOL)on { //Abstract
    return;
}

@end
