//
//  CardView.m
//  CardFit
//
//  Created by Braden Gray on 9/6/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardView.h"
#import "Orientation.h"

@implementation CardView

#define CENTER_X_CONSTRAINT_ID @"centerX"
#define CENTER_Y_CONSTRAINT_ID @"centerY"
#define WIDTH_CONSTRAINT_ID @"width"
#define HEIGHT_CONSTRAINT_ID @"height"

#define ASPECT_RATIO 0.5625
#define ASPECT_RATIO_2 0.4375
#define MAX_HEIGHT 736

#pragma mark - Initialization

- (void)didMoveToSuperview {
    if (self.superview) {
        [self setOrientation];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        centerX.identifier = CENTER_X_CONSTRAINT_ID;
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        centerY.identifier = CENTER_Y_CONSTRAINT_ID;
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:.5645 constant:0.0];
        width.identifier = WIDTH_CONSTRAINT_ID;
//        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[UIApplication sharedApplication].keyWindow.rootViewController.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
//        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeHeight multiplier:1.0 constant:[self viewHeightConstant]];
        height.identifier = HEIGHT_CONSTRAINT_ID;
        [self.superview addConstraints:@[centerX, centerY, width, height]];
    }
}

#pragma mark - Properties

- (CGFloat)viewHeightConstant {
    return [Orientation landscapeOrientation] ? self.superview.bounds.size.width * ASPECT_RATIO_2: 0;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.numberOfLines = 0;
        _centerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_centerLabel setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5]];
        _centerLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:_centerLabel];
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_centerLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        centerXConstraint.identifier = CENTER_X_CONSTRAINT_ID;
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_centerLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        centerYConstraint.identifier = CENTER_Y_CONSTRAINT_ID;
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_centerLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:[self viewHeightConstant]];
        widthConstraint.identifier = WIDTH_CONSTRAINT_ID;
        [self addConstraints:@[centerXConstraint, centerYConstraint, widthConstraint]];
    }
    return _centerLabel;
}

- (void)setNeedsUpdateConstraints {
    [self setOrientation];
    NSArray *constraints = self.superview.constraints;
    for (NSLayoutConstraint *constraint in constraints) {
        if ([constraint.identifier isEqualToString:HEIGHT_CONSTRAINT_ID]) {
            constraint.constant = [Orientation landscapeOrientation] ? [self viewHeightConstant] : 0.0;
        }
    }
    
    NSArray *labelConstraints = self.constraints;
    for (NSLayoutConstraint *constraint in labelConstraints) {
        if ([constraint.identifier isEqualToString:WIDTH_CONSTRAINT_ID]) {
            constraint.constant = [Orientation landscapeOrientation] ? [self viewHeightConstant] : 0.0;
        }
    }
}

- (CGAffineTransform)rotateLeft {
    return CGAffineTransformMakeRotation(M_PI_2);
}

- (CGAffineTransform)rotateRight {
    return CGAffineTransformMakeRotation(-M_PI_2);
}

- (CGAffineTransform)rotate {
    return CGAffineTransformMakeRotation(2 * M_PI);
}

- (void)setOrientation {
    if ([Orientation landscapeOrientation]) {
        self.transform = [self rotateLeft];
        self.centerLabel.transform = [self rotateRight];;
    } else {
        self.transform = [self rotate];
        self.centerLabel.transform = [self rotate];
    }
}

@end
