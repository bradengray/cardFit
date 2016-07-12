//
//  SettingsTVC.h
//  CardFit
//
//  Created by Braden Gray on 6/26/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface SettingsTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (Settings *)createSettings; //Abstract create settings object in sub class

@end
