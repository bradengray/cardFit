//
//  Settings.m
//  CardFit
//
//  Created by Braden Gray on 9/13/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Settings.h"

#define NSUSERDEFAULTS_SETTINGS_KEY @"NSUserDefaults Settings Key"

@implementation Settings

NSString *const SettingsChangedInModel = @"Settings Changed In Model"; //Define global

#pragma mark - Radio Station

//Post Notification that settings Changed
- (void)settingChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:SettingsChangedInModel object:nil];
}

#pragma mark - NSUserDefaults Methods

//Save dictionary to NSUserDefaults
- (void)save:(NSDictionary *)dict {
    if (dict) {
        NSArray *allKeys = [dict allKeys];
        NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] objectForKey:NSUSERDEFAULTS_SETTINGS_KEY] mutableCopy];
        if (!settings) {
            settings = [[NSMutableDictionary alloc] init];
        }
        for (NSString *key in allKeys) {
            NSLog(@"Inside SettingsKey:%@", settings[key]);
            settings[key] = [dict objectForKey:key];
        }
        [[NSUserDefaults standardUserDefaults] setObject:settings forKey:NSUSERDEFAULTS_SETTINGS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//Resets all NSUserDefaults
+ (void)resetAllUserDefaults {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSNotificationCenter defaultCenter] postNotificationName:SettingsChangedInModel object:nil];
}

#pragma mark - Setters and Getters

//Sets given value for key
- (void)setSettingsValue:(id)value forKey:(NSString *)key { //Abstract
    return;
}

//Returns value for given key
- (id)getValueForKey:(NSString *)key { //abstract
    return [self.values objectForKey:key];
}

- (NSString *)valueForKey:(NSString *)key withDefaultString:(NSString *)defaultString { //Returns a value for the Key in NSUserDefaults or returns the default
    
    //Check to see if dictionary exists in NSUserdefaults
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] objectForKey:NSUSERDEFAULTS_SETTINGS_KEY] mutableCopy];
    //If settings doesn't exist return default
    if (!settings) {
        return defaultString;
    }
    //If settings dictionary does contain the key provided return the default value.
    if (![[settings allKeys] containsObject:key]) {
        return defaultString;
    }
    //If a value exists for the Key in the setting dictionary return that value.
    NSLog(@"Settingkey:%@", settings[key]);
    return settings[key];
}

- (NSUInteger)valueForKey:(NSString *)key withDefaultValue:(NSUInteger)defaultValue { //Returns a value for the Key in NSUserDefaults or returns the default
    
    //Check to see if dictionary exists in NSUserdefaults
    NSMutableDictionary *settings = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:NSUSERDEFAULTS_SETTINGS_KEY] mutableCopy];
    //If settings doesn't exist return default
    if (!settings) {
        return defaultValue;
    }
    //If settings dictionary does contain the key provided return the default value.
    if (![[settings allKeys] containsObject:key]) {
        return defaultValue;
    }
    //If a value exists for the Key in the setting dictionary return that value.
    return [settings[key] longValue];
}

#pragma mark - NSCoding

//Used by NSCoder to encode this object using NSKeyedArchiver
- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSArray *allKeys = [self.values allKeys];
    
    for (NSString *key in allKeys) {
        NSObject *obj = [self.values objectForKey:key];
        [aCoder encodeObject:obj forKey:key];
    }
}

//Used by NSCoder to decode this object using NSKeyedUnarchiver.
- (id)initWithCoder:(NSCoder *)aDecoder {
    NSArray *allKeys = [self.values allKeys];
    
    for (NSString *key in allKeys) {
        NSObject *obj = [aDecoder decodeObjectForKey:key];
        [self setValue:obj forKey:key];
    }
    
    return self;
}

@end
