//
//  ContainerView.h
//  CardFit
//
//  Created by Braden Gray on 4/7/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardFitLayoutView : UIView

//required
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat aspectRatio;

//optional
@property (nonatomic) CGFloat maxSubViewWidth;
@property (nonatomic) CGFloat maxSubViewHeight;
@property (nonatomic) CGFloat minSubViewWidth;
@property (nonatomic) CGFloat minSubViewHeight;
@property (nonatomic) BOOL rotated;
@property (nonatomic) BOOL landscapeLeft;

//outputs
@property (nonatomic, readonly) CGSize subViewSize;

//origin of Frame
- (CGRect)frameForCardView:(UIView *)cardView;
- (CGRect)frameForStartButton:(UIButton *)button;
- (CGRect)frameForTasklabel:(UILabel *)label;

@end
