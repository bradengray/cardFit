//
//  PlayingCardSettings.m
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettings.h"

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

//Keys for jokers options and defualts section
#define JOKERS_OPTIONS @"Play With Jokers"
#define DEFAULTS @"Restore Defaults"

//Keys for exercises
#define EXERCISE @"Exercise"
#define SPADES_EXCERCISE_KEY @"Spades Exercise Key"
#define CLUBS_EXCERCISE_KEY @"Clubs Exercies Key"
#define HEARTS_EXCERCISE_KEY @"Hearts Exercise Key"
#define DIAMONDS_EXCERCISE_KEY @"Diamonds Exercies Key"
#define JACKS_EXERCISE_KEY @"Jacks Exercise Key"
#define QUEENS_EXERCISE_KEY @"Queens Exercise Key"
#define KINGS_EXERCISE_KEY @"Kings Exercise Key"
#define ACES_EXERCISE_KEY @"Aces Exercise Key"
#define JOKERS_EXERCISE_KEY @"Jokers Exercise Key"

////Keys for reps.
//#define REPS @"Reps"
//#define JACKS_REPS_KEY @"Jacks Reps Key"
//#define QUEENS_REPS_KEY @"Queens Reps Key"
//#define KINGS_REPS_KEY @"Kings Reps Key"
//#define ACES_REPS_KEY @"Aces Reps Key"
//#define JOKERS_REPS_KEY @"Jokers Reps Key"

//Keys for points.
#define POINTS @"Points"
#define JACKS_POINTS_KEY @"Jacks Points Key"
#define QUEENS_POINTS_KEY @"Queen Points Key"
#define KINGS_POINTS_KEY @"King Points Key"
#define ACES_POINTS_KEY @"Aces Points Key"
#define JOKERS_POINTS_KEY @"Jokers Points Key"

//Keys for OnePlayer, MultiPlayer number of cards and Jokers boolean value.
#define JOKERS_BOOLEAN_KEY @"Jokers Boolean Key"

@implementation PlayingCardSettings

//Creates a shared instance of PlayingCardSettings
+ (instancetype)sharedPlayingCardSettings {
    static PlayingCardSettings *sharedPlayingCardSettings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlayingCardSettings = [[PlayingCardSettings alloc] init];
        sharedPlayingCardSettings.save = YES;
    });
    return sharedPlayingCardSettings;
}

//Used by NSCoder to encode this object using NSKeyedArchiver
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeBool:!self.save forKey:@"Save"];
    [aCoder encodeObject:self.spadesExerciseString forKey:SPADES_EXCERCISE_KEY];
    [aCoder encodeObject:self.clubsExerciseString forKey:CLUBS_EXCERCISE_KEY];
    [aCoder encodeObject:self.heartsExerciseString forKey:HEARTS_EXCERCISE_KEY];
    [aCoder encodeObject:self.diamondsExerciseString forKey:DIAMONDS_EXCERCISE_KEY];
    [aCoder encodeObject:self.jacksExerciseString forKey:JACKS_EXERCISE_KEY];
    [aCoder encodeObject:self.queensExerciseString forKey:QUEENS_EXERCISE_KEY];
    [aCoder encodeObject:self.kingsExerciseString forKey:KINGS_EXERCISE_KEY];
    [aCoder encodeObject:self.acesExerciseString forKey:ACES_EXERCISE_KEY];
    [aCoder encodeObject:self.jokersExerciseString forKey:JOKERS_EXERCISE_KEY];
    
//    [aCoder encodeInteger:self.jacksReps forKey:JACKS_REPS_KEY];
//    [aCoder encodeInteger:self.queensReps forKey:QUEENS_REPS_KEY];
//    [aCoder encodeInteger:self.kingsReps forKey:KINGS_REPS_KEY];
//    [aCoder encodeInteger:self.acesReps forKey:ACES_REPS_KEY];
//    [aCoder encodeInteger:self.jokersReps forKey:JOKERS_REPS_KEY];
    
    [aCoder encodeInteger:self.jacksPoints forKey:JACKS_POINTS_KEY];
    [aCoder encodeInteger:self.queensPoints forKey:QUEENS_POINTS_KEY];
    [aCoder encodeInteger:self.kingsPoints forKey:KINGS_POINTS_KEY];
    [aCoder encodeInteger:self.acesPoints forKey:ACES_POINTS_KEY];
    [aCoder encodeInteger:self.jokersPoints forKey:JOKERS_POINTS_KEY];
}

//Used by NSCoder to decode this object using NSKeyedUnarchiver. It is important to note here that this object is decoded as the shared playing card settings and will not create a new object.
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    PlayingCardSettings *settings = [PlayingCardSettings sharedPlayingCardSettings];
    
    settings.save = [aDecoder decodeBoolForKey:@"Save"];
    settings.spadesExerciseString = [aDecoder decodeObjectForKey:SPADES_EXCERCISE_KEY];
    settings.clubsExerciseString = [aDecoder decodeObjectForKey:CLUBS_EXCERCISE_KEY];
    settings.heartsExerciseString = [aDecoder decodeObjectForKey:HEARTS_EXCERCISE_KEY];
    settings.diamondsExerciseString = [aDecoder decodeObjectForKey:DIAMONDS_EXCERCISE_KEY];
    settings.jacksExerciseString = [aDecoder decodeObjectForKey:JACKS_EXERCISE_KEY];
    settings.queensExerciseString = [aDecoder decodeObjectForKey:QUEENS_EXERCISE_KEY];
    settings.kingsExerciseString = [aDecoder decodeObjectForKey:KINGS_EXERCISE_KEY];
    settings.acesExerciseString = [aDecoder decodeObjectForKey:ACES_EXERCISE_KEY];
    settings.jokersExerciseString = [aDecoder decodeObjectForKey:JOKERS_EXERCISE_KEY];
    
//    settings.jacksReps = [aDecoder decodeIntegerForKey:JACKS_REPS_KEY];
//    settings.queensReps = [aDecoder decodeIntegerForKey:QUEENS_REPS_KEY];
//    settings.kingsReps = [aDecoder decodeIntegerForKey:KINGS_REPS_KEY];
//    settings.acesReps = [aDecoder decodeIntegerForKey:ACES_REPS_KEY];
//    settings.jokersReps = [aDecoder decodeIntegerForKey:JOKERS_REPS_KEY];
    
    settings.jacksPoints = [aDecoder decodeIntegerForKey:JACKS_POINTS_KEY];
    settings.queensPoints = [aDecoder decodeIntegerForKey:QUEENS_POINTS_KEY];
    settings.kingsPoints = [aDecoder decodeIntegerForKey:KINGS_POINTS_KEY];
    settings.acesPoints = [aDecoder decodeIntegerForKey:ACES_POINTS_KEY];
    settings.jokersPoints = [aDecoder decodeIntegerForKey:JOKERS_POINTS_KEY];
    
    return settings;
}

#pragma mark - Settings

//Data holds an array of sections
- (NSArray *)data {
    return @[[self defaults], [self options], [self suits], [self cards]];
}

//Sections array holds the names of the sections
- (NSArray *)sectionsArray {
    return @[@"Defaults", @"Options", @"Suits", @"Cards"];
}

#warning TOOK OUT REPS
//Values hold the dictionary keys that should be shown as settings cells
- (NSArray *)values {
    return @[POINTS, EXERCISE, CELL_BOOL_KEY, CARD_LABEL];
}

#warning TOOK OUT REPS
//Numbers hold the dictionary keys for data that should be considred values
- (NSArray *)numbers {
    return @[POINTS];
}

#pragma mark - Section Arrays

//Array holding dictionaries for the different suits;
- (NSArray *)suits {
    return @[[self spade], [self club], [self heart], [self diamond]];
}

//Array holding dictionaries for the different cards. If there are not jokers it will not show this in the data.
- (NSArray *)cards {
    if (self.jokers) {
        return @[[self jack], [self queen], [self king], [self ace], [self joker]];
    } else {
        return @[[self jack], [self queen], [self king], [self ace]];
    }
}

//Array holding dictionaries for cells as buttons
- (NSArray *)defaults {
    return @[[self defaultButtons]];
}

//Array holding dictionaries for cells with switches
- (NSArray *)options {
    return @[[self jokerOption]];
}

#pragma mark - Row Dictionaries

//Dictionary for our default button
- (NSDictionary *)defaultButtons {
    return @{TEXTLABEL_TITLE_KEY : DEFAULTS, CELL_KEY : CELL_3};
}

//Dictionary for our spade suit
- (NSDictionary *)spade {
    return @{TEXTLABEL_TITLE_KEY : SPADE, EXERCISE : self.spadesExerciseString, CELL_KEY : CELL_1, TEXTLABEL_DESCRIPTION_KEY : EXERCISE};
}

//Dictionary for our club suit
- (NSDictionary *)club {
    return @{TEXTLABEL_TITLE_KEY : CLUB, EXERCISE : self.clubsExerciseString, CELL_KEY : CELL_1, TEXTLABEL_DESCRIPTION_KEY : EXERCISE};
}

//Dictionary for our heart suit
- (NSDictionary *)heart {
    return @{TEXTLABEL_TITLE_KEY : HEART, EXERCISE : self.heartsExerciseString, CELL_KEY : CELL_1, TEXTLABEL_DESCRIPTION_KEY : EXERCISE};
}

//Dictionary for our diamond suit
- (NSDictionary *)diamond {
    return @{TEXTLABEL_TITLE_KEY : DIAMOND, EXERCISE : self.diamondsExerciseString, CELL_KEY : CELL_1, TEXTLABEL_DESCRIPTION_KEY : EXERCISE};
}

#warning TOOK OUT REPS FROM ALL 5   AND CARD_LABEL
//Dictionary for our jack card
- (NSDictionary *)jack {
    return @{TEXTLABEL_TITLE_KEY : JACK, POINTS : [NSString stringWithFormat:@"%ld", self.jacksPoints], EXERCISE : self.jacksExerciseString, CELL_KEY : CELL_1, TEXTLABEL_DESCRIPTION_KEY : [NSString stringWithFormat:@"%@ and %@", EXERCISE, POINTS]};
}

//Dictionary for our queen card
- (NSDictionary *)queen {
    return @{TEXTLABEL_TITLE_KEY : QUEEN, POINTS : [NSString stringWithFormat:@"%ld", self.queensPoints], EXERCISE : self.queensExerciseString, CELL_KEY : CELL_1, TEXTLABEL_DESCRIPTION_KEY : [NSString stringWithFormat:@"%@ and %@", EXERCISE, POINTS]};
}

//Dictionary for our king card
- (NSDictionary *)king {
    return @{TEXTLABEL_TITLE_KEY : KING, POINTS : [NSString stringWithFormat:@"%ld", self.kingsPoints], EXERCISE : self.kingsExerciseString, CELL_KEY : CELL_1, TEXTLABEL_DESCRIPTION_KEY : [NSString stringWithFormat:@"%@ and %@", EXERCISE, POINTS]};
}

//Dictionary for our ace card
- (NSDictionary *)ace {
    return @{TEXTLABEL_TITLE_KEY : ACE, EXERCISE : self.acesExerciseString, POINTS : [NSString stringWithFormat:@"%ld", self.acesPoints], CELL_KEY : CELL_1, TEXTLABEL_DESCRIPTION_KEY : [NSString stringWithFormat:@"%@ and %@", EXERCISE, POINTS]};
}

//Dictionary for our joker card
- (NSDictionary *)joker {
    return @{TEXTLABEL_TITLE_KEY : JOKER, EXERCISE : self.jokersExerciseString, POINTS : [NSString stringWithFormat:@"%ld", self.jokersPoints], CELL_KEY : CELL_1, TEXTLABEL_DESCRIPTION_KEY : [NSString stringWithFormat:@"%@ and %@", EXERCISE, POINTS]};
}

//Dictionary for our cell containing switch giving option of whether our cards will have jokers or not
- (NSDictionary *)jokerOption {
    return @{TEXTLABEL_TITLE_KEY : JOKERS_OPTIONS, CELL_BOOL_KEY : [NSNumber numberWithBool:self.jokers], CELL_KEY : CELL_2};
}

#pragma mark Abstract Methods

//Stores the settings for a data dictionary
- (void)storeNewSettings:(NSDictionary *)settings { //Abstract
    NSString *title = [settings objectForKey:TEXTLABEL_TITLE_KEY];
    NSString *exercise = [settings objectForKey:EXERCISE];
//    NSUInteger reps = [(NSString *)[settings objectForKey:REPS] integerValue];
    NSUInteger points = [(NSString *) [settings objectForKey:POINTS] integerValue];

    if ([title isEqualToString:SPADE]) {
        self.spadesExerciseString = exercise;
    } else if ([title isEqualToString:CLUB]) {
        self.clubsExerciseString = exercise;
    } else if ([title isEqualToString:HEART]) {
        self.heartsExerciseString = exercise;
    } else if ([title isEqualToString:DIAMOND]) {
        self.diamondsExerciseString = exercise;
    } else if ([title isEqualToString:JACK]) {
//        self.jacksReps = reps;
        self.jacksExerciseString = exercise;
        self.jacksPoints = points;
    } else if ([title isEqualToString:QUEEN]) {
//        self.queensReps = reps;
        self.queensExerciseString = exercise;
        self.queensPoints = points;
    } else if ([title isEqualToString:KING]) {
//        self.kingsReps = reps;
        self.kingsExerciseString = exercise;
        self.kingsPoints = points;
    } else if ([title isEqualToString:ACE]) {
        self.acesExerciseString = exercise;
//        self.acesReps = reps;
        self.acesPoints = points;
    } else if ([title isEqualToString:JOKER]) {
        self.jokersExerciseString = exercise;
//        self.jokersReps = reps;
        self.jokersPoints = points;
    } else {
        NSLog(@"Error No Setting");
    }
}

//Communicates whether a switch has been changed or not
- (void)switchChanged:(BOOL)on { //Abstract
    self.jokers = on;
}

#define DEFAULT @"Default"

//Returns a label for a given suit and rank
- (NSString *)labelForSuit:(NSUInteger)suit andRank:(NSUInteger)rank { //Abstract
    NSString *rankKey = [self keyForRank:rank];
    NSString *suitKey = [self keyForSuit:suit];
    
    if (rank < 2 || rank > 10) {
        if (![[self labelForKey:rankKey] isEqualToString:DEFAULT]) {
            return [NSString stringWithFormat:@"%@ %@", [self labelForKey:rankKey], [self labelForKey:suitKey]];
        } else {
            return [self labelForKey:rankKey];
        }
    } else {
        return [NSString stringWithFormat:@"%ld %@", rank, [self labelForKey:suitKey]];
    }
}

#define MAX_NUMBER_VALUE 1000
#define MINIMUM_STRING_LENGTH 15

//Returns an alert string for a given dictionary key
- (NSString *)alertLabelForString:(NSString *)string forKey:(NSString *)key { //Abstract
    if ([string isEqualToString:@""]) {
//        if ([key isEqualToString:REPS]) {
//            return nil;
//        } else {
            return @"Entry Required";
//        }
    } else {
        if ([self.numbers containsObject:key]) {
            if ([string integerValue] >= MAX_NUMBER_VALUE) {
                return [NSString stringWithFormat:@"Value Must Be Less Than %d", MAX_NUMBER_VALUE];
            } else if ([string integerValue] < 0) {
                if ([string integerValue] == 0) {
                    if ([key isEqualToString:POINTS]) {
                        return @"Reps Must be Greater Than 0";
                    } else {
                        return nil;
                    }
                } else {
                    return @"Reps Must be Greater Than 0";
                }
            } else {
                return nil;
            }
        } else {
            if ([string length] > MINIMUM_STRING_LENGTH) {
                return [NSString stringWithFormat:@"Exercise Must Contain Less Than %d Characters", MINIMUM_STRING_LENGTH];
            } else {
                return nil;
            }
        }
    }
}

#pragma mark Labels

//Returns a card label for a given dictionary key
- (NSString *)labelForKey:(NSString *)key {
    if ([key isEqualToString:SPADE]) {
        return self.spadesExerciseString;
    } else if ([key isEqualToString:CLUB]) {
        return self.clubsExerciseString;
    } else if ([key isEqualToString:HEART]) {
        return self.heartsExerciseString;
    } else if ([key isEqualToString:DIAMOND]) {
        return self.diamondsExerciseString;
    } else if ([key isEqualToString:JACK]) {
        if ([self.jacksExerciseString isEqualToString:DEFAULT]) {
            return [NSString stringWithFormat:@"%ld", self.jacksPoints];
        } else {
            return self.jacksExerciseString;
        }
    } else if ([key isEqualToString:QUEEN]) {
        if ([self.queensExerciseString isEqualToString:DEFAULT]) {
            return [NSString stringWithFormat:@"%ld", self.queensPoints];
        } else {
            return self.queensExerciseString;
        }
    } else if ([key isEqualToString:KING]) {
        if ([self.kingsExerciseString isEqualToString:DEFAULT]) {
            return [NSString stringWithFormat:@"%ld", self.kingsPoints];
        } else {
            return self.kingsExerciseString;
        }
    } else if ([key isEqualToString:ACE]) {
        return self.acesExerciseString;
    } else if ([key isEqualToString:JOKER]) {
        return self.jokersExerciseString;
    } else {
        return @"Error no string for label";
    }
}

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
        return @"";
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

#pragma mark - Exercises Properties

//Setters and Getters written for all exercies properties
@synthesize spadesExerciseString = _spadesExerciseString;
@synthesize clubsExerciseString = _clubsExerciseString;
@synthesize heartsExerciseString = _heartsExerciseString;
@synthesize diamondsExerciseString = _diamondsExerciseString;
@synthesize jacksExerciseString = _jacksExerciseString;
@synthesize queensExerciseString = _queensExerciseString;
@synthesize kingsExerciseString = _kingsExerciseString;
@synthesize acesExerciseString = _acesExerciseString;
@synthesize jokersExerciseString = _jokersExerciseString;

- (NSString *)spadesExerciseString { //Returns exercise for spades or a default value.
    if (self.save) {
        return [self valueForKey:SPADES_EXCERCISE_KEY withDefaultString:@"Push-Ups"];
    } else {
        return _spadesExerciseString ? _spadesExerciseString : @"?";
    }
}

- (NSString *)clubsExerciseString { //Returns exercise for clubs or a default value.
    if (self.save) {
        return [self valueForKey:CLUBS_EXCERCISE_KEY withDefaultString:@"Sit-Ups"];
    } else {
        return _clubsExerciseString ? _clubsExerciseString : @"?";
    }
}

- (NSString *)heartsExerciseString { //Returns exercise for hearts or a default value.
    if (self.save) {
        return [self valueForKey:HEARTS_EXCERCISE_KEY withDefaultString:@"Lunges"];
    } else {
        return _heartsExerciseString ? _heartsExerciseString : @"?";
    }
}

- (NSString *)diamondsExerciseString { //Returns exercise for diamonds or a default value.
    if (self.save) {
        return [self valueForKey:DIAMONDS_EXCERCISE_KEY withDefaultString:@"Squats"];
    } else {
        return _diamondsExerciseString ? _diamondsExerciseString : @"?";
    }
}

- (NSString *)jacksExerciseString { //Returns exercise for aces or a default value.
    if (self.save) {
        return [self valueForKey:JACKS_EXERCISE_KEY withDefaultString:DEFAULT];
    } else {
        return _jacksExerciseString ? _jacksExerciseString : @"?";
    }
}

- (NSString *)queensExerciseString { //Returns exercise for aces or a default value.
    if (self.save) {
        return [self valueForKey:QUEENS_EXERCISE_KEY withDefaultString:DEFAULT];
    } else {
        return _queensExerciseString ? _queensExerciseString : @"?";
    }
}

- (NSString *)kingsExerciseString { //Returns exercise for aces or a default value.
    if (self.save) {
        return [self valueForKey:KINGS_EXERCISE_KEY withDefaultString:DEFAULT];
    } else {
        return _kingsExerciseString ? _kingsExerciseString : @"?";
    }
}

- (NSString *)acesExerciseString { //Returns exercise for aces or a default value.
    if (self.save) {
        return [self valueForKey:ACES_EXERCISE_KEY withDefaultString:@"25 Jump Rope"];
    } else {
        return _acesExerciseString ? _acesExerciseString : @"?";
    }
}

- (NSString *)jokersExerciseString { //Returns exercise for jokers or a default value.
    if (self.save) {
        return [self valueForKey:JOKERS_EXERCISE_KEY withDefaultString:@"10 Of Each"];
    } else {
        return _jokersExerciseString ? _jokersExerciseString : @"?";
    }
}

- (void)setSpadesExerciseString:(NSString *)spadesExerciseString { //Sets exercise for spades in NSUserdefaults.
    if (self.save) {
        [self setStringValue:spadesExerciseString forKey:SPADES_EXCERCISE_KEY];
    } else {
        _spadesExerciseString = spadesExerciseString;
    }
}

- (void)setClubsExerciseString:(NSString *)clubsExerciseString { //Sets exercise for clubs in NSUserdefaults.
    if (self.save) {
        [self setStringValue:clubsExerciseString forKey:CLUBS_EXCERCISE_KEY];
    } else {
        _clubsExerciseString = clubsExerciseString;
    }
}

- (void)setHeartsExerciseString:(NSString *)heartsExerciseString { //Sets exercise for hearts in NSUserdefaults.
    if (self.save) {
        [self setStringValue:heartsExerciseString forKey:HEARTS_EXCERCISE_KEY];
    } else {
        _heartsExerciseString = heartsExerciseString;
    }
}

- (void)setDiamondsExerciseString:(NSString *)diamondsExerciseString { //Sets exercise for diamonds in NSUserdefaults.
    if (self.save) {
        [self setStringValue:diamondsExerciseString forKey:DIAMONDS_EXCERCISE_KEY];
    } else {
        _diamondsExerciseString = diamondsExerciseString;
    }
}

- (void)setJacksExerciseString:(NSString *)jacksExerciseString { //Sets exercise for aces in NSUserdefaults.
    if (self.save) {
        [self setStringValue:jacksExerciseString forKey:JACKS_EXERCISE_KEY];
    } else {
        _jacksExerciseString = jacksExerciseString;
    }
}

- (void)setQueensExerciseString:(NSString *)queensExerciseString { //Sets exercise for aces in NSUserdefaults.
    if (self.save) {
        [self setStringValue:queensExerciseString forKey:QUEENS_EXERCISE_KEY];
    } else {
        _queensExerciseString = queensExerciseString;
    }
}

- (void)setKingsExerciseString:(NSString *)kingsExerciseString { //Sets exercise for aces in NSUserdefaults.
    if (self.save) {
        [self setStringValue:kingsExerciseString forKey:KINGS_EXERCISE_KEY];
    } else {
        _kingsExerciseString = kingsExerciseString;
    }
}

- (void)setAcesExerciseString:(NSString *)acesExerciseString { //Sets exercise for aces in NSUserdefaults.
    if (self.save) {
        [self setStringValue:acesExerciseString forKey:ACES_EXERCISE_KEY];
    } else {
        _acesExerciseString = acesExerciseString;
    }
}

- (void)setJokersExerciseString:(NSString *)jokersExerciseString { //Sets exercise for jokers in NSUserdefaults.
    if (self.save) {
        [self setStringValue:jokersExerciseString forKey:JOKERS_EXERCISE_KEY];
    } else {
        _jokersExerciseString = jokersExerciseString;
    }
}

//#pragma mark - Reps Properties
//
////Setters and Getters written for all reps properties
//@synthesize jacksReps = _jacksReps;
//@synthesize queensReps = _queensReps;
//@synthesize kingsReps = _kingsReps;
//@synthesize acesReps = _acesReps;
//@synthesize jokersReps = _jokersReps;
//
//- (NSUInteger)jacksReps { //Returns integer value for jacks reps or default value.
//    if (self.save) {
//        return [self valueForKey:JACKS_REPS_KEY withDefaultValue:12];
//    } else {
//        return _jacksReps;
//    }
//}
//
//- (NSUInteger)queensReps { //Returns integer value for queens reps or default value.
//    if (self.save) {
//        return [self valueForKey:QUEENS_REPS_KEY withDefaultValue:15];
//    } else {
//        return _queensReps;
//    }
//}
//
//- (NSUInteger)kingsReps { //Returns integer value for kings reps or default value.
//    if (self.save) {
//        return [self valueForKey:KINGS_REPS_KEY withDefaultValue:20];
//    } else {
//        return _kingsReps;
//    }
//}
//
//- (NSUInteger)acesReps { //Returns integer value for aces reps or default value.
//    if (self.save) {
//        return [self valueForKey:ACES_REPS_KEY withDefaultValue:25];
//    } else {
//        return _acesReps;
//    }
//}
//
//- (NSUInteger)jokersReps { //Returns integer value for jokers reps or default value.
//    if (self.save) {
//        return [self valueForKey:JOKERS_REPS_KEY withDefaultValue:0];
//    } else {
//        return _jokersReps;
//    }
//}
//
//- (void)setJacksReps:(NSUInteger)jacksReps { //Sets integer value for jacks reps in NSUserdefaults.
//    if (self.save) {
//        [self setNSUIntegerValue:jacksReps forKey:JACKS_REPS_KEY];
//    } else {
//        _jacksReps = jacksReps;
//    }
//}
//
//- (void)setQueensReps:(NSUInteger)queensReps { //Sets integer value for queens reps in NSUserdefaults.
//    if (self.save) {
//        [self setNSUIntegerValue:queensReps forKey:QUEENS_REPS_KEY];
//    } else {
//        _queensReps = queensReps;
//    }
//}
//
//- (void)setKingsReps:(NSUInteger)kingsReps { //Sets integer value for kings reps in NSUserdefaults.
//    if (self.save) {
//        [self setNSUIntegerValue:kingsReps forKey:KINGS_REPS_KEY];
//    } else {
//        _kingsReps = kingsReps;
//    }
//}
//
//- (void)setAcesReps:(NSUInteger)acesReps { //Sets integer value for aces reps in NSUserdefaults.
//    if (self.save) {
//        [self setNSUIntegerValue:acesReps forKey:ACES_REPS_KEY];
//    } else {
//        _acesReps = acesReps;
//    }
//}
//
//- (void)setJokersReps:(NSUInteger)jokersReps { //Sets integer value for jokers reps in NSUserdefaults.
//    if (self.save) {
//        [self setNSUIntegerValue:jokersReps forKey:JOKERS_REPS_KEY];
//    } else {
//        _jokersReps = jokersReps;
//    }
//}

#pragma mark - Points Propertins

//Setters and Getters written for all points properties
@synthesize jacksPoints = _jacksPoints;
@synthesize queensPoints = _queensPoints;
@synthesize kingsPoints = _kingsPoints;
@synthesize acesPoints = _acesPoints;
@synthesize jokersPoints = _jokersPoints;

- (NSUInteger)jacksPoints { //Returns integer value for jacks points or default value.
    if (self.save) {
        return [self valueForKey:JACKS_POINTS_KEY withDefaultValue:12];
    } else {
        return _jacksPoints;
    }
}

- (NSUInteger)queensPoints { //Returns integer value for queens points or default value.
    if (self.save) {
        return [self valueForKey:QUEENS_POINTS_KEY withDefaultValue:15];
    } else {
        return _queensPoints;
    }
}

- (NSUInteger)kingsPoints { //Returns integer value for kings points or default value.
    if (self.save) {
        return [self valueForKey:KINGS_POINTS_KEY withDefaultValue:20];
    } else {
        return _kingsPoints;
    }
}

- (NSUInteger)acesPoints { //Returns integer value for aces points or default value.
    if (self.save) {
        return [self valueForKey:ACES_POINTS_KEY withDefaultValue:25];
    } else {
        return _acesPoints;
    }
}

- (NSUInteger)jokersPoints { //Returns integer value for jokers points or default value.
    if (self.save) {
        return [self valueForKey:JOKERS_POINTS_KEY withDefaultValue:50];
    } else {
        return _jokersPoints;
    }
}

- (void)setJacksPoints:(NSUInteger)jacksPoints { //Sets integer value for jacks reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:jacksPoints forKey:JACKS_POINTS_KEY];
    } else {
        _jacksPoints = jacksPoints;
    }
}

- (void)setQueensPoints:(NSUInteger)queensPoints { //Sets integer value for queens reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:queensPoints forKey:QUEENS_POINTS_KEY];
    } else {
        _queensPoints = queensPoints;
    }
}

- (void)setKingsPoints:(NSUInteger)kingsPoints { //Sets integer value for kings reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:kingsPoints forKey:KINGS_POINTS_KEY];
    } else {
        _kingsPoints = kingsPoints;
    }
}

- (void)setAcesPoints:(NSUInteger)acesPoints { //Sets integer value for aces reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:acesPoints forKey:ACES_POINTS_KEY];
    } else {
        _acesPoints = acesPoints;
    }
}

- (void)setJokersPoints:(NSUInteger)jokersPoints { //Sets integer value for jokers reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:jokersPoints forKey:JOKERS_POINTS_KEY];
    } else {
        _jokersPoints = jokersPoints;
    }
}

#pragma mark - Boolean Properties

- (BOOL)jokers { //Returns a boolean value for whether or not a game should have jokers used.
    NSUInteger number = [self valueForKey:JOKERS_BOOLEAN_KEY withDefaultValue:[[NSNumber numberWithBool:YES] integerValue]];
    return [[NSNumber numberWithInteger:number] boolValue];
}

- (void)setJokers:(BOOL)jokers { //Sets a boolean value for whether or not a game should have jokers in NSUserdefaults.
    NSNumber *number = [NSNumber numberWithBool:jokers];
    [self setNSUIntegerValue:[number integerValue] forKey:JOKERS_BOOLEAN_KEY];
}

@end
