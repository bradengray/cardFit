//
//  NumOfCardsPopoverContentTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/12/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberOfCardsDelegate <NSObject>

@required
-(void)selectedNumberOfCards:(NSString *)numberOfCards;
@end

@interface NumOfCardsPopoverContentTVC : UITableViewController

@property (nonatomic, strong) NSArray *numberOfCardsSelections;
@property (nonatomic, weak) id<NumberOfCardsDelegate> delegate;

@end
