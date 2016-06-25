//
//  LayoutView.h
//  CardFit
//
//  Created by Braden Gray on 5/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayoutView : UIView

//required
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat aspectRatio;

//optional
@property (nonatomic) CGFloat maxSubViewWidth;
@property (nonatomic) CGFloat maxSubViewHeight;
@property (nonatomic) CGFloat minSubViewWidth;
@property (nonatomic) CGFloat minSubViewHeight;
@property (nonatomic) BOOL rotated;

//outputs
@property (nonatomic, readonly) CGSize subViewSize;

//origin of Frame
- (CGRect)frameForCardView:(UIView *)cardView;
//- (CGRect)frameForStartButton:(UIButton *)button;
- (CGRect)frameForTasklabel:(UILabel *)label;
- (CGRect)frameForTimerLabel:(UILabel *)label;

@end
