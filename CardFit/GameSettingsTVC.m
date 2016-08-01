//
//  GameSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#define SETTINGS_DETAIL_SEGUE_IDENTIFER @"Show Settings Detail"

#import "GameSettingsTVC.h"
#import "SWRevealViewController.h"
#import "GameSettingsDetailTVC.h"
#import "SettingsChangedNotification.h"

@interface GameSettingsTVC () <GameSettingsDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath; //Tracks current selected cell
@property (nonatomic, strong) Settings *settings; //Settings object
//Array of data is used to reload tableview when data is set otherwise it is just setting object's data
@property (nonatomic, strong) NSArray *data;

@end

@implementation GameSettingsTVC

#pragma mark - View Life Cycle

- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    self.settings = [self createSettings]; //Creates settings
    self.data = self.settings.data; //Set Data
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; //Make blank footer
    //Set up for sidebarButton
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle:)];
}

- (void)viewDidAppear:(BOOL)animated { //Called when view appears
    [super viewDidAppear:animated];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer]; //Add gesture swipe to side menu
}

#pragma mark - Properties

- (void)setData:(NSArray *)data { //Set data
    _data = data;
    [self.tableView reloadData]; //Reload tableview
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { //number of sections in tableview
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { //number of rows in section
    return [self.data[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { //Section header title
    return self.settings.sectionsArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { //Creates cell for row
    //Get dictionary for selected cell
    NSDictionary *cellDictionary = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    static NSString *cellIdentifier;
    UITableViewCell *cell;
    //Check which prototype cell to use
    if ([[cellDictionary objectForKey:CELL_KEY] isEqualToString:CELL_1]) {
        //Cell one is a standard cell with a title and disclosure indicator
        cellIdentifier = CELL_1;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [cellDictionary objectForKey:TEXTLABEL_TITLE_KEY];
        cell.detailTextLabel.text = [cellDictionary objectForKey:TEXTLABEL_DESCRIPTION_KEY];
        
    } else if ([[cellDictionary objectForKey:CELL_KEY] isEqualToString:CELL_2]) {
        //Cell two is a cell with a title and a switch
        cellIdentifier = CELL_2;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:[[cellDictionary objectForKey:CELL_BOOL_KEY] boolValue] animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.textLabel.text = [cellDictionary objectForKey:TEXTLABEL_TITLE_KEY];
    } else if ([[cellDictionary objectForKey:CELL_KEY] isEqualToString:CELL_3]) {
        //Cell three is a cell with a centered blue title and is treated like a button for resetting defaults
        cellIdentifier = CELL_3;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[cellDictionary objectForKey:TEXTLABEL_TITLE_KEY] attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { //Called when cell is selected
    self.selectedIndexPath = indexPath;
    NSDictionary *dictionary = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([[dictionary objectForKey:CELL_KEY] isEqualToString:CELL_3]) { //If cell 3 reset defaults
        [Settings resetDefaults];
        [self settingsChanged]; //Reset tableview
    } else { //If any other cell got to detailed settings
        [self performSegueWithIdentifier:SETTINGS_DETAIL_SEGUE_IDENTIFER sender:tableView];
    }
}


- (void)switchChanged:(UISwitch *)switchView { //Called when switch is touched
    [self.settings switchChanged:switchView.on]; //Store settings
    [self settingsChanged]; //reload tableview
}

- (void)settingsChanged { //Called to set new settings and relaod tableview
    self.data = self.settings.data;
}

#pragma mark - GameSettingsDelegate

- (void)settingsChanged:(NSDictionary *)dictionary { //Called when detailed settings changes a settings value
    [self.settings storeNewSettings:dictionary]; //Store new settings
    [self settingsChanged]; //Set data array
    dictionary = [self.data[self.selectedIndexPath.section] objectAtIndex:self.selectedIndexPath.row]; //Get new settings dictionary
    //Post notification with new settings dictionary
    NSDictionary *userInfo = @{SettingsChanged : dictionary};
    [[NSNotificationCenter defaultCenter] postNotificationName:SettingsChangedNotification
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //Called to prepare for segue
    if ([sender isKindOfClass:[UITableView class]]) {
        if ([segue.identifier isEqualToString:SETTINGS_DETAIL_SEGUE_IDENTIFER]) {
            if ([segue.destinationViewController isKindOfClass:[GameSettingsDetailTVC class]]) {
                //Segue to detailed settings
                GameSettingsDetailTVC *gsdtvc = (GameSettingsDetailTVC *)segue.destinationViewController;
                gsdtvc.settingsDetailDictionary = [self.data[self.selectedIndexPath.section] objectAtIndex:self.selectedIndexPath.row];
                gsdtvc.delegate = self;
            }
        }
    }
}

@end
