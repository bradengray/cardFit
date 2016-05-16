//
//  Card.h
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (nonatomic, strong) NSString *contents; //returns a string of the cards contents;
@property (nonatomic) BOOL selected; //bool value for telling if card is selected or not.

@end
