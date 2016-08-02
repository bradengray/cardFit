//
//  SettingsCell.m
//  CardFit
//
//  Created by Braden Gray on 7/31/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

- (NSArray *)detailSettingsForSettingsCell:(SettingsCell *)settingsCell {
    NSMutableArray *detailSettings = [[NSMutableArray alloc] init];
    if (settingsCell.settingsDetail1) {
        [detailSettings addObject:settingsCell.settingsDetail1];
    }
    if (settingsCell.SettingsDetail2) {
        [detailSettings addObject:settingsCell.SettingsDetail2];
    }
    return detailSettings;
}

- (SettingsCell *)setValue:(NSString *)value forIndex:(NSInteger)index {
    if (index == 0) {
        self.settingsDetail1 = value;
    } else if (index == 1) {
        self.SettingsDetail2 = value;
    } else {
        NSLog(@"Error in setValue:(NSString *)value forIndex:(int)index");
    }
    return self;
}

#pragma mark - Abstract Methods

- (NSString *)rowTitleForValue:(NSString *)value { //Abstract
    return nil;
}

@end
