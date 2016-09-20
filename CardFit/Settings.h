//
//  Settings.h
//  CardFit
//
//  Created by Braden Gray on 9/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

//RadioStation
extern NSString *const SettingsChangedInModel; //Global for posting that data changed in Model
- (void)settingChanged; //Post Notification that Settings Changed

//Holds All Settings Values
//Required for NSCoding
@property (nonatomic, strong) NSDictionary *values;

//If yes it getValueForKey will return local values and if no getValueForKey will return NSUserDefaultValues. Useful if you want to use setting without saving them to defaults like a multiplayer game.
@property (nonatomic) BOOL getLocalValue;
//Tells whether multiplayer or not
@property (nonatomic) BOOL multiplayer;

//Handle NSUserDefaults
//Saves all values values as NSUserDefaults
- (void)save:(NSDictionary *)dict;
//Resets all values to original NSUserDefaults
+ (void)resetAllUserDefaults;

//Handle Values
//Sets given value for key
- (void)setSettingsValue:(id)value forKey:(NSString *)key; //Abstract
//Gets value for key
- (id)getValueForKey:(NSString *)key;

//Retrieve Values from NSUserDefaults
#warning make one method using id
- (NSString *)valueForKey:(NSString *)key withDefaultString:(NSString *)defaultString; //Abstract
- (NSUInteger)valueForKey:(NSString *)key withDefaultValue:(NSUInteger)defaultValue; //Abstract

@end
