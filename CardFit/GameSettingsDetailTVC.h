//
//  GameSettingsDetailTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#define CELL_KEY @"Cell"
#define CELL_1 @"Cell1"
#define CELL_2 @"Cell2"
#define CELL_3 @"Cell3"

#define CELL_BOOL_KEY @"Bool Key"

#define TEXTLABEL_TITLE_KEY @"Title"
#define TEXTLABEL_DESCRIPTION_KEY @"Label Description"

#define CARD_LABEL @"Card Label"

#import <UIKit/UIKit.h>

@protocol GameSettingsDelegate <NSObject>

@required
- (void)settingsChanged:(NSDictionary *)dictionary;

@end

@interface GameSettingsDetailTVC : UITableViewController

@property (nonatomic, weak) id<GameSettingsDelegate> delegate;
@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) NSArray *numbers;
@property (nonatomic, strong) NSArray *values;

//- (void)createSettings; //Abstract

@end
