//
//  SettingsDataController.m
//  CardFit
//
//  Created by Braden Gray on 9/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "SettingsDataController.h"

@implementation SettingsDataController

NSString *const AlertPosted = @"Alert Posted"; //Defines global variable for posting alerts

#pragma mark - Properties
//Lazy instantiate settings object
- (Settings *)settings {
    if (!_settings) {
        _settings = [[Settings alloc] init];
    }
    return _settings;
}

#pragma mark - UITableViewDelegate
//Number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
//Cell for row at indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Abstract Methods

- (void)setSelectedValue:(id)value forKey:(NSString *)key { //Abstract
    return;
}

- (NSString *)getDetailForKey:(NSString *)key { //Abstract
    return nil;
}

- (NSString *)textForFooterInSection:(NSInteger)section { //Abstract
    return nil;
}

@end
