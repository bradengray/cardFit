//
//  CardView.m
//  CardFit
//
//  Created by Braden Gray on 9/6/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardView.h"
#import "Orientation.h"

#define ASPECT_RATIO 0.5625
#define MAX_HEIGHT 736

@implementation CardView

#pragma mark - Properties

- (CGFloat)aspectRatio { //Lazy instantiation of aspect ratio
    if (!_aspectRatio) {
        _aspectRatio = ASPECT_RATIO;
    }
    return _aspectRatio;
}

#define CENTER_X_CONSTRAINT_ID @"centerX"
#define CENTER_Y_CONSTRAINT_ID @"centerY"
#define WIDTH_CONSTRAINT_ID @"width"
#define HEIGHT_CONSTRAINT_ID @"height"

#pragma mark - Initialization

- (void)didMoveToSuperview {
    [self setOrientation];
}

#pragma mark - Properties

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

- (CGFloat)viewHeightConstant {
    return [Orientation landscapeOrientation] ? self.bounds.size.width * (1 - ASPECT_RATIO): 0;
}

- (void)setNeedsUpdateConstraints {
    [self setOrientation];
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
