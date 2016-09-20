//
//  PlayingCardDetailSettingsDataController.m
//  CardFit
//
//  Created by Braden Gray on 9/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardDetailSettingsController.h"
#import "PlayingCardSettings.h"

#define POINTS @"Points"
#define EXERCISE @"Exercise"

@interface PlayingCardDetailSettingsController ()

@property (nonatomic, strong) PlayingCardSettings *playingCardSettings; //Stores settings object

@end

@implementation PlayingCardDetailSettingsController

#pragma mark - Properties
//Lazy instantiat settings
- (PlayingCardSettings *)playingCardSettings {
    if (!_playingCardSettings) {
        _playingCardSettings = [[PlayingCardSettings alloc] init];
    }
    return _playingCardSettings;
}

//Return dataSectionTitles
- (NSArray *)dataSectionTitles {
    if (self.selectedIndexPath.section == 2) {
        return @[EXERCISE];
    } else if (self.selectedIndexPath.section == 3) {
        return @[POINTS, EXERCISE];
    } else {
        NSLog(@"Parser Error: No value for Key");
        return nil;
    }
}

#pragma mark - Abstract Methods
//Creates data
- (NSDictionary *)createData { //Abstract
    if (self.selectedIndexPath.section == 2) {
        if (self.selectedIndexPath.row == 0) {
            return @{EXERCISE : @[SPADES_EXCERCISE_KEY]};
        } else if (self.selectedIndexPath.row == 1) {
            return @{EXERCISE : @[CLUBS_EXCERCISE_KEY]};
        } else if (self.selectedIndexPath.row == 2) {
            return @{EXERCISE : @[HEARTS_EXCERCISE_KEY]};
        } else if (self.selectedIndexPath.row == 3) {
            return @{EXERCISE : @[DIAMONDS_EXCERCISE_KEY]};
        } else {
            NSLog(@"Parser error: No value for key");
            return nil;
        }
    } else if (self.selectedIndexPath.section == 3) {
        if (self.selectedIndexPath.row == 0) {
            return @{POINTS : @[ACES_POINTS_KEY], EXERCISE : @[ACES_EXERCISE_KEY]};
        } else if (self.selectedIndexPath.row == 1) {
            return @{POINTS : @[JOKERS_POINTS_KEY], EXERCISE : @[JOKERS_EXERCISE_KEY]};
        } else {
            NSLog(@"Parser error: No value for key");
            return nil;
        }
    } else {
        NSLog(@"Parser error: No value for key");
        return nil;
    }
}

//Sets selected value for key
- (void)setSelectedValue:(id)value forKey:(NSString *)key { //Abstract
    [self.playingCardSettings setSettingsValue:value forKey:key];
}

//Gets value for key
- (id)getValueForKey:(NSString *)key { //Abstract
    return [self.playingCardSettings getValueForKey:key];
}

//Keys for footer Instructions
#define FOOTER_INSTRUCTIONS_1 @"Do not explicitly state the number of reps. Reps will be determined by the card."
#define FOOTER_INSTRUCTIONS_2 @"Points will determine the value of this card for scoring."

//Returns string for footer view
- (NSString *)textForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return FOOTER_INSTRUCTIONS_1;
    } else if (section == 1) {
        return FOOTER_INSTRUCTIONS_2;
    } else {
        NSLog(@"Parser Error: No value for section");
        return nil;
    }
}

@end
