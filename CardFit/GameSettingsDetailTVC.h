//
//  GameSettingsDetailTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/20/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#define PROTOTYPE_CELL_KEY @"Cell"
#define PROTOTYPE_CELL_1 @"Cell1"
#define PROTOTYPE_CELL_2 @"Cell2"
#define PROTOTYPE_CELL_3 @"Cell3"

#define PROTOTYPE_CELL_1_BOOL_KEY @"Cell1 Bool Key"
#define PROTOTYPE_CELL_2_BOOL_KEY @"Cell2 Bool Key"
#define PROTOTYPE_CELL_3_BOOL_KEY @"Cell3 Bool Key"

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

@end
