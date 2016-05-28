//
//  GameSettingsTVC.h
//  CardFit
//
//  Created by Braden Gray on 5/19/16.
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

@interface GameSettingsTVC : UITableViewController

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *sectionsArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


- (void)switchChangedTo:(BOOL)on; //Abstract
- (void)storeNewSettingsDictionary:(NSDictionary *)dictionary; //Abstract
- (NSArray *)numbers; //Abstract
- (NSArray *)values; //Abstract
- (void)restoreDefaultDictionary; //Abstract

@end
