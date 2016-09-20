//
//  MainPageViewController.h
//  CardFit
//
//  Created by Braden Gray on 4/10/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameDataController.h"

@interface MainPageViewController : UIViewController

- (GameDataController *)createDataSource; //Abstract

@end
