//
//  CardFitCard.h
//  CardFit
//
//  Created by Braden Gray on 6/11/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Card.h"

@interface CardFitCard : Card

@property (nonatomic, strong) NSString *label;
@property (nonatomic, readonly) NSUInteger points;

@end
