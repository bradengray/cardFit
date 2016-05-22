//
//  Settings.m
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettings.h"

//Main dictionary key used to store all values in NSUserdefaults.
#define SETTINGS_DICTIONARY_KEY @"Settings Dictionary Key"

#define JOKERS_OPTIONS @"Play With Jokers"
#define ACE_EXERCISE_AND_REPS_LABEL @"Ace Label Options"
#define JOKER_EXERCISE_AND_REPS_LABEL @"Joker Label Options"

//Keys for exercises
#define SPADES_EXCERCISE_KEY @"Spades Exercise Key"
#define CLUBS_EXCERCISE_KEY @"Clubs Exercies Key"
#define HEARTS_EXCERCISE_KEY @"Hearts Exercise Key"
#define DIAMONDS_EXCERCISE_KEY @"Diamonds Exercies Key"
#define ACES_EXERCISE_KEY @"Aces Exercise Key"
#define JOKERS_EXERCISE_KEY @"Jokers Exercise Key"

//Keys for reps.
#define JACKS_REPS_KEY @"Jacks Reps Key"
#define QUEENS_REPS_KEY @"Queens Reps Key"
#define KINGS_REPS_KEY @"Kings Reps Key"
#define ACES_REPS_KEY @"Aces Reps Key"
#define JOKERS_REPS_KEY @"Jokers Reps Key"

//Keys for OnePlayer, MultiPlayer number of cards and Jokers boolean value.
#define ONE_PLAYER_NUMBER_OF_CARDS_CHOSEN_KEY @"One Player Number Of Cards Chosen Key"
#define MULTIPLAYER_NUMBER_OF_CARDS_CHOSEN_KEY @"Two Player Number Of Cards Chosen Key"
#define JOKERS_BOOLEAN_KEY @"Jokers Boolean Key"

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

@implementation PlayingCardSettings

#pragma mark - Settings

- (NSArray *)data {
    return @[[self defaults], [self options], [self suits], [self cards]];
}

- (NSArray *)sectionsArray {
    return @[@"Defaults", @"Options", @"Suits", @"Cards"];
}

#pragma mark - Keys

//- (NSString *)exerciseKey {
//    return EXERCISE;
//}
//
//- (NSString *)repsKey {
//    return REPS;
//}
//
//- (NSString *)defaultsKey {
//    return DEFAULTS;
//}
//
//- (NSString *)jokerOptionsKey {
//    return JOKER;
//}

#pragma mark - Section Arrays

- (NSArray *)suits {
    return @[[self spade], [self club], [self heart], [self diamond]];
}

- (NSArray *)cards {
    if (self.jokers) {
        return @[[self jack], [self queen], [self king], [self ace], [self joker]];
    } else {
        return @[[self jack], [self queen], [self king], [self ace]];
    }
}

- (NSArray *)defaults {
    return @[[self defaultButtons]];
}

- (NSArray *)options {
    return @[[self jokerOption]];
}

#pragma mark - Row Dictionaries

- (NSDictionary *)defaultButtons {
    return @{TEXTLABEL_TITLE_KEY : DEFAULTS, PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_3};
}

- (NSDictionary *)spade {
    return @{TEXTLABEL_TITLE_KEY : SPADE, EXERCISE : self.spadesExerciseString, PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_1, TEXTLABEL_DESCRIPTION_KEY : EXERCISE};
}

- (NSDictionary *)club {
    return @{TEXTLABEL_TITLE_KEY : CLUB, EXERCISE : self.clubsExerciseString, PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_1, TEXTLABEL_DESCRIPTION_KEY : EXERCISE};
}

- (NSDictionary *)heart {
    return @{TEXTLABEL_TITLE_KEY : HEART, EXERCISE : self.heartsExerciseString, PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_1, TEXTLABEL_DESCRIPTION_KEY : EXERCISE};
}

- (NSDictionary *)diamond {
    return @{TEXTLABEL_TITLE_KEY : DIAMOND, EXERCISE : self.diamondsExerciseString, PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_1, TEXTLABEL_DESCRIPTION_KEY : EXERCISE};
}

- (NSDictionary *)jack {
    return @{TEXTLABEL_TITLE_KEY : JACK, REPS : [NSString stringWithFormat:@"%ld", self.jacksReps], PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_1, TEXTLABEL_DESCRIPTION_KEY : REPS};
}

- (NSDictionary *)queen {
    return @{TEXTLABEL_TITLE_KEY : QUEEN, REPS : [NSString stringWithFormat:@"%ld", self.queensReps], PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_1, TEXTLABEL_DESCRIPTION_KEY : REPS};
}

- (NSDictionary *)king {
    return @{TEXTLABEL_TITLE_KEY : KING, REPS : [NSString stringWithFormat:@"%ld", self.kingsReps], PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_1, TEXTLABEL_DESCRIPTION_KEY : REPS};
}

- (NSDictionary *)ace {
    return @{TEXTLABEL_TITLE_KEY : ACE, EXERCISE : self.acesExerciseString, REPS : [NSString stringWithFormat:@"%ld", self.acesReps], PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_1, TEXTLABEL_DESCRIPTION_KEY : [NSString stringWithFormat:@"%@ and %@", EXERCISE, REPS], PROTOTYPE_CELL_1_BOOL_KEY : [NSNumber numberWithBool:self.aceExerciseAndRepsLabel], CARD_LABEL : [self labelForKey:ACE]};
}

- (NSDictionary *)joker {
    return @{TEXTLABEL_TITLE_KEY : JOKER, EXERCISE : self.jokersExerciseString, REPS : [NSString stringWithFormat:@"%ld", self.jokersReps], PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_1, TEXTLABEL_DESCRIPTION_KEY : [NSString stringWithFormat:@"%@ and %@", EXERCISE, REPS], PROTOTYPE_CELL_1_BOOL_KEY : [NSNumber numberWithBool:self.jokerExerciseAndRepsLabel], CARD_LABEL : [self labelForKey:JOKER]};
}
  
- (NSDictionary *)jokerOption {
    return @{TEXTLABEL_TITLE_KEY : JOKERS_OPTIONS, PROTOTYPE_CELL_2_BOOL_KEY : [NSNumber numberWithBool:self.jokers], PROTOTYPE_CELL_KEY : PROTOTYPE_CELL_2};
}

#pragma mark - Label

- (NSString *)labelForKey:(NSString *)key {
    if ([key isEqualToString:SPADE]) {
        return [NSString stringWithFormat:@"%@", self.spadesExerciseString];
    } else if ([key isEqualToString:CLUB]) {
        return [NSString stringWithFormat:@"%@", self.clubsExerciseString];
    } else if ([key isEqualToString:HEART]) {
        return [NSString stringWithFormat:@"%@", self.heartsExerciseString];
    } else if ([key isEqualToString:DIAMOND]) {
        return [NSString stringWithFormat:@"%@", self.diamondsExerciseString];
    } else if ([key isEqualToString:JACK]) {
        return [NSString stringWithFormat:@"%ld", self.jacksReps];
    } else if ([key isEqualToString:QUEEN]) {
        return [NSString stringWithFormat:@"%ld", self.queensReps];
    } else if ([key isEqualToString:KING]) {
        return [NSString stringWithFormat:@"%ld", self.kingsReps];
    } else if ([key isEqualToString:ACE]) {
        if (self.aceExerciseAndRepsLabel) {
            return [NSString stringWithFormat:@"%ld %@", self.acesReps, self.acesExerciseString];
        } else {
            return [NSString stringWithFormat:@"%@", self.acesExerciseString];
        }
    } else if ([key isEqualToString:JOKER]) {
        if (self.jokerExerciseAndRepsLabel) {
            return [NSString stringWithFormat:@"%ld %@", self.jokersReps, self.jokersExerciseString];
        } else {
           return [NSString stringWithFormat:@"%@", self.jokersExerciseString]; 
        }
    } else {
        return @"Error no string for label";
    }
}

- (NSString *)labelForPlayingCard:(PlayingCard *)playingCard {
    NSString *rankKey = [self keyForRank:playingCard.rank];
    NSString *suitKey = [self keyForSuit:playingCard.suit];
    
    if (playingCard.rank < 2 || playingCard.rank > 13) {
        return [self labelForKey:rankKey];
    } else if (playingCard.rank <= 10) {
        return [NSString stringWithFormat:@"%ld %@", playingCard.rank, [self labelForKey:suitKey]];
    } else {
        return [NSString stringWithFormat:@"%@ %@", [self labelForKey:rankKey], [self labelForKey:suitKey]];
    }
}

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
        return @"";
    }
}

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

#pragma mark - Exercises Properties

- (NSString *)spadesExerciseString { //Returns exercise for spades or a default value.
    return [self valueForKey:SPADES_EXCERCISE_KEY withDefaultString:@"Push-Ups"];
}

- (NSString *)clubsExerciseString { //Returns exercise for clubs or a default value.
    return [self valueForKey:CLUBS_EXCERCISE_KEY withDefaultString:@"Sit-Ups"];
}

- (NSString *)heartsExerciseString { //Returns exercise for hearts or a default value.
    return [self valueForKey:HEARTS_EXCERCISE_KEY withDefaultString:@"Lunges"];
}

- (NSString *)diamondsExerciseString { //Returns exercise for diamonds or a default value.
    return [self valueForKey:DIAMONDS_EXCERCISE_KEY withDefaultString:@"Squats"];
}

- (NSString *)acesExerciseString { //Returns exercise for aces or a default value.
    return [self valueForKey:ACES_EXERCISE_KEY withDefaultString:@"Jump Rope"];
}

- (NSString *)jokersExerciseString { //Returns exercise for jokers or a default value.
    return [self valueForKey:JOKERS_EXERCISE_KEY withDefaultString:@"10 Of Each"];
}

- (void)setSpadesExerciseString:(NSString *)spadesExerciseString { //Sets exercise for spades in NSUserdefaults.
    [self setStringValue:spadesExerciseString forKey:SPADES_EXCERCISE_KEY];
}

- (void)setClubsExerciseString:(NSString *)cloversExerciseString { //Sets exercise for clubs in NSUserdefaults.
    [self setStringValue:cloversExerciseString forKey:CLUBS_EXCERCISE_KEY];
}

- (void)setHeartsExerciseString:(NSString *)heartsExerciseString { //Sets exercise for hearts in NSUserdefaults.
    [self setStringValue:heartsExerciseString forKey:HEARTS_EXCERCISE_KEY];
}

- (void)setDiamondsExerciseString:(NSString *)diamondsExerciseString { //Sets exercise for diamonds in NSUserdefaults.
    [self setStringValue:diamondsExerciseString forKey:DIAMONDS_EXCERCISE_KEY];
}

- (void)setAcesExerciseString:(NSString *)acesExerciseString { //Sets exercise for aces in NSUserdefaults.
    [self setStringValue:acesExerciseString forKey:ACES_EXERCISE_KEY];
}

- (void)setJokersExerciseString:(NSString *)jokersExerciseString { //Sets exercise for jokers in NSUserdefaults.
    [self setStringValue:jokersExerciseString forKey:JOKERS_EXERCISE_KEY];
}

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

#pragma mark - Reps Properties

- (NSUInteger)jacksReps { //Returns integer value for jacks reps or default value.
    return [self valueForKey:JACKS_REPS_KEY withDefaultValue:12];
}

- (NSUInteger)queensReps { //Returns integer value for queens reps or default value.
    return [self valueForKey:QUEENS_REPS_KEY withDefaultValue:15];
}

- (NSUInteger)kingsReps { //Returns integer value for kings reps or default value.
    return [self valueForKey:KINGS_REPS_KEY withDefaultValue:20];
}

- (NSUInteger)acesReps { //Returns integer value for aces reps or default value.
    return [self valueForKey:ACES_REPS_KEY withDefaultValue:25];
}

- (NSUInteger)jokersReps { //Returns integer value for jokers reps or default value.
    return [self valueForKey:JOKERS_REPS_KEY withDefaultValue:50];
}

- (void)setJacksReps:(NSUInteger)jacksReps { //Sets inteber value for jacks reps in NSUserdefaults.
    [self setNSUIntegerValue:jacksReps forKey:JACKS_REPS_KEY];
}

- (void)setQueensReps:(NSUInteger)queensReps { //Sets inteber value for queens reps in NSUserdefaults.
    [self setNSUIntegerValue:queensReps forKey:QUEENS_REPS_KEY];
}

- (void)setKingsReps:(NSUInteger)kingsReps { //Sets inteber value for kings reps in NSUserdefaults.
    [self setNSUIntegerValue:kingsReps forKey:KINGS_REPS_KEY];
}

- (void)setAcesReps:(NSUInteger)acesReps { //Sets inteber value for aces reps in NSUserdefaults.
    [self setNSUIntegerValue:acesReps forKey:ACES_REPS_KEY];
}

- (void)setJokersReps:(NSUInteger)jokersReps { //Sets inteber value for jokers reps in NSUserdefaults.
    [self setNSUIntegerValue:jokersReps forKey:JOKERS_REPS_KEY];
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

#pragma mark = Boolean Properties

- (BOOL)jokers { //Returns a boolean value for whether or not a game should have jokers used.
    NSUInteger number = [self valueForKey:JOKERS_BOOLEAN_KEY withDefaultValue:[[NSNumber numberWithBool:YES] integerValue]];
    return [[NSNumber numberWithInteger:number] boolValue];
}

- (void)setJokers:(BOOL)jokers { //Sets a boolean value for whether or not a game should have jokers in NSUserdefaults.
    NSNumber *number = [NSNumber numberWithBool:jokers];
    [self setNSUIntegerValue:[number integerValue] forKey:JOKERS_BOOLEAN_KEY];
}

- (BOOL)aceExerciseAndRepsLabel { //Returns a boolean value for whether or not a game should have jokers used.
    NSUInteger number = [self valueForKey:ACE_EXERCISE_AND_REPS_LABEL withDefaultValue:[[NSNumber numberWithBool:YES] integerValue]];
    return [[NSNumber numberWithInteger:number] boolValue];
}

- (void)setAceExerciseAndRepsLabel:(BOOL)aceExerciseAndRepsLabel { //Sets a boolean value for whether or not a game should have jokers in NSUserdefaults.
    NSNumber *number = [NSNumber numberWithBool:aceExerciseAndRepsLabel];
    [self setNSUIntegerValue:[number integerValue] forKey:ACE_EXERCISE_AND_REPS_LABEL];
}

- (BOOL)jokerExerciseAndRepsLabel { //Returns a boolean value for whether or not a game should have jokers used.
    NSUInteger number = [self valueForKey:JOKER_EXERCISE_AND_REPS_LABEL withDefaultValue:[[NSNumber numberWithBool:NO] integerValue]];
    return [[NSNumber numberWithInteger:number] boolValue];
}

- (void)setJokerExerciseAndRepsLabel:(BOOL)jokerExerciseAndRepsLabel { //Sets a boolean value for whether or not a game should have jokers in NSUserdefaults.
    NSNumber *number = [NSNumber numberWithBool:jokerExerciseAndRepsLabel];
    [self setNSUIntegerValue:[number integerValue] forKey:JOKER_EXERCISE_AND_REPS_LABEL];
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
    return @{TWENTY_CARDS : @20, TWENTY_FIVE_CARDS : @25, THIRTY_CARDS : @30, THIRTY_FIVE_CARDS : @35, FORTY_CARDS : @40, FORTY_FIVE_CARDS : @45, ONE_DECK : @54, TWO_DECKS : @108, THREE_DECKS : @162, FOUR_DECKS : @216, SIX_DECKS : @324, EIGHT_DECKS : @432, TEN_DECKS : @540};
}

- (void)resetDefaults {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
