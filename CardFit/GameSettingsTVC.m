//
//  GameSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

//#define SETTINGS_DETAIL_SEGUE_IDENTIFIER @"Show Settings Detail"

#define SETTINGS_DETAIL_SEGUE_IDENTIFER @"Show Settings Detail"

#import "GameSettingsTVC.h"
#import "SWRevealViewController.h"
#import "GameSettingsDetailTVC.h"
#import "SettingsChangedNotification.h"

@interface GameSettingsTVC () <GameSettingsDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation GameSettingsTVC

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

#pragma mark - Properties

- (void)setData:(NSArray *)data {
    _data = data;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionsArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *cellDictionary = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    static NSString *cellIdentifier;
    UITableViewCell *cell;
    
    if ([[cellDictionary objectForKey:PROTOTYPE_CELL_KEY] isEqualToString:PROTOTYPE_CELL_1]) {
        cellIdentifier = PROTOTYPE_CELL_1;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [cellDictionary objectForKey:TEXTLABEL_TITLE_KEY];
        cell.detailTextLabel.text = [cellDictionary objectForKey:TEXTLABEL_DESCRIPTION_KEY];
        
    } else if ([[cellDictionary objectForKey:PROTOTYPE_CELL_KEY] isEqualToString:PROTOTYPE_CELL_2]) {
        cellIdentifier = PROTOTYPE_CELL_2;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:[[cellDictionary objectForKey:PROTOTYPE_CELL_2_BOOL_KEY] boolValue] animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        cell.textLabel.text = [cellDictionary objectForKey:TEXTLABEL_TITLE_KEY];
    } else if ([[cellDictionary objectForKey:PROTOTYPE_CELL_KEY] isEqualToString:PROTOTYPE_CELL_3]) {
        cellIdentifier = PROTOTYPE_CELL_3;
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:[cellDictionary objectForKey:TEXTLABEL_TITLE_KEY] attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
    NSDictionary *dictionary = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    if ([[dictionary objectForKey:PROTOTYPE_CELL_KEY] isEqualToString:PROTOTYPE_CELL_3]) {
        [self restoreDefaultDictionary];
    } else {
        [self performSegueWithIdentifier:SETTINGS_DETAIL_SEGUE_IDENTIFER sender:tableView];
    }
}


- (void)switchChanged:(UISwitch *)switchView {
    [self switchChangedTo:switchView.on];
}

#pragma mark- Abstract Methods 

- (void)switchChangedTo:(BOOL)on { //Abstract
    return;
}

- (void)storeNewSettingsDictionary:(NSDictionary *)dictionary { //Abstract
    return;
}

- (NSArray *)numbers { //Abstract
    return nil;
}

- (NSArray *)values { //Abstract
    return nil;
}

- (void)restoreDefaultDictionary { //Abstract
    return;
}

#pragma mark - GameSettingsDelegate

- (void)settingsChanged:(NSDictionary *)dictionary {
    [self storeNewSettingsDictionary:dictionary];
    dictionary = [self.data[self.selectedIndexPath.section] objectAtIndex:self.selectedIndexPath.row];
    NSDictionary *userInfo = @{SettingsChangedForDictionary : dictionary};
    [[NSNotificationCenter defaultCenter] postNotificationName:SettingsChangedForDictionaryNotification
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[UITableView class]]) {
        if ([segue.identifier isEqualToString:SETTINGS_DETAIL_SEGUE_IDENTIFER]) {
            if ([segue.destinationViewController isKindOfClass:[GameSettingsDetailTVC class]]) {
                GameSettingsDetailTVC *gsdtvc = (GameSettingsDetailTVC *)segue.destinationViewController;
                gsdtvc.settings = [self.data[self.selectedIndexPath.section] objectAtIndex:self.selectedIndexPath.row];
                gsdtvc.delegate = self;
                gsdtvc.numbers = [self numbers];
                gsdtvc.values = [self values];
            }
        }
    }
}

@end
