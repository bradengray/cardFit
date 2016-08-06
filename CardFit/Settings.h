//
//  Settings.h
//  CardFit
//
//  Created by Braden Gray on 6/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsCell.h"

//Keys for prototype Cells in our TableViewController
#define CELL_1 @"Cell1"
#define CELL_2 @"Cell2"
#define CELL_3 @"Cell3"

@interface Settings : NSObject

//data is an array containg sections and each section is an array containg dictionaries with your settings information
@property (nonatomic, strong) NSArray *data;
//sectionsArray contains the names of the sections in your data array.
@property (nonatomic, strong) NSArray *sectionsArray;

//save is a bool property that determines whether or not setting your variables with save to NSUserDefaults or not.
@property (nonatomic) BOOL save;

//Stores a string for the number of cards you wish to play with.
@property (nonatomic, strong) NSString *onePlayerNumberOfCards;
@property (nonatomic, strong) NSString *multiplayerNumberOfCards;

//Arrays containing string values for possible choices to store as your number of cards string. These are used for selection menus.
@property (nonatomic, strong) NSArray *onePlayerNumberOfCardsOptionStrings;
@property (nonatomic, strong) NSArray *multiplayerNumberOfCardsOptionStrings;

//Dictionary holding values as NSNumbers for Number Of Card string you have chosen.
//The Keys for the values stored are the strings held by the Arrays onePlayerNumberOfCardsOptionStrings and twoPlayerNumberOfCardsOptionStrings.
@property (nonatomic, strong) NSDictionary *numberOfCardsOptionValues;

//Class method used to restore defaults
+ (void)resetDefaults;
//Abstract used to return a string for a card label based on suit and rank
- (NSString *)labelForSuit:(NSUInteger)suit andRank:(NSUInteger)rank;
//Abstract used to return a string for alert messages. The key used should be a key from your data dictionary
- (NSString *)alertLabelForString:(NSString *)string forKey:(NSString *)key; //Abstract
//Abstract used to store new settings the dictionary provided should be a dictionary from your data
- (void)storeNewSettings:(SettingsCell *)settings; //Abstract
//Abstract used to communicate if a settings cell has been changed.
- (void)switchChanged:(BOOL)on; //Abstract
//Abstract used to return the points for a specific rank.
- (NSUInteger)pointsForRank:(NSUInteger)rank; //Abstract

//Called for setters and getters of all settings properties using NSUserDefaults
- (NSString *)valueForKey:(NSString *)key withDefaultString:(NSString *)defaultString;
- (void)setStringValue:(NSString *)string forKey:(NSString *)key;
- (NSUInteger)valueForKey:(NSString *)key withDefaultValue:(NSUInteger)defaultValue;
- (void)setNSUIntegerValue:(NSUInteger)value forKey:(NSString *)key;

@end
