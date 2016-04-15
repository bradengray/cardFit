//
//  DefaultPlayingCard.h
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic) NSUInteger suit;
@property (nonatomic) NSUInteger rank;

+ (NSUInteger)maxRank;
+ (NSUInteger)maxSuit;

@end
