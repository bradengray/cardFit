//
//  PlayingCardSettingsTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettingsTVC.h"
#import "PlayingCardDataController.h"

@implementation PlayingCardSettingsTVC

#pragma mark - Initialization

- (DataController *)createDataSource { //Abstract returns dataSource
    return [[PlayingCardDataController alloc] init];
}

@end
