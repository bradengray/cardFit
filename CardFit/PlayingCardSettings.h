//
//  Settings.h
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"
//#import "CardFitPlayingCard.h"

@interface PlayingCardSettings : Settings <NSCoding>

+(instancetype)sharedPlayingCardSettings;

//Strings that hold the names of the exercies for the listed suits and ranks.
@property (nonatomic, strong) NSString *spadesExerciseString;
@property (nonatomic, strong) NSString *clubsExerciseString;
@property (nonatomic, strong) NSString *heartsExerciseString;
@property (nonatomic, strong) NSString *diamondsExerciseString;
@property (nonatomic, strong) NSString *acesExerciseString;
@property (nonatomic, strong) NSString *jokersExerciseString;

//Integers that hold the number of reps for the listed ranks. All cards numbered 2-10 have a rep value equal to the rank.
@property (nonatomic) NSUInteger jacksReps;
@property (nonatomic) NSUInteger queensReps;
@property (nonatomic) NSUInteger kingsReps;
@property (nonatomic) NSUInteger acesReps;
@property (nonatomic) NSUInteger jokersReps;

//Integers that hold the number of points for the listed ranks. All Cards numbered 2-10 have a point value equal to rank.
@property (nonatomic) NSUInteger jacksPoints;
@property (nonatomic) NSUInteger queensPoints;
@property (nonatomic) NSUInteger kingsPoints;
@property (nonatomic) NSUInteger acesPoints;
@property (nonatomic) NSUInteger jokersPoints;

//Bool for whether or not deck should have jokers;
@property (nonatomic) BOOL jokers;

@end
