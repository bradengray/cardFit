//
//  SettingsDataController.h
//  CardFit
//
//  Created by Braden Gray on 9/17/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "DataController.h"
#import "Settings.h"

@interface SettingsDataController : DataController <UITableViewDataSource>

extern NSString *const AlertPosted; //Global variable for posting alerts

@property (nonatomic, strong) UITableView *tableView; //Stores tableview
@property (nonatomic, strong) Settings *settings;  //Stores Settings

//Set value for key
- (void)setSelectedValue:(id)value forKey:(NSString *)key; //Abstract
//Get detail for key
- (NSString *)getDetailForKey:(NSString *)key; //Abstract
//Get string value for footerview
- (NSString *)textForFooterInSection:(NSInteger)section; //Abstract

@end
