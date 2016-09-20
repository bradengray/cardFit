//
//  GameSettingsTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsDataController.h"

@interface SettingsTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton; // Navigation button for side menu

- (SettingsDataController *)createDataSource; //Abstract creates data source object

@end
