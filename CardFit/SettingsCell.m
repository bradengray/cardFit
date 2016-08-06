//
//  SettingsCell.m
//  CardFit
//
//  Created by Braden Gray on 7/31/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

//To acces value of settings cell in detailSettingsCell array
- (SettingsCell *)setDetailSettingsValue:(NSString *)value forIndex:(NSInteger)index {
    //Use introspectiont make sure objects are settings settings cells.
    if ([self.detailSettingsCells[index] isKindOfClass:[SettingsCell class]]) {
        //Create new array and replace old one.
        NSMutableArray *array = [self.detailSettingsCells mutableCopy];
        SettingsCell *cell = self.detailSettingsCells[index];
        cell.value = value;
        [array replaceObjectAtIndex:index withObject:cell];
        self.detailSettingsCells = array;
    }
    return self;
}

@end
