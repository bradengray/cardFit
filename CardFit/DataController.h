//
//  GameDataController.h
//  CardFit
//
//  Created by Braden Gray on 9/15/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Settings.h"

@interface DataController : NSObject <UIPickerViewDataSource>

@property (nonatomic, strong) NSDictionary *data; //Contains data dictionary
@property (nonatomic, strong) NSArray *dataSectionTitles; //Contains titles for sections in data dictionary

//Create data object
- (NSDictionary *)createData; //Abstract
//Returns value for key
- (id)getValueForKey:(NSString *)key; //Abstract
//Sets value for selected indexPath
- (void)didSelectIndexPath:(NSIndexPath *)indexPath; //Abstract
//Called when model has changed
- (void)modelChanged; //Abstract

@end
