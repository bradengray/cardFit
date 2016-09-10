//
//  CardFitLayoutView.m
//  CardFit
//
//  Created by Braden Gray on 4/7/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Orientation.h"

@implementation Orientation

#pragma mark - Validation

#define MINIMUM_VOFFSET 15
#define MAX_HEIGHT 736.0

#pragma mark Properties

+ (BOOL)landscapeOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation != UIInterfaceOrientationPortrait) {
        //If landscape roated equals YES
        return YES;
    } else {
        //If portrait landscape equals NO
        return NO;
    }
}

@end
