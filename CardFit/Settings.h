//
//  Settings.h
//  CardFit
//
//  Created by Braden Gray on 4/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (nonatomic, strong) NSString *spadesExerciseString;
@property (nonatomic, strong) NSString *clubsExerciseString;
@property (nonatomic, strong) NSString *heartsExerciseString;
@property (nonatomic, strong) NSString *diamondsExerciseString;
@property (nonatomic, strong) NSString *acesExerciseString;
@property (nonatomic, strong) NSString *jokersExerciseString;
@property (nonatomic) NSUInteger jacksReps;
@property (nonatomic) NSUInteger queensReps;
@property (nonatomic) NSUInteger kingsReps;
@property (nonatomic) NSUInteger acesReps;
@property (nonatomic) NSUInteger jokersReps;

@end
