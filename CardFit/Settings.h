//
//  Settings.h
//  CardFit
//
//  Created by Braden Gray on 6/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CELL_KEY @"Cell"
#define CELL_1 @"Cell1"
#define CELL_2 @"Cell2"
#define CELL_3 @"Cell3"

#define CELL_BOOL_KEY @"Bool Key"

#define TEXTLABEL_TITLE_KEY @"Title"
#define TEXTLABEL_DESCRIPTION_KEY @"Label Description"

#define CARD_LABEL @"Card Label"

@interface Settings : NSObject

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *sectionsArray;
@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *numbers;

//Keeps a default number of cards chosen and also keeps track of last chosen number of cards.
@property (nonatomic, strong) NSString *onePlayerNumberOfCards;
@property (nonatomic, strong) NSString *multiplayerNumberOfCards;

@property (nonatomic) BOOL save;

//Arrays containing string values for Number Of Card Options Menus
@property (nonatomic, strong) NSArray *onePlayerNumberOfCardsOptionStrings;
@property (nonatomic, strong) NSArray *multiplayerNumberOfCardsOptionStrings;

//Dictionary holding values for Number Of Card Options.
//The Keys for the values are the strings held by the Arrays onePlayerNumberOfCardsOptionStrings and twoPlayerNumberOfCardsOptionStrings.
@property (nonatomic, strong) NSDictionary *numberOfCardsOptionValues;

+ (void)resetDefaults;
//- (NSString *)labelForObject:(id)object;
- (NSString *)labelForSuit:(NSUInteger)suit andRank:(NSUInteger)rank; //Abstract
- (NSString *)alertLabelForString:(NSString *)string forKey:(NSString *)key; //Abstract
- (void)storeNewSettings:(NSDictionary *)settings; //Abstract
- (void)switchChanged:(BOOL)on;

- (NSString *)valueForKey:(NSString *)key withDefaultString:(NSString *)defaultString;
- (void)setStringValue:(NSString *)string forKey:(NSString *)key;
- (NSUInteger)valueForKey:(NSString *)key withDefaultValue:(NSUInteger)defaultValue;
- (void)setNSUIntegerValue:(NSUInteger)value forKey:(NSString *)key;

@end
