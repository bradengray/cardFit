//
//  PlayingCardSettings.m
//  CardFit
//
//  Created by Braden Gray on 9/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettings.h"

@interface PlayingCardSettings ()

//Strings that hold the names of the exercies for the listed suits and ranks.
@property (nonatomic, strong) NSString *spadesExerciseString;
@property (nonatomic, strong) NSString *clubsExerciseString;
@property (nonatomic, strong) NSString *heartsExerciseString;
@property (nonatomic, strong) NSString *diamondsExerciseString;
@property (nonatomic, strong) NSString *acesExerciseString;
@property (nonatomic, strong) NSString *jokersExerciseString;

//Integers that hold the number of points for the listed ranks. All Cards numbered 2-10 have a point value equal to rank.
@property (nonatomic) NSUInteger jacksPoints;
@property (nonatomic) NSUInteger queensPoints;
@property (nonatomic) NSUInteger kingsPoints;
@property (nonatomic) NSUInteger acesPoints;
@property (nonatomic) NSUInteger jokersPoints;

//Stores Jokers Bool
@property (nonatomic) BOOL playWithJokers;

@end

@implementation PlayingCardSettings

#pragma mark - Settings Methods

//Create dictionary of all settings values for NSCoding
- (NSDictionary *)values {
    NSMutableDictionary *settingsValues;
    if ([super values]) {
        settingsValues = [[super values] mutableCopy];
    } else {
        settingsValues = [[NSMutableDictionary alloc] init];
    }
    [settingsValues addEntriesFromDictionary:@{SPADES_EXCERCISE_KEY : self.spadesExerciseString, CLUBS_EXCERCISE_KEY : self.clubsExerciseString, HEARTS_EXCERCISE_KEY : self.heartsExerciseString, DIAMONDS_EXCERCISE_KEY : self.diamondsExerciseString, ACES_EXERCISE_KEY : self.acesExerciseString, JOKERS_EXERCISE_KEY : self.jokersExerciseString, JACKS_POINTS_KEY : [NSNumber numberWithUnsignedInteger:self.jokersPoints], QUEENS_POINTS_KEY : [NSNumber numberWithUnsignedInteger:self.queensPoints], KINGS_POINTS_KEY : [NSNumber numberWithUnsignedInteger:self.kingsPoints], ACES_POINTS_KEY : [NSNumber numberWithUnsignedInteger:self.acesPoints], JACKS_POINTS_KEY : [NSNumber numberWithUnsignedInteger:self.jokersPoints], JOKERS_BOOLEAN_KEY : [NSNumber numberWithBool:self.playWithJokers]}];
    return settingsValues;
}

//Returns Value For Given Key
- (id)getValueForKey:(NSString *)key {
    if ([key isEqualToString:SPADES_EXCERCISE_KEY]) {
        return self.spadesExerciseString;
    } else if ([key isEqualToString:CLUBS_EXCERCISE_KEY]) {
        return self.clubsExerciseString;
    } else if ([key isEqualToString:HEARTS_EXCERCISE_KEY]) {
        return self.heartsExerciseString;
    } else if ([key isEqualToString:DIAMONDS_EXCERCISE_KEY]) {
        return self.diamondsExerciseString;
    } else if ([key isEqualToString:ACES_EXERCISE_KEY]) {
        return self.acesExerciseString;
    } else if ([key isEqualToString:JOKERS_EXERCISE_KEY]) {
        return self.jokersExerciseString;
    } else if ([key isEqualToString:JACKS_POINTS_KEY]) {
        return [NSNumber numberWithUnsignedInteger:self.jacksPoints];
    } else if ([key isEqualToString:QUEENS_POINTS_KEY]) {
        return [NSNumber numberWithUnsignedInteger:self.queensPoints];
    } else if ([key isEqualToString:KINGS_POINTS_KEY]) {
        return [NSNumber numberWithUnsignedInteger:self.kingsPoints];
    } else if ([key isEqualToString:ACES_POINTS_KEY]) {
        return [NSNumber numberWithUnsignedInteger:self.acesPoints];
    } else if ([key isEqualToString:JOKERS_POINTS_KEY]) {
        return [NSNumber numberWithUnsignedInteger:self.jokersPoints];
    } else if ([key isEqualToString:JOKERS_BOOLEAN_KEY]) {
        return [NSNumber numberWithBool:self.playWithJokers];
    } else {
        NSLog(@"Settings Error: no value for key");
        return nil;
    }
}

//Sets value for given key
#warning Consider only taking one data type
- (void)setSettingsValue:(id)value forKey:(NSString *)key { //Abstract
    if ([value isKindOfClass:[NSString class]]) {
        if ([key isEqualToString:SPADES_EXCERCISE_KEY]) {
            self.spadesExerciseString = (NSString *)value;
        } else if ([key isEqualToString:CLUBS_EXCERCISE_KEY]) {
            self.clubsExerciseString = (NSString *)value;
        } else if ([key isEqualToString:HEARTS_EXCERCISE_KEY]) {
            self.heartsExerciseString = (NSString *)value;
        } else if ([key isEqualToString:DIAMONDS_EXCERCISE_KEY]) {
            self.diamondsExerciseString = (NSString *)value;
        } else if ([key isEqualToString:ACES_EXERCISE_KEY]) {
            self.acesExerciseString = (NSString *)value;
        } else if ([key isEqualToString:JOKERS_EXERCISE_KEY]) {
            self.jokersExerciseString = (NSString *)value;
        } else if ([key isEqualToString:JACKS_POINTS_KEY]) {
            self.jacksPoints = [(NSString *)value integerValue];
        } else if ([key isEqualToString:QUEENS_POINTS_KEY]) {
            self.queensPoints = [(NSString *)value integerValue];
        } else if ([key isEqualToString:KINGS_POINTS_KEY]) {
            self.kingsPoints = [(NSString *)value integerValue];
        } else if ([key isEqualToString:ACES_POINTS_KEY]) {
            self.acesPoints = [(NSString *)value integerValue];
        } else if ([key isEqualToString:JOKERS_POINTS_KEY]) {
            self.jokersPoints = [(NSString *)value integerValue];
        } else if ([key isEqualToString:JOKERS_BOOLEAN_KEY]) {
            self.playWithJokers = (BOOL)[(NSString *)value integerValue];
        } else {
            NSLog(@"Playing Card Settings Error: key did not match known values");
            return;
        }
    } else if ([value isKindOfClass:[NSNumber class]]) {
        if ([key isEqualToString:JACKS_POINTS_KEY]) {
            self.jacksPoints = [(NSNumber *)value unsignedIntegerValue];
        } else if ([key isEqualToString:QUEENS_POINTS_KEY]) {
            self.queensPoints = [(NSNumber *)value unsignedIntegerValue];
        } else if ([key isEqualToString:KINGS_POINTS_KEY]) {
            self.kingsPoints = [(NSNumber *)value unsignedIntegerValue];
        } else if ([key isEqualToString:ACES_POINTS_KEY]) {
            self.acesPoints = [(NSNumber *)value unsignedIntegerValue];
        } else if ([key isEqualToString:JOKERS_POINTS_KEY]) {
            self.jokersPoints = [(NSNumber *)value unsignedIntegerValue];
        } else if ([key isEqualToString:JOKERS_BOOLEAN_KEY]) {
            self.playWithJokers = [(NSNumber *)value boolValue];
        }
    } else {
        NSLog(@"Playing Card Settings Error: unknown type");
        return;
    }
}

#pragma mark - Exercises Properties
//Synthesize properties for setters and getters
@synthesize spadesExerciseString = _spadesExerciseString;
@synthesize clubsExerciseString = _clubsExerciseString;
@synthesize heartsExerciseString = _heartsExerciseString;
@synthesize diamondsExerciseString = _diamondsExerciseString;
@synthesize acesExerciseString = _acesExerciseString;
@synthesize jokersExerciseString = _jokersExerciseString;

- (NSString *)spadesExerciseString { //Returns exercise for spades or a default value.
    if (self.getLocalValue) {
        return _spadesExerciseString ? _spadesExerciseString : @"?";
    } else {
        return [self valueForKey:SPADES_EXCERCISE_KEY withDefaultString:@"PUSH-UPS"];
    }
}

- (NSString *)clubsExerciseString { //Returns exercise for clubs or a default value.
    if (self.getLocalValue) {
        return _clubsExerciseString ? _clubsExerciseString : @"?";
    } else {
        return [self valueForKey:CLUBS_EXCERCISE_KEY withDefaultString:@"SIT-UPS"];
    }
}

- (NSString *)heartsExerciseString { //Returns exercise for hearts or a default value.
    if (self.getLocalValue) {
        return _heartsExerciseString ? _heartsExerciseString : @"?";
    } else {
        return [self valueForKey:HEARTS_EXCERCISE_KEY withDefaultString:@"LUNGES"];
    }
}

- (NSString *)diamondsExerciseString { //Returns exercise for diamonds or a default value.
    if (self.getLocalValue) {
        return _diamondsExerciseString ? _diamondsExerciseString : @"?";
    } else {
        return [self valueForKey:DIAMONDS_EXCERCISE_KEY withDefaultString:@"SQUATS"];
    }
}

- (NSString *)acesExerciseString { //Returns exercise for aces or a default value.
    if (self.getLocalValue) {
        return _acesExerciseString ? _acesExerciseString : @"?";
    } else {
        return [self valueForKey:ACES_EXERCISE_KEY withDefaultString:@"25 JUMP ROPE"];
    }
}

- (NSString *)jokersExerciseString { //Returns exercise for jokers or a default value.
    if (self.getLocalValue) {
        return _jokersExerciseString ? _jokersExerciseString : @"?";
    } else {
        return [self valueForKey:JOKERS_EXERCISE_KEY withDefaultString:@"20 BURPEES"];
    }
}

- (void)setSpadesExerciseString:(NSString *)spadesExerciseString { //Sets exercise for spade
    if (self.getLocalValue) {
        _spadesExerciseString = spadesExerciseString;
    } else {
        [self save:@{SPADES_EXCERCISE_KEY : spadesExerciseString}];
        [self settingChanged];
    }
}

- (void)setClubsExerciseString:(NSString *)clubsExerciseString { //Sets exercise for club
    if (self.getLocalValue) {
        _clubsExerciseString = clubsExerciseString;
    } else {
        [self save:@{CLUBS_EXCERCISE_KEY : clubsExerciseString}];
        [self settingChanged];
    }
}

- (void)setHeartsExerciseString:(NSString *)heartsExerciseString { //Sets exercise for heart
    if (self.getLocalValue) {
        _heartsExerciseString = heartsExerciseString;
    } else {
        [self save:@{HEARTS_EXCERCISE_KEY : heartsExerciseString}];
        [self settingChanged];
    }
}

- (void)setDiamondsExerciseString:(NSString *)diamondsExerciseString { //Sets exercise for diamond
    if (self.getLocalValue) {
        _diamondsExerciseString = diamondsExerciseString;
    } else {
        [self save:@{DIAMONDS_EXCERCISE_KEY : diamondsExerciseString}];
        [self settingChanged];
    }
}

- (void)setAcesExerciseString:(NSString *)acesExerciseString { //Sets exercise for ace
    if (self.getLocalValue) {
        _acesExerciseString = acesExerciseString;
    } else {
        [self save:@{ACES_EXERCISE_KEY : acesExerciseString}];
        [self settingChanged];
    }
}

- (void)setJokersExerciseString:(NSString *)jokersExerciseString { //Sets exercise for joker
    if (self.getLocalValue) {
        _jokersExerciseString = jokersExerciseString;
    } else {
        [self save:@{JOKERS_EXERCISE_KEY : jokersExerciseString}];
        [self settingChanged];
    }
}

#pragma mark - Points Properties
//Synthesize for setters and getters
@synthesize jacksPoints = _jacksPoints;
@synthesize queensPoints = _queensPoints;
@synthesize kingsPoints = _kingsPoints;
@synthesize acesPoints = _acesPoints;
@synthesize jokersPoints = _jokersPoints;

- (NSUInteger)jacksPoints { //Returns integer value for jacks points or default value.
    if (self.getLocalValue) {
        return _jacksPoints ? _jacksPoints : 0;
    } else {
        return [self valueForKey:JACKS_POINTS_KEY withDefaultValue:12];
    }
}

- (NSUInteger)queensPoints { //Returns integer value for queens points or default value.
    if (self.getLocalValue) {
        return _queensPoints ? _queensPoints : 0;
    } else {
        return [self valueForKey:QUEENS_POINTS_KEY withDefaultValue:15];
    }
}

- (NSUInteger)kingsPoints { //Returns integer value for kings points or default value.
    if (self.getLocalValue) {
        return _kingsPoints ? _kingsPoints : 0;
    } else {
        return [self valueForKey:KINGS_POINTS_KEY withDefaultValue:20];
    }
}

- (NSUInteger)acesPoints { //Returns integer value for aces points or default value.
    if (self.getLocalValue) {
        return _acesPoints ? _acesPoints : 0;
    } else {
        return [self valueForKey:ACES_POINTS_KEY withDefaultValue:25];
    }
}

- (NSUInteger)jokersPoints { //Returns integer value for jokers points or default value.
    if (self.getLocalValue) {
        return _jokersPoints ? _jacksPoints : 0;
    } else {
        return [self valueForKey:JOKERS_POINTS_KEY withDefaultValue:50];
    }
}

- (void)setJacksPoints:(NSUInteger)jacksPoints { //Sets points value for jack
    if (self.getLocalValue) {
        _jacksPoints = jacksPoints;
    } else {
        [self save:@{JACKS_POINTS_KEY : [NSNumber numberWithUnsignedInteger:jacksPoints]}];
        [self settingChanged];
    }
}

- (void)setQueensPoints:(NSUInteger)queensPoints { //Sets points value for jack
    if (self.getLocalValue) {
        _queensPoints = queensPoints;
    } else {
        [self save:@{QUEENS_POINTS_KEY : [NSNumber numberWithUnsignedInteger:queensPoints]}];
        [self settingChanged];
    }
}

- (void)setKingsPoints:(NSUInteger)kingsPoints { //Sets points value for jack
    if (self.getLocalValue) {
        _kingsPoints = kingsPoints;
    } else {
        [self save:@{KINGS_POINTS_KEY : [NSNumber numberWithUnsignedInteger:kingsPoints]}];
        [self settingChanged];
    }
}

- (void)setAcesPoints:(NSUInteger)acesPoints { //Sets points value for jack
    if (self.getLocalValue) {
        _acesPoints = acesPoints;
    } else {
        [self save:@{ACES_POINTS_KEY : [NSNumber numberWithUnsignedInteger:acesPoints]}];
        [self settingChanged];
    }
}

- (void)setJokersPoints:(NSUInteger)jokersPoints { //Sets points value for jack
    if (self.getLocalValue) {
        _jokersPoints = jokersPoints;
    } else {
        [self save:@{JOKERS_POINTS_KEY : [NSNumber numberWithUnsignedInteger:jokersPoints]}];
        [self settingChanged];
    }
}

#pragma mark - Boolean Properties

@synthesize playWithJokers = _playWithJokers;

- (BOOL)playWithJokers { //Returns a boolean value for whether or not a game should have jokers used.
    if (self.getLocalValue) {
        return _playWithJokers ? _playWithJokers : 0;
    } else {
        NSUInteger number = [self valueForKey:JOKERS_BOOLEAN_KEY withDefaultValue:[[NSNumber numberWithBool:YES] integerValue]];
        return [[NSNumber numberWithUnsignedInteger:number] boolValue];
    }
}

- (void)setPlayWithJokers:(BOOL)playWithJokers { //Sets boolean value for jokers
    if (self.getLocalValue) {
        _playWithJokers = playWithJokers;
    } else {
        [self save:@{JOKERS_BOOLEAN_KEY : [NSNumber numberWithBool:playWithJokers]}];
        [self settingChanged];
    }
}

@end
