//
//  DetailSettingsDataController.m
//  CardFit
//
//  Created by Braden Gray on 9/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "DetailSettingsController.h"

@implementation DetailSettingsController

#pragma mark - UITableViewDataSource
//Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { //Number of sections in table view
    return [self.dataSectionTitles count];
}

//Number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { //Number of rows in section of tableview
    NSString *sectionTitle = self.dataSectionTitles[section];
    NSArray *rows = [self.data objectForKey:sectionTitle];
    return [rows count];
}

//Cell for row at index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { //Creates cell for row
    static NSString *cellIdentifier = @"Cell1";
    TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.delegate = self;
    
    NSString *key = [[self.data objectForKey:self.dataSectionTitles[indexPath.section]] objectAtIndex:indexPath.row];
    [cell setTextFieldTag:indexPath.row];
    cell.titleText = self.dataSectionTitles[indexPath.section];
    id value = [self getValueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        [cell textFieldText:(NSString *)value withNumberPad:NO];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        [cell textFieldText:[NSString stringWithFormat:@"%ld", [(NSNumber *)value integerValue]] withNumberPad:YES];
    }

    return cell;
}

#pragma mark - Abstract Methods
//Returns text for footer views
- (NSString *)textForFooterInSection:(NSInteger)section {
    return [self textForFooterInSection:section];
}

#pragma mark - TextFieldTableViewDelegate Methods
//Called when textfield value changes
- (void)tableViewCell:(TextFieldTableViewCell *)cell changedTextField:(UITextField *)textField {
    BOOL save;
    NSString *key = [[self.data objectForKey:cell.titleText] objectAtIndex:textField.tag];
    id value    = [self getValueForKey:key];
    if (![textField.text isEqualToString:@""]) {
        NSString *alert = [self alertLabelForString:textField.text forKey:value];
        if (alert) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AlertPosted object:self userInfo:@{AlertPosted : alert}];
        } else {
            save = YES;
        }
    }
    
    if (save) {
        [self setSelectedValue:textField.text forKey:key];
    } else {
        if ([value isKindOfClass:[NSString class]]) {
            [cell textFieldText:value withNumberPad:NO];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            [cell textFieldText:[NSString stringWithFormat:@"%ld", [(NSNumber *)value integerValue]] withNumberPad:YES];
        }
    }
}

//Constraints for alert messages
#define MINIMUM_STRING_LENGTH 15
#define MAX_NUMBER_VALUE 1000

////Returns an alert string for a given key
- (NSString *)alertLabelForString:(NSString *)string forKey:(NSString *)key { //Abstract
    if ([string isEqualToString:@""]) { //If no entry then alert
        return @"Entry Required";
    } else {
        if ([key isKindOfClass:[NSNumber class]]) { //Check to see if number values only
            if ([string integerValue] >= MAX_NUMBER_VALUE) { //Check against max value
                return [NSString stringWithFormat:@"Value Must Be Less Than %d", MAX_NUMBER_VALUE];
            } else if ([string integerValue] <= 0) {
                    return @"Reps Must be Greater Than 0";
            } else {
                return nil;
            }
        } else { //If not a number value then must be a string
            if ([string length] > MINIMUM_STRING_LENGTH) { //Check the string length
                return [NSString stringWithFormat:@"Exercise Must Contain Less Than %d Characters", MINIMUM_STRING_LENGTH];
            } else {
                return nil;
            }
        }
    }
}

@end
