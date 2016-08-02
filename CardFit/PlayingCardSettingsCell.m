//
//  PlayingCardSettingsCell.m
//  CardFit
//
//  Created by Braden Gray on 7/31/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettingsCell.h"

@implementation PlayingCardSettingsCell

- (NSString *)rowTitleForValue:(NSString *)value {
    if ([value isEqualToString:self.settingsDetail1]) {
        return @"Points";
    } else if ([value isEqualToString:self.SettingsDetail2]) {
        return @"Exercise";
    } else {
        return @"?";
    }
}

//- (NSArray *)detailSettingsForSettingsCell:(SettingsCell *)settingsCell {
//    NSMutableArray *detailSettings = [[NSMutableArray alloc] init];
//    if ([settingsCell isKindOfClass:[PlayingCardSettingsCell class]]) {
//        PlayingCardSettingsCell *playingCardSettingsCell = (PlayingCardSettingsCell *)settingsCell;
//        NSString *points;
//        NSString *exercise;
//        if (playingCardSettingsCell.points) {
//            points = playingCardSettingsCell.points;
//            [detailSettings addObject:points];
//        }
//        if (playingCardSettingsCell.exercise) {
//            exercise = playingCardSettingsCell.exercise;
//            [detailSettings addObject:exercise];
//        }
//    }
//    return detailSettings;
//}
//
//- (NSString *)rowTitleForValue:(NSString *)value {
//    if ([value isEqualToString:playingCardSettingsCell.exercise]) {
//        return @"Exercise";
//    } else if ([value isEqualToString:playingCardSettingsCell.points]) {
//        return @"Points";
//    } else {
//        return @"?";
//    }
//}

@end
