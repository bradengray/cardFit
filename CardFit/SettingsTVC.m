//
//  GameSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

//#define SETTINGS_DETAIL_SEGUE_IDENTIFER @"Show Settings Detail"
//
#import "SettingsTVC.h"
#import "SWRevealViewController.h"
#import "DetailSettingsTVC.h"
#import "SettingsDataController.h"

@interface SettingsTVC ()

@property (nonatomic, strong) SettingsDataController *dataSource; //Data Source for tableView
@property (nonatomic, strong) NSIndexPath *selectedIndexpath; //Tracks last selected index path

@end

@implementation SettingsTVC

#pragma mark - View Life Cycle

- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource; //Set dataSource for tableView
    self.dataSource.tableView = self.tableView;
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

- (DataController *)dataSource { //Lazy Instantiate dataSource
    if (!_dataSource) {
        _dataSource = [self createDataSource];
    }
    return _dataSource;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section { //Called to display header view
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    UIFont *font = [[UIFont alloc] init];
    font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
    
    header.textLabel.attributedText = [[NSAttributedString alloc] initWithString:header.textLabel.text attributes:@{NSFontAttributeName : font}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { //Called when cell is selected
    if (indexPath.section > 1) { //If not section 0 then segue
        [self.dataSource didSelectIndexPath:indexPath];
        self.selectedIndexpath = indexPath;
        [self performSegueWithIdentifier:SETTINGS_DETAIL_SEGUE_IDENTIFER sender:tableView];
    }
    [self.tableView reloadData];
}

#pragma mark Abstract Methods
//Create Data Controller
- (DataController *)createDataSource { //Abstract returns data source object
    return [[DataController alloc] init];
}

#pragma mark Segue
//Called just before segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //Called to prepare for segue
    if ([sender isKindOfClass:[UITableView class]]) {
        if ([segue.identifier isEqualToString:SETTINGS_DETAIL_SEGUE_IDENTIFER]) {
            if ([segue.destinationViewController isKindOfClass:[DetailSettingsTVC class]]) {
                //Segue to detailed settings
                DetailSettingsTVC * gsdtvc = (DetailSettingsTVC *)segue.destinationViewController;
                gsdtvc.selectedIndexPath = self.selectedIndexpath;
            }
        }
    }
}

@end
