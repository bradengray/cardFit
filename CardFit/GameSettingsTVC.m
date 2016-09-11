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

@interface GameSettingsTVC ()

@property (nonatomic, strong) DataController *dataSource; //Data Source for tableView

@end

@implementation GameSettingsTVC

#pragma mark - View Life Cycle

- (void)viewDidLoad { //Called when view loads
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource; //Set dataSource for tableView
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; //Make blank footer
    //Set up for sidebarButton
    [self.sidebarButton setTarget:self.revealViewController];
    [self.sidebarButton setAction:@selector(revealToggle:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged) name:DataSourceChanged object:nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { //Called when cell is selected
    if ([[self.dataSource cellIdentifierForIndexPath:indexPath] isEqualToString:CELL_3]) { //If cell 3 reset defaults
        [Settings resetDefaults];
        [self settingsChanged]; //Reset tableview
    } else { //If any other cell got to detailed settings
        self.dataSource.selectedIndexPath = indexPath; //Set data source selected index path
        [self performSegueWithIdentifier:SETTINGS_DETAIL_SEGUE_IDENTIFER sender:tableView];
    }
}

- (void)settingsChanged { //Called to set new settings and relaod tableview
    [self.tableView reloadData];
}

#pragma mark Abstract Methods

- (DataController *)createDataSource { //Abstract returns data source object
    return [[DataController alloc] init];
}

#pragma mark Segue

//Called just before segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender { //Called to prepare for segue
    if ([sender isKindOfClass:[UITableView class]]) {
        if ([segue.identifier isEqualToString:SETTINGS_DETAIL_SEGUE_IDENTIFER]) {
            if ([segue.destinationViewController isKindOfClass:[GameSettingsDetailTVC class]]) {
                //Segue to detailed settings
                GameSettingsDetailTVC * gsdtvc = (GameSettingsDetailTVC *)segue.destinationViewController;
                gsdtvc.dataSource = self.dataSource;
            }
        }
    }
}

@end
