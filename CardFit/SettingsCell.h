//
//  SettingsCell.h
//  CardFit
//
//  Created by Braden Gray on 7/31/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsCell : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSString *detailDescription;
@property (nonatomic, strong) NSString *footerInstrucions;
@property (nonatomic, strong) NSString *settingsDetail1;
@property (nonatomic, strong) NSString *SettingsDetail2;
@property (nonatomic) BOOL cellBool;

//Returns an array of settings objects that you wish to be used in a tableview this should be implemented in your subclass
- (NSArray *)detailSettingsForSettingsCell:(SettingsCell *)settingsCell;
- (SettingsCell *)setValue:(NSString *)value forIndex:(NSInteger)index;
//Returns a string title for the value given
- (NSString *)rowTitleForValue:(NSString *)value; //Abstract

//- (NSString *)getTitleForSettingsDetail:(NSString *)detail; //Abstract

@end
