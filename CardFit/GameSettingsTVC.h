//
//  GameSettingsTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"

@interface GameSettingsTVC : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (Settings *)createSettings; //Abstract

@end
