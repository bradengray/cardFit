//
//  Timer.h
//  CardFit
//
//  Created by Braden Gray on 5/8/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timer : NSObject

@property (nonatomic) BOOL active; //Activates timer and deactivates timers "aka" pauses timer.
@property (nonatomic, readonly) float timeElapsed; //keeps up with total active time elapsed for the life of the timer.
@property (nonatomic, readonly) NSString *timeFormattedForHourMinuteSecondsMiliseconds; //formats the time into HH:MM:SS:MS.

@end
