//
//  PlayingCardSettings.m
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardSettings.h"
#import "SettingsCell.h"

//Keys for Suits
#define SPADE @"♠️"
#define CLUB @"♣️"
#define HEART @"♥️"
#define DIAMOND @"♦️"

//Keys for Cards
#define JACK @"Jack"
#define QUEEN @"Queen"
#define KING @"King"
#define ACE @"Ace"
#define JOKER @"Joker"

//Keys for jokers options and defualts section
#define JOKERS_OPTIONS @"Play With Jokers"
#define DEFAULTS @"Restore Defaults"

//Keys for exercises
#define EXERCISE @"Exercise"
#define SPADES_EXCERCISE_KEY @"Spades Exercise Key"
#define CLUBS_EXCERCISE_KEY @"Clubs Exercies Key"
#define HEARTS_EXCERCISE_KEY @"Hearts Exercise Key"
#define DIAMONDS_EXCERCISE_KEY @"Diamonds Exercies Key"
#define ACES_EXERCISE_KEY @"Aces Exercise Key"
#define JOKERS_EXERCISE_KEY @"Jokers Exercise Key"

//Keys for points.
#define EXERCISE_AND_POINTS @"Exercise and Points"
#define POINTS @"Points"
#define JACKS_POINTS_KEY @"Jacks Points Key"
#define QUEENS_POINTS_KEY @"Queen Points Key"
#define KINGS_POINTS_KEY @"King Points Key"
#define ACES_POINTS_KEY @"Aces Points Key"
#define JOKERS_POINTS_KEY @"Jokers Points Key"

//Key for jokers boolean value.
#define JOKERS_BOOLEAN_KEY @"Jokers Boolean Key"

//Keys for footer Instructions
#define FOOTER_INSTRUCTIONS_1 @"Do not explicitly state the number of reps. Reps will be determined by the card."
#define FOOTER_INSTRUCTIONS_2 @"Points will determine the value of this card for scoring."

@interface PlayingCardSettings ()

//Strings that hold the names of the exercies for the listed suits and ranks.
@property (nonatomic, strong) NSString *spadesExerciseString;
@property (nonatomic, strong) NSString *clubsExerciseString;
@property (nonatomic, strong) NSString *heartsExerciseString;
@property (nonatomic, strong) NSString *diamondsExerciseString;
@property (nonatomic, strong) NSString *acesExerciseString;
@property (nonatomic, strong) NSString *jokersExerciseString;

//Integers that hold the number of points for the listed ranks. All Cards numbered 2-10 have a point value equal to rank.
@property (nonatomic) NSUInteger jacksPoints;
@property (nonatomic) NSUInteger queensPoints;
@property (nonatomic) NSUInteger kingsPoints;
@property (nonatomic) NSUInteger acesPoints;
@property (nonatomic) NSUInteger jokersPoints;

@end

@implementation PlayingCardSettings

//Creates a shared instance of PlayingCardSettings
//+ (instancetype)sharedPlayingCardSettings {
//    static PlayingCardSettings *sharedPlayingCardSettings;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedPlayingCardSettings = [[PlayingCardSettings alloc] init];
//        sharedPlayingCardSettings.save = YES;
//    });
//    return sharedPlayingCardSettings;
//}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.save = YES;
    }
    return self;
}

//Used by NSCoder to encode this object using NSKeyedArchiver
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeBool:!self.save forKey:@"Save"];
    [aCoder encodeObject:self.spadesExerciseString forKey:SPADES_EXCERCISE_KEY];
    [aCoder encodeObject:self.clubsExerciseString forKey:CLUBS_EXCERCISE_KEY];
    [aCoder encodeObject:self.heartsExerciseString forKey:HEARTS_EXCERCISE_KEY];
    [aCoder encodeObject:self.diamondsExerciseString forKey:DIAMONDS_EXCERCISE_KEY];
    [aCoder encodeObject:self.acesExerciseString forKey:ACES_EXERCISE_KEY];
    [aCoder encodeObject:self.jokersExerciseString forKey:JOKERS_EXERCISE_KEY];
    
    [aCoder encodeInteger:self.jacksPoints forKey:JACKS_POINTS_KEY];
    [aCoder encodeInteger:self.queensPoints forKey:QUEENS_POINTS_KEY];
    [aCoder encodeInteger:self.kingsPoints forKey:KINGS_POINTS_KEY];
    [aCoder encodeInteger:self.acesPoints forKey:ACES_POINTS_KEY];
    [aCoder encodeInteger:self.jokersPoints forKey:JOKERS_POINTS_KEY];
}

//Used by NSCoder to decode this object using NSKeyedUnarchiver. It is important to note here that this object is decoded as the shared playing card settings and will not create a new object.
- (id)initWithCoder:(NSCoder *)aDecoder {
    
//    PlayingCardSettings *self = [PlayingCardSettings sharedPlayingCardSettings];
    
    self.save = [aDecoder decodeBoolForKey:@"Save"];
    self.spadesExerciseString = [aDecoder decodeObjectForKey:SPADES_EXCERCISE_KEY];
    self.clubsExerciseString = [aDecoder decodeObjectForKey:CLUBS_EXCERCISE_KEY];
    self.heartsExerciseString = [aDecoder decodeObjectForKey:HEARTS_EXCERCISE_KEY];
    self.diamondsExerciseString = [aDecoder decodeObjectForKey:DIAMONDS_EXCERCISE_KEY];
    self.acesExerciseString = [aDecoder decodeObjectForKey:ACES_EXERCISE_KEY];
    self.jokersExerciseString = [aDecoder decodeObjectForKey:JOKERS_EXERCISE_KEY];
    
    self.jacksPoints = [aDecoder decodeIntegerForKey:JACKS_POINTS_KEY];
    self.queensPoints = [aDecoder decodeIntegerForKey:QUEENS_POINTS_KEY];
    self.kingsPoints = [aDecoder decodeIntegerForKey:KINGS_POINTS_KEY];
    self.acesPoints = [aDecoder decodeIntegerForKey:ACES_POINTS_KEY];
    self.jokersPoints = [aDecoder decodeIntegerForKey:JOKERS_POINTS_KEY];
    
    return self;
}

#pragma mark - Settings

//Data holds an array of sections
- (NSArray *)data {
    return @[[self defaults], [self options], [self suits], [self cards]];
}

//Sections array holds the names of the sections
- (NSArray *)sectionsArray {
    return @[@"Defaults", @"Options", @"Suits", @"Cards"];
}

#pragma mark - Section Arrays

//Array holding dictionaries for the different suits;
- (NSArray *)suits {
    return @[[self spade], [self club], [self heart], [self diamond]];
}

//Array holding dictionaries for the different cards. If there are not jokers it will not show this in the data.
- (NSArray *)cards {
    if (self.jokers) {
        return @[[self ace], [self joker]];
    } else {
        return @[[self ace]];
    }
}

//Array holding dictionaries for cells as buttons
- (NSArray *)defaults {
    return @[[self defaultButtons]];
}

//Array holding dictionaries for cells with switches
- (NSArray *)options {
    return @[[self jokerOption]];
}

#pragma mark - Row SettingsCells

//SettingsCell for our default button
- (SettingsCell *)defaultButtons {
    SettingsCell *cell = [[SettingsCell alloc] init];
    cell.title = DEFAULTS;
    cell.cellIdentifier = CELL_3;
    return cell;
}

//SettingsCell for our spade suit
- (SettingsCell *)spade {
    SettingsCell *cell = [[SettingsCell alloc] init];
    cell.title = SPADE;
    cell.cellIdentifier = CELL_1;
    cell.detailDescription = EXERCISE;
    cell.detailSettingsCells = [self createSettingsCellsArrayForKey:SPADE];
    cell.footerInstrucions = FOOTER_INSTRUCTIONS_1;
    return cell;
}

//SettingsCell for our club suit
- (SettingsCell *)club {
    SettingsCell *cell = [[SettingsCell alloc] init];    cell.title = CLUB;
    cell.cellIdentifier = CELL_1;
    cell.detailDescription = EXERCISE;
    cell.detailSettingsCells = [self createSettingsCellsArrayForKey:CLUB];
    cell.footerInstrucions = FOOTER_INSTRUCTIONS_1;
    return cell;
}

//SettingsCell for our heart suit
- (SettingsCell *)heart {
    SettingsCell *cell = [[SettingsCell alloc] init];
    cell.title = HEART;
    cell.cellIdentifier = CELL_1;
    cell.detailDescription = EXERCISE;
    cell.detailSettingsCells = [self createSettingsCellsArrayForKey:HEART];
    cell.footerInstrucions = FOOTER_INSTRUCTIONS_1;
    return cell;
}

//SettingsCell for our diamond suit
- (SettingsCell *)diamond {
    SettingsCell *cell = [[SettingsCell alloc] init];
    cell.title = DIAMOND;
    cell.cellIdentifier = CELL_1;
    cell.detailDescription = EXERCISE;
    cell.detailSettingsCells = [self createSettingsCellsArrayForKey:DIAMOND];
    cell.footerInstrucions = FOOTER_INSTRUCTIONS_1;
    return cell;
}

//SettingsCell for our ace card
- (SettingsCell *)ace {
    SettingsCell *cell = [[SettingsCell alloc] init];
    cell.title = ACE;
    cell.cellIdentifier = CELL_1;
    cell.detailDescription = EXERCISE_AND_POINTS;
    cell.detailSettingsCells = [self createSettingsCellsArrayForKey:ACE];
    cell.footerInstrucions = FOOTER_INSTRUCTIONS_2;
    return cell;
}

//SettingsCell for our joker card
- (SettingsCell *)joker {
    SettingsCell *cell = [[SettingsCell alloc] init];
    cell.title = JOKER;
    cell.cellIdentifier = CELL_1;
    cell.detailDescription = EXERCISE_AND_POINTS;
    cell.detailSettingsCells = [self createSettingsCellsArrayForKey:JOKER];
    cell.footerInstrucions = FOOTER_INSTRUCTIONS_2;
    return cell;
}

//SettingsCell for our cell containing switch giving option of whether our cards will have jokers or not
- (SettingsCell *)jokerOption {
    SettingsCell *cell = [[SettingsCell alloc] init];
    cell.title = JOKERS_OPTIONS;
    cell.cellIdentifier = CELL_2;
    cell.cellBool = self.jokers;
    return cell;
}

#pragma mark - Exercises Properties

//Setters and Getters written for all exercies properties
@synthesize spadesExerciseString = _spadesExerciseString;
@synthesize clubsExerciseString = _clubsExerciseString;
@synthesize heartsExerciseString = _heartsExerciseString;
@synthesize diamondsExerciseString = _diamondsExerciseString;
@synthesize acesExerciseString = _acesExerciseString;
@synthesize jokersExerciseString = _jokersExerciseString;

- (NSString *)spadesExerciseString { //Returns exercise for spades or a default value.
    if (self.save) {
        return [self valueForKey:SPADES_EXCERCISE_KEY withDefaultString:@"Push-Ups"];
    } else {
        return _spadesExerciseString ? _spadesExerciseString : @"?";
    }
}

- (NSString *)clubsExerciseString { //Returns exercise for clubs or a default value.
    if (self.save) {
        return [self valueForKey:CLUBS_EXCERCISE_KEY withDefaultString:@"Sit-Ups"];
    } else {
        return _clubsExerciseString ? _clubsExerciseString : @"?";
    }
}

- (NSString *)heartsExerciseString { //Returns exercise for hearts or a default value.
    if (self.save) {
        return [self valueForKey:HEARTS_EXCERCISE_KEY withDefaultString:@"Lunges"];
    } else {
        return _heartsExerciseString ? _heartsExerciseString : @"?";
    }
}

- (NSString *)diamondsExerciseString { //Returns exercise for diamonds or a default value.
    if (self.save) {
        return [self valueForKey:DIAMONDS_EXCERCISE_KEY withDefaultString:@"Squats"];
    } else {
        return _diamondsExerciseString ? _diamondsExerciseString : @"?";
    }
}

- (NSString *)acesExerciseString { //Returns exercise for aces or a default value.
    if (self.save) {
        return [self valueForKey:ACES_EXERCISE_KEY withDefaultString:@"25 Jump Rope"];
    } else {
        return _acesExerciseString ? _acesExerciseString : @"?";
    }
}

- (NSString *)jokersExerciseString { //Returns exercise for jokers or a default value.
    if (self.save) {
        return [self valueForKey:JOKERS_EXERCISE_KEY withDefaultString:@"20 Burpees"];
    } else {
        return _jokersExerciseString ? _jokersExerciseString : @"?";
    }
}

- (void)setSpadesExerciseString:(NSString *)spadesExerciseString { //Sets exercise for spades in NSUserdefaults.
    if (self.save) {
        [self setStringValue:spadesExerciseString forKey:SPADES_EXCERCISE_KEY];
    } else {
        _spadesExerciseString = spadesExerciseString;
    }
}

- (void)setClubsExerciseString:(NSString *)clubsExerciseString { //Sets exercise for clubs in NSUserdefaults.
    if (self.save) {
        [self setStringValue:clubsExerciseString forKey:CLUBS_EXCERCISE_KEY];
    } else {
        _clubsExerciseString = clubsExerciseString;
    }
}

- (void)setHeartsExerciseString:(NSString *)heartsExerciseString { //Sets exercise for hearts in NSUserdefaults.
    if (self.save) {
        [self setStringValue:heartsExerciseString forKey:HEARTS_EXCERCISE_KEY];
    } else {
        _heartsExerciseString = heartsExerciseString;
    }
}

- (void)setDiamondsExerciseString:(NSString *)diamondsExerciseString { //Sets exercise for diamonds in NSUserdefaults.
    if (self.save) {
        [self setStringValue:diamondsExerciseString forKey:DIAMONDS_EXCERCISE_KEY];
    } else {
        _diamondsExerciseString = diamondsExerciseString;
    }
}

- (void)setAcesExerciseString:(NSString *)acesExerciseString { //Sets exercise for aces in NSUserdefaults.
    if (self.save) {
        [self setStringValue:acesExerciseString forKey:ACES_EXERCISE_KEY];
    } else {
        _acesExerciseString = acesExerciseString;
    }
}

- (void)setJokersExerciseString:(NSString *)jokersExerciseString { //Sets exercise for jokers in NSUserdefaults.
    if (self.save) {
        [self setStringValue:jokersExerciseString forKey:JOKERS_EXERCISE_KEY];
    } else {
        _jokersExerciseString = jokersExerciseString;
    }
}

#pragma mark - Points Properties

//Setters and Getters written for all points properties
@synthesize jacksPoints = _jacksPoints;
@synthesize queensPoints = _queensPoints;
@synthesize kingsPoints = _kingsPoints;
@synthesize acesPoints = _acesPoints;
@synthesize jokersPoints = _jokersPoints;

- (NSUInteger)jacksPoints { //Returns integer value for jacks points or default value.
    if (self.save) {
        return [self valueForKey:JACKS_POINTS_KEY withDefaultValue:12];
    } else {
        return _jacksPoints;
    }
}

- (NSUInteger)queensPoints { //Returns integer value for queens points or default value.
    if (self.save) {
        return [self valueForKey:QUEENS_POINTS_KEY withDefaultValue:15];
    } else {
        return _queensPoints;
    }
}

- (NSUInteger)kingsPoints { //Returns integer value for kings points or default value.
    if (self.save) {
        return [self valueForKey:KINGS_POINTS_KEY withDefaultValue:20];
    } else {
        return _kingsPoints;
    }
}

- (NSUInteger)acesPoints { //Returns integer value for aces points or default value.
    if (self.save) {
        return [self valueForKey:ACES_POINTS_KEY withDefaultValue:25];
    } else {
        return _acesPoints;
    }
}

- (NSUInteger)jokersPoints { //Returns integer value for jokers points or default value.
    if (self.save) {
        return [self valueForKey:JOKERS_POINTS_KEY withDefaultValue:50];
    } else {
        return _jokersPoints;
    }
}

- (void)setJacksPoints:(NSUInteger)jacksPoints { //Sets integer value for jacks reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:jacksPoints forKey:JACKS_POINTS_KEY];
    } else {
        _jacksPoints = jacksPoints;
    }
}

- (void)setQueensPoints:(NSUInteger)queensPoints { //Sets integer value for queens reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:queensPoints forKey:QUEENS_POINTS_KEY];
    } else {
        _queensPoints = queensPoints;
    }
}

- (void)setKingsPoints:(NSUInteger)kingsPoints { //Sets integer value for kings reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:kingsPoints forKey:KINGS_POINTS_KEY];
    } else {
        _kingsPoints = kingsPoints;
    }
}

- (void)setAcesPoints:(NSUInteger)acesPoints { //Sets integer value for aces reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:acesPoints forKey:ACES_POINTS_KEY];
    } else {
        _acesPoints = acesPoints;
    }
}

- (void)setJokersPoints:(NSUInteger)jokersPoints { //Sets integer value for jokers reps in NSUserdefaults.
    if (self.save) {
        [self setNSUIntegerValue:jokersPoints forKey:JOKERS_POINTS_KEY];
    } else {
        _jokersPoints = jokersPoints;
    }
}

#pragma mark - Boolean Properties

- (BOOL)jokers { //Returns a boolean value for whether or not a game should have jokers used.
    NSUInteger number = [self valueForKey:JOKERS_BOOLEAN_KEY withDefaultValue:[[NSNumber numberWithBool:YES] integerValue]];
    return [[NSNumber numberWithInteger:number] boolValue];
}

- (void)setJokers:(BOOL)jokers { //Sets a boolean value for whether or not a game should have jokers in NSUserdefaults.
    NSNumber *number = [NSNumber numberWithBool:jokers];
    [self setNSUIntegerValue:[number integerValue] forKey:JOKERS_BOOLEAN_KEY];
}

#pragma mark Abstract Methods

//Stores the settings for a settingsCell
- (void)storeNewSettings:(SettingsCell *)settings { //Abstract
    NSString *title = settings.title;
    
    if ([title isEqualToString:SPADE]) {
        self.spadesExerciseString = [settings.detailSettingsCells[0] value];
    } else if ([title isEqualToString:CLUB]) {
        self.clubsExerciseString = [settings.detailSettingsCells[0] value];
    } else if ([title isEqualToString:HEART]) {
        self.heartsExerciseString = [settings.detailSettingsCells[0] value];
    } else if ([title isEqualToString:DIAMOND]) {
        self.diamondsExerciseString = [settings.detailSettingsCells[0] value];
    } else if ([title isEqualToString:ACE]) {
        self.acesPoints = [[settings.detailSettingsCells[0] value] integerValue];
        self.acesExerciseString = [settings.detailSettingsCells[1] value];
    } else if ([title isEqualToString:JOKER]) {
        self.jokersPoints = [[settings.detailSettingsCells[0] value] integerValue];
        self.jokersExerciseString = [settings.detailSettingsCells[1] value];
    } else {
        NSLog(@"Error No Setting");
    }
}

//Communicates whether a switch has been changed or not
- (void)switchChanged:(BOOL)on { //Abstract
    self.jokers = on;
}

#define MAX_NUMBER_VALUE 1000
#define MINIMUM_STRING_LENGTH 15

//Returns an alert string for a given key
- (NSString *)alertLabelForString:(NSString *)string forKey:(NSString *)key { //Abstract
    if ([string isEqualToString:@""]) { //If no entry then alert
        return @"Entry Required";
    } else {
        if ([key isEqualToString:POINTS]) { //Check to see if number values only
            if ([string integerValue] >= MAX_NUMBER_VALUE) { //Check against max value
                return [NSString stringWithFormat:@"Value Must Be Less Than %d", MAX_NUMBER_VALUE];
            } else if ([string integerValue] <= 0) {
                    return @"Reps Must be Greater Than 0";
            } else {
                return nil;
            }
        } else { //If not a number value then must be a string
            if ([string length] > MINIMUM_STRING_LENGTH) { //Check the string length
                return [NSString stringWithFormat:@"Exercise Must Contain Less Than %d Characters", MINIMUM_STRING_LENGTH];
            } else {
                return nil;
            }
        }
    }
}

//Returns a label for a given suit and rank
- (NSString *)labelForSuit:(NSUInteger)suit andRank:(NSUInteger)rank { //Abstract
    NSString *rankKey = [self keyForRank:rank];
    NSString *suitKey = [self keyForSuit:suit];
    
    if (rank < 2 || rank > 13) {
        return [self labelForKey:rankKey];
    } else if (rank > 10) {
        return [NSString stringWithFormat:@"%@ %@", [self labelForKey:rankKey], [self labelForKey:suitKey]];
    } else {
        return [NSString stringWithFormat:@"%ld %@", rank, [self labelForKey:suitKey]];
    }
}

//Returns the points for a specific rank
- (NSUInteger)pointsForRank:(NSUInteger)rank { //Abstract
    NSString *key = [self keyForRank:rank];
    if (key) {
        return [self pointsForKey:key];
    } else {
        return rank;
    }
}

#pragma mark - Helper Methods

//Returns the points for a specific Key
- (NSUInteger)pointsForKey:(NSString *)key {
    if ([key isEqualToString: ACE]) {
        return self.acesPoints;
    } else if ([key isEqualToString:JACK]) {
        return self.jacksPoints;
    } else if ([key isEqualToString:QUEEN]) {
        return self.queensPoints;
    } else if ([key isEqualToString:KING]) {
        return self.kingsPoints;
    } else if ([key isEqualToString:JOKER]) {
        return self.jokersPoints;
    } else {
        return 0;
    }
}

//Creates detailSettingsCells array for a give key
- (NSArray *)createSettingsCellsArrayForKey:(NSString *)key {
    //Create Mutable Array
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    //Get values
    NSString *exercise = [self labelForKey:key];
    NSUInteger points = [self pointsForKey:key];
    
    //If there is a points value create and add new SettingsCell
    if (points) {
        SettingsCell *pointsCell = [[SettingsCell alloc] init];
        pointsCell.title = POINTS;
        pointsCell.cellIdentifier = CELL_1;
        pointsCell.value = [NSString stringWithFormat:@"%ld", points];
        pointsCell.cellBool = YES;
        [array addObject:pointsCell];
    }
    
    //If there is an exercise value create and add a new SettingsCell
    if (exercise) {
        SettingsCell *exerciseCell = [[SettingsCell alloc] init];
        exerciseCell.title = EXERCISE;
        exerciseCell.cellIdentifier = CELL_1;
        exerciseCell.value = exercise;
        exerciseCell.cellBool = NO;
        [array addObject:exerciseCell];
    }
    
    return array;
}

//Returns a card label for a given dictionary key
- (NSString *)labelForKey:(NSString *)key {
    NSString *label = [self exerciseForKey:key];
    if (label) {
        return label;
    } else {
        return [NSString stringWithFormat:@"%ld", [self pointsForKey:key]];
    }
}

//Returns the exercise for a specific Key
- (NSString *)exerciseForKey:(NSString *)key {
    if ([key isEqualToString:SPADE]) {
        return self.spadesExerciseString;
    } else if ([key isEqualToString:CLUB]) {
        return self.clubsExerciseString;
    } else if ([key isEqualToString:HEART]) {
        return self.heartsExerciseString;
    } else if ([key isEqualToString:DIAMOND]) {
        return self.diamondsExerciseString;
    } else if ([key isEqualToString:ACE]) {
        return self.acesExerciseString;
    } else if ([key isEqualToString:JOKER]) {
        return self.jokersExerciseString;
    } else {
        return nil;
    }
}

//Returns a label string for a rank
- (NSString *)keyForRank:(NSUInteger)rank {
    if (rank == 1) {
        return ACE;
    } else if(rank == 11) {
        return JACK;
    } else if (rank == 12) {
        return QUEEN;
    } else if (rank == 13) {
        return KING;
    } else if (rank == 14) {
        return JOKER;
    } else {
        return nil;
    }
}

//Returns a label string for a suit
- (NSString *)keyForSuit:(NSUInteger)suit {
    if (suit == 0) {
        return SPADE;
    } else if (suit == 1) {
        return HEART;
    } else if (suit == 2) {
        return CLUB;
    } else if (suit == 3) {
        return DIAMOND;
    } else {
        return @"";
    }
}

@end
