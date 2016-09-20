//
//  GameDataController.m
//  CardFit
//
//  Created by Braden Gray on 9/15/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "DataController.h"

@implementation DataController

#pragma mark - Properties

- (NSDictionary *)data { //Set observer for radio station and create new data
    if (!_data) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelChanged) name:SettingsChangedInModel object:nil];
    }
    return [self createData];
}

#pragma mark - Radio Station Methods

- (void)modelChanged { //Called when model has changed
    self.data = [self createData];
}

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { //number of compontents for pickerView
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { //number of rows for pickerView
    NSString *sectionTitle = self.dataSectionTitles[component];
    NSArray *rows = [self.data objectForKey:sectionTitle];
    return [rows count];
}

#pragma mark - Abstract Methods

- (NSDictionary *)createData { //Abstract
    return nil;
}

- (id)getValueForKey:(NSString *)key { //Abstract
    return nil;
}

- (void)didSelectIndexPath:(NSIndexPath *)indexPath { //Abstract
    return;
}

@end
