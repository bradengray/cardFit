//
//  SettingsDataController.m
//  CardFit
//
//  Created by Braden Gray on 9/14/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "MainSettingsController.h"

//Keys for prototype Cells in our TableViewController
#define CELL_1 @"Cell1"
#define CELL_2 @"Cell2"
#define CELL_3 @"Cell3"

@implementation MainSettingsController

#pragma mark UITableViewDataSource Methods
//Number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { //number of sections in tableview
    return [self.data count];
}

//Number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { //number of rows in section
    return [[self.data objectForKey:self.dataSectionTitles[section]] count];
}

//Title for header in tableview
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { //Section header title
    return self.dataSectionTitles[section];
}

//Cell for row at index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { //Creates cell for row
    //Get dictionary for selected cell
    NSString *sectionTitle = self.dataSectionTitles[indexPath.section];
    NSArray *sectionData = [self.data objectForKey:sectionTitle];
    NSString *cellTitle = [sectionData objectAtIndex:indexPath.row];
    static NSString *cellIdentifier;
    if (indexPath.section == 0) {
        cellIdentifier = CELL_1;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:cellTitle attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
        return cell;
    } else if (indexPath.section == 1) {
        cellIdentifier = CELL_2;
        SwitchTableViewCell *cell = (SwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        cell.textLabel.text = cellTitle;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if ([[self.settings getValueForKey:cellTitle] isKindOfClass:[NSNumber class]]) {
            [cell setSwitchValue:[[self.settings getValueForKey:cellTitle] boolValue]];
        } else {
            NSLog(@"DataSource Error: Value for key is not boolean value");
        }
        return cell;
    } else {
        cellIdentifier = CELL_3;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = cellTitle;
        cell.detailTextLabel.text = [self getDetailForKey:cellTitle];
        return cell;
    }
}

#pragma mark - Abstract Methods 
//Called when model is changed
- (void)modelChanged {
    self.data = [self createData];
    [self.tableView reloadData];
}

//Set value for indexPath
- (void)didSelectIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.dataSectionTitles[indexPath.section];
    NSString *value = [[self.data objectForKey:key] objectAtIndex:indexPath.row];
    [self setSelectedValue:value forKey:key];
    self.data = [self createData];
}

#pragma mark - SwitchTableViewDelegate Methods
//Called when switch value is changed
- (void)switchChangedValue:(BOOL)value {
    [self setSelectedValue:[NSNumber numberWithBool:value] forKey:self.dataSectionTitles[1]];
}

@end
