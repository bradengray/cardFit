//
//  GameSettingsTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "DataController.h"
//#import "Settings.h"

@interface GameSettingsTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton; // Navigation button for side menu

- (DataController *)createDataSource; //Abstract creates data source object

@end
