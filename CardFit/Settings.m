//
//  Settings.m
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Settings.h"

#define SETTINGS_DICTIONARY_KEY @"Settings Dictionary Key"
#define SPADES_EXCERCISE_KEY @"Spades Exercise Key"
#define CLUBS_EXCERCISE_KEY @"Clubs Exercise Key"
#define HEARTS_EXCERCISE_KEY @"Hearts Exercise Key"
#define DIAMONDS_EXCERCISE_KEY @"Diamonds Exercise Key"
#define ACES_EXERCISE_KEY @"Aces Exercise Key"
#define JOKERS_EXERCISE_KEY @"Jokers Exercise Key"
#define JACKS_REPS_KEY @"Jacks Reps Key"
#define QUEENS_REPS_KEY @"Queens Reps Key"
#define KINGS_REPS_KEY @"Kings Reps Key"
#define ACES_REPS_KEY @"Aces Reps Key"
#define JOKERS_REPS_KEY @"Jokers Reps Key"

@implementation Settings

- (NSString *)spadesExerciseString {
    return [self valueForKey:SPADES_EXCERCISE_KEY withDefaultString:@"Push-Ups"];
}

- (NSString *)clubsExerciseString {
    return [self valueForKey:CLUBS_EXCERCISE_KEY withDefaultString:@"Sit-Ups"];
}

- (NSString *)heartsExerciseString {
    return [self valueForKey:HEARTS_EXCERCISE_KEY withDefaultString:@"Lunges"];
}

- (NSString *)diamondsExerciseString {
    return [self valueForKey:DIAMONDS_EXCERCISE_KEY withDefaultString:@"Squats"];
}

- (NSString *)acesExerciseString {
    return [self valueForKey:ACES_EXERCISE_KEY withDefaultString:@"Jump Rope"];
}

- (NSString *)jokersExerciseString {
    return [self valueForKey:JOKERS_EXERCISE_KEY withDefaultString:@"10 Of Each"];
}

- (void)setSpadesExerciseString:(NSString *)spadesExerciseString {
    [self setStringValue:spadesExerciseString forKey:SPADES_EXCERCISE_KEY];
}

- (void)setClubsExerciseString:(NSString *)cloversExerciseString {
    [self setStringValue:cloversExerciseString forKey:CLUBS_EXCERCISE_KEY];
}

- (void)setHeartsExerciseString:(NSString *)heartsExerciseString {
    [self setStringValue:heartsExerciseString forKey:HEARTS_EXCERCISE_KEY];
}

- (void)setDiamondsExerciseString:(NSString *)diamondsExerciseString {
    [self setStringValue:diamondsExerciseString forKey:DIAMONDS_EXCERCISE_KEY];
}

- (void)setAcesExerciseString:(NSString *)acesExerciseString {
    [self setStringValue:acesExerciseString forKey:ACES_EXERCISE_KEY];
}

- (void)setJokersExerciseString:(NSString *)jokersExerciseString {
    [self setStringValue:jokersExerciseString forKey:JOKERS_EXERCISE_KEY];
}

- (NSString *)valueForKey:(NSString *)key withDefaultString:(NSString *)defaultString {
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_DICTIONARY_KEY] mutableCopy];
    if (!settings) {
        return defaultString;
    }
    if (![[settings allKeys] containsObject:key]) {
        return defaultString;
    }
    return settings[key];
}

- (void)setStringValue:(NSString *)string forKey:(NSString *)key {
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_DICTIONARY_KEY] mutableCopy];
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    settings[key] = string;
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:SETTINGS_DICTIONARY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)jacksReps {
    return [self valueForKey:JACKS_REPS_KEY withDefaultValue:12];
}

- (NSUInteger)queensReps {
    return [self valueForKey:QUEENS_REPS_KEY withDefaultValue:15];
}

- (NSUInteger)kingsReps {
    return [self valueForKey:KINGS_REPS_KEY withDefaultValue:20];
}

- (NSUInteger)acesReps {
    return [self valueForKey:ACES_REPS_KEY withDefaultValue:25];
}

- (NSUInteger)jokersReps {
    return [self valueForKey:JOKERS_REPS_KEY withDefaultValue:50];
}

- (void)setJacksReps:(NSUInteger)jacksReps {
    [self setNSUIntegerValue:jacksReps forKey:JACKS_REPS_KEY];
}

- (void)setQueensReps:(NSUInteger)queensReps {
    [self setNSUIntegerValue:queensReps forKey:QUEENS_REPS_KEY];
}

- (void)setKingsReps:(NSUInteger)kingsReps {
    [self setNSUIntegerValue:kingsReps forKey:KINGS_REPS_KEY];
}

- (void)setAcesReps:(NSUInteger)acesReps {
    [self setNSUIntegerValue:acesReps forKey:ACES_REPS_KEY];
}

- (void)setJokersReps:(NSUInteger)jokersReps {
    [self setNSUIntegerValue:jokersReps forKey:JOKERS_REPS_KEY];
}

- (NSUInteger)valueForKey:(NSString *)key withDefaultValue:(NSUInteger)defaultValue {
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_KEY] mutableCopy];
    if (!settings) {
        return defaultValue;
    }
    if (![[settings allKeys] containsObject:key]) {
        return defaultValue;
    }
    return [settings[key] longValue];
}

- (void)setNSUIntegerValue:(NSUInteger)value forKey:(NSString *)key {
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_DICTIONARY_KEY] mutableCopy];
    if (!settings) {
        settings = [[NSMutableDictionary alloc] init];
    }
    settings[key] = [NSNumber numberWithLong:value];
    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:SETTINGS_DICTIONARY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
