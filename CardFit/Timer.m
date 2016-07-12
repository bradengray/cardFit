//
//  Timer.m
//  CardFit
//
//  Created by Braden Gray on 5/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Timer.h"

@interface Timer ()

@property (nonatomic, readwrite) float timeElapsed; //Keeps total active time elapsed for life of timer.
@property (nonatomic, strong) NSDate *start; //Start Date for Timer.
@property (nonatomic, strong) NSDate *end; //End Date for Timer.
@property (nonatomic, readwrite) NSString *timeFormattedForHourMinuteSeconds; //formats time into HH:MM:SS:MS
@property (nonatomic, strong) NSNumber *totalTime; // Keeps track of active time. Needed because timer restarts from new date everytimer activated.

@end

@implementation Timer

- (void)setActive:(BOOL)active { //Sets timer active
    
    _active = active;
    //If active the get a start date.
    if (active == YES) {
        self.start = [NSDate date];
    //If not active then get an end date and set self.timeElapsed.
    } else if (active == NO) {
        self.end = [NSDate date];
        self.totalTime = [NSNumber numberWithFloat:self.timeElapsed];
    //If not then there is an error.
    } else {
        NSLog(@"Error in Timer.m setActive");
    }
}

- (float)timeElapsed { //Keeps track of active time elapsed for life of timer.
    
    //If there is not a start date then the timeElapsed is equal 0.0.
    if (!self.start) {
        _timeElapsed = 0.0;
    //If there is a start date and timer is active the set timeElapsed since active plust total time.
    } else if (self.active) {
        _timeElapsed = [[NSDate date] timeIntervalSinceDate:self.start] + [self.totalTime floatValue];
    } 
    return _timeElapsed;
}

- (NSString *)timeFormattedForHourMinuteSecondsMiliseconds { //Fromate time into HH:MM:SS:MS
    //round self.timeElapsed.
    int time = floorf(self.timeElapsed);
    //calculate miliseconds
    int miliseconds = (self.timeElapsed - time) *100;
    // calculate seconds.
    int seconds = time % 60;
    //calculate minutes.
    int minutes = (time / 60) % 60;
    //calcultate hours.
    int hours = time / 3600;
    
    //Set string equal to Error just in case something goes wrong.
    NSString *formattedString = @"Error";
    
    //Calculate the format of the string based on how much time has elapsed.
    if (hours > 0) {
        formattedString = [NSString stringWithFormat:@"%02d:%02d:%02d:%02d", hours, minutes, seconds, miliseconds];
    } else if (minutes > 0) {
        formattedString = [NSString stringWithFormat:@"%02d:%02d:%02d", minutes, seconds, miliseconds];
    } else if (seconds > 0) {
        formattedString = [NSString stringWithFormat:@"%02d:%02d", seconds, miliseconds];
    } else {
        formattedString = [NSString stringWithFormat:@"0:%02d", miliseconds];
    }
    
    //Return formatted String.
    return formattedString;
}

@end
