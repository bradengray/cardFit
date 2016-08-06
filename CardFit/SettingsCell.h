//
//  SettingsCell.h
//  CardFit
//
//  Created by Braden Gray on 7/31/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsCell : NSObject

@property (nonatomic, strong) NSString *title; //Title for cell
@property (nonatomic, strong) NSString *value; //Value of cell
@property (nonatomic, strong) NSString *cellIdentifier; //Cell identifier
@property (nonatomic, strong) NSString *detailDescription; //Description for cell
@property (nonatomic, strong) NSString *footerInstrucions; //Footer Notes
@property (nonatomic, strong) NSArray *detailSettingsCells; //Of SettingsCells
@property (nonatomic) BOOL cellBool; //Bool value for cell

//Returns an array of settings objects that you wish to be used in a tableview this should be implemented in your subclass
- (SettingsCell *)setDetailSettingsValue:(NSString *)value forIndex:(NSInteger)index;

@end
