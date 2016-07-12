//
//  Settings.h
//  CardFit
//
//  Created by Braden Gray on 6/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

//Keys for prototype Cells in our TableViewController
#define CELL_KEY @"Cell"
#define CELL_1 @"Cell1"
#define CELL_2 @"Cell2"
#define CELL_3 @"Cell3"

#define CELL_BOOL_KEY @"Bool Key"

#define TEXTLABEL_TITLE_KEY @"Title"
#define TEXTLABEL_DESCRIPTION_KEY @"Label Description"
#define CARD_LABEL @"Card Label"

@interface Settings : NSObject

//data is an array containg sections and each section is an array containg dictionaries with your settings information
@property (nonatomic, strong) NSArray *data;
//sectionsArray contains the names of the sections in your data array.
@property (nonatomic, strong) NSArray *sectionsArray;
//values holds the names of all dictionary keys that should be shown as cells in a tableview
@property (nonatomic, strong) NSArray *values;
//numbers hold the names of all dictionary keys that should be considered to be numeric in value. It is used to tell what type of keyboard your setting will be useing.
@property (nonatomic, strong) NSArray *numbers;
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
- (void)storeNewSettings:(NSDictionary *)settings; //Abstract
//Abstract used to communicate if a settings cell has been changed.
- (void)switchChanged:(BOOL)on; //Abstract

//Called for setters and getters of all settings properties using NSUserDefaults
- (NSString *)valueForKey:(NSString *)key withDefaultString:(NSString *)defaultString;
- (void)setStringValue:(NSString *)string forKey:(NSString *)key;
- (NSUInteger)valueForKey:(NSString *)key withDefaultValue:(NSUInteger)defaultValue;
- (void)setNSUIntegerValue:(NSUInteger)value forKey:(NSString *)key;

@end
