//
//  DataController.h
//  CardFit
//
//  Created by Braden Gray on 9/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"
#import "Settings.h"

@interface DataController : UIViewController <UIPickerViewDataSource, UITableViewDataSource>

extern NSString *const DataSourceChanged; //Global for radio station

@property (nonatomic, strong) Settings *settings; //Settings Object
@property (nonatomic) BOOL multiPlayer; //Controller will return different data if multiPlayer is set
@property (nonatomic, strong) NSIndexPath *selectedIndexPath; //Keeps track of last selected indexPath

//PickerView Helper Methods
- (NSString *)pickerViewStringForRow:(NSUInteger)row; //Returns string for row
- (void)storePickerViewDataForRow:(NSUInteger)row; //Stores data for selected row
- (NSUInteger)pickerViewDefaultRow; //returns last selected row

//UITableViewHelperMethods
- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath; //Return cell Identifier for selected index path
- (SettingsCell *)selectedSettingsCell; //Returns settingsCell for indexPath

//DetailTableView Helper Methods
- (NSString *)alertLabelForString:(NSString *)string forCellIndex:(NSUInteger)index; //Returns alert string for index
- (NSString *)valueForCellAtIndex:(NSUInteger)index; //Returns value for settingsCell at index
- (void)storeData:(NSString *)data forIndex:(NSUInteger)index; //Stores data

//Data Helper Methods
- (NSUInteger)numberOfCards; //Returns number of cards in deck
- (void)recievedSettings:(Settings *)settings; //Stores new settings object

//Abstract Methods
- (Settings *)createSettings; //Abstract creates settings object
- (BOOL)jokers; //Abstract returns whether deck has jokers or not
- (NSUInteger)pointsForCard:(Card *)card; //Abstract returns points for card
- (NSString *)labelForCard:(Card *)card; //Abstract returns label for card
#warning refactor this
- (void)save; //Sets settings to save

@end
