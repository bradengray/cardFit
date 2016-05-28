//
//  PlayingCardSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettingsTVC.h"
#import "PlayingCardSettings.h"

@interface PlayingCardSettingsTVC ()

@property (nonatomic, strong) PlayingCardSettings *settings;

@end

@implementation PlayingCardSettingsTVC

#pragma mark - ViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Initialization

- (PlayingCardSettings *)settings {
    if (!_settings) {
        _settings = [[PlayingCardSettings alloc] init];
    }
    return _settings;
}

#pragma mark - OverWrites

- (void)switchChangedTo:(BOOL)on { //Abstract
    if (on) {
        self.settings.jokers = YES;
    } else {
        self.settings.jokers = NO;
    }
    [self settingsChanged];
}

- (void)storeNewSettingsDictionary:(NSDictionary *)dictionary {
    NSString *title = [dictionary objectForKey:TEXTLABEL_TITLE_KEY];
    NSString *exercise = [dictionary objectForKey:EXERCISE];
    NSUInteger reps = [(NSString *)[dictionary objectForKey:REPS] integerValue];
    BOOL labelBool = [[dictionary objectForKey:PROTOTYPE_CELL_1_BOOL_KEY] boolValue];
    
    if ([title isEqualToString:SPADE]) {
        self.settings.spadesExerciseString = exercise;
    } else if ([title isEqualToString:CLUB]) {
        self.settings.clubsExerciseString = exercise;
    } else if ([title isEqualToString:HEART]) {
        self.settings.heartsExerciseString = exercise;
    } else if ([title isEqualToString:DIAMOND]) {
        self.settings.diamondsExerciseString = exercise;
    } else if ([title isEqualToString:JACK]) {
        self.settings.jacksReps = reps;
    } else if ([title isEqualToString:QUEEN]) {
        self.settings.queensReps = reps;
    } else if ([title isEqualToString:KING]) {
        self.settings.kingsReps = reps;
    } else if ([title isEqualToString:ACE]) {
        self.settings.acesExerciseString = exercise;
        self.settings.acesReps = reps;
        self.settings.aceExerciseAndRepsLabel = labelBool;
    } else if ([title isEqualToString:JOKER]) {
        self.settings.jokersExerciseString = exercise;
        self.settings.jokersReps = reps;
        self.settings.jokerExerciseAndRepsLabel = labelBool;
    } else {
        NSLog(@"Error No Setting");
    }
    [self settingsChanged];
}

- (NSArray *)numbers {
    return @[REPS];
}

- (NSArray *)values {
    return @[REPS, EXERCISE, PROTOTYPE_CELL_1_BOOL_KEY, CARD_LABEL];
}

- (void)restoreDefaultDictionary {
    [self.settings resetDefaults];
    [self settingsChanged];
}

#pragma mark - Methods

- (void)settingsChanged {
    self.data = self.settings.data;
}

@end
