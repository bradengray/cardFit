//
//  ContainerView.m
//  CardFit
//
//  Created by Braden Gray on 4/7/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardFitLayoutView.h"

@interface CardFitLayoutView ()

@property (nonatomic) BOOL resolved;
@property (nonatomic) BOOL unresolvable;
@property (nonatomic, readwrite) CGSize subViewSize;

@end

@implementation CardFitLayoutView

#define SUBVIEW_HEIGHT_SCALE_PERCENTAGE .900
#define MINIMUM_VOFFSET 20

- (CGFloat)subViewScaledHeight {
    return ((self.size.height * SUBVIEW_HEIGHT_SCALE_PERCENTAGE) - MINIMUM_VOFFSET);
}

- (void)validate
{
    if (self.resolved) return;    // already valid, nothing to do
    if (self.unresolvable) return;  // already tried to validate and couldn't
    
    double overallWidth = ABS(self.size.width);
    double overallHeight = ABS(self.size.height);
    double aspectRatio = ABS(self.aspectRatio);
    
    if (!aspectRatio || !overallWidth || !overallHeight) {
        self.unresolvable = YES;
        return; // invalid inputs
    }
    
    double maxWidth = self.maxSubViewWidth;
    double maxHeight = self.maxSubViewHeight;
    double minWidth = self.minSubViewWidth;
    double minHeight = self.minSubViewHeight;
    
//    BOOL flipped = NO;
    if (self.rotated) {
        self.rotated = YES;
        overallHeight = ABS(self.size.width);
        overallWidth = ABS(self.size.height);
//        aspectRatio = 1.0/aspectRatio;
        maxWidth = self.maxSubViewHeight;
        maxHeight = self.maxSubViewWidth;
    }
    
    if (minWidth < 0) {
        minWidth = 0;
    }
    if (minHeight < 0) {
        minHeight = 0;
    }
    
    double subViewHeight = overallHeight;
    if (subViewHeight > maxHeight) {
        subViewHeight = maxHeight;
    }
    if (subViewHeight > [self subViewScaledHeight]) {
        subViewHeight = [self subViewScaledHeight];
    }
    if (subViewHeight <= minHeight) {
        self.unresolvable = YES;
    } else {
        double subViewWidth = subViewHeight * aspectRatio;
        if (subViewWidth > overallWidth) {
            subViewWidth = overallWidth;
            subViewHeight = subViewWidth / aspectRatio;
        }
        if (subViewWidth > maxWidth) {
            subViewWidth = maxWidth;
        }
        if (subViewWidth <= minWidth) {
            self.unresolvable = YES;
        } else {
            if (self.rotated) {
                self.subViewSize = CGSizeMake(subViewHeight, subViewWidth);
            } else {
                self.subViewSize = CGSizeMake(subViewWidth, subViewHeight);
            }
            self.resolved = YES;
        }
    }
}

- (CGFloat)hoffset {
    return (self.size.width - self.subViewSize.width) / 2.0;
}

- (CGFloat)voffset {
    if (self.subViewSize.height == self.maxSubViewHeight) {
        return (self.size.height - (self.subViewSize.height / SUBVIEW_HEIGHT_SCALE_PERCENTAGE)) / 2.0;
    } else {
        return MINIMUM_VOFFSET;
    }
}

- (CGAffineTransform)rotate {
    return CGAffineTransformMakeRotation(2 * M_PI);
}

- (CGAffineTransform)rotateLeft {
    return CGAffineTransformMakeRotation(-M_PI_2);
}

- (CGAffineTransform)rotateRight {
    return CGAffineTransformMakeRotation(M_PI_2);
}

- (CGRect)frameForCardView:(UIView *)cardView {
    cardView.transform = [self rotate];
    CGRect frame = CGRectMake([self hoffset], [self voffset], self.subViewSize.width, self.subViewSize.height);
    if (self.rotated) {
        if (self.landscapeLeft) {
            cardView.transform = [self rotateLeft];
//            frame = CGRectMake([self voffset], [self hoffset], self.subViewSize.height, self.subViewSize.width);
            frame = CGRectMake([self voffset] + self.size.height * (1 - self.subViewSize.height) / 2.0, [self hoffset], self.subViewSize.height, self.subViewSize.width - self.size.width * (1 - SUBVIEW_HEIGHT_SCALE_PERCENTAGE));
        } else {
            cardView.transform = [self rotateRight];
            frame = CGRectMake(([self voffset] - MINIMUM_VOFFSET) + self.size.height * (1 - SUBVIEW_HEIGHT_SCALE_PERCENTAGE), [self hoffset], self.subViewSize.height, self.subViewSize.width);
        }
    }
    return frame;
}

- (CGRect)frameForStartButton:(UIButton *)button {
    button.transform = [self rotate];
    CGRect frame = CGRectMake([self hoffset], [self voffset] + self.subViewSize.height, self.subViewSize.width, self.size.height * (1 -SUBVIEW_HEIGHT_SCALE_PERCENTAGE));
    if (self.rotated) {
        if (self.landscapeLeft) {
            button.transform = [self rotateLeft];
//            frame = CGRectMake([self voffset] + self.subViewSize.height, [self hoffset], self.size.height * (1 - SUBVIEW_HEIGHT_SCALE_PERCENTAGE), self.subViewSize.width);
            frame = CGRectMake(0, self.size.width - self.size.width * (1 - SUBVIEW_HEIGHT_SCALE_PERCENTAGE), self.size.width, self.subViewSize.height * (1 - SUBVIEW_HEIGHT_SCALE_PERCENTAGE));
        } else {
            button.transform = [self rotateRight];
            frame = CGRectMake([self voffset] - MINIMUM_VOFFSET, [self hoffset], self.size.height * (1 - SUBVIEW_HEIGHT_SCALE_PERCENTAGE), self.subViewSize.width);
        }
    }
    return frame;
}

- (CGRect)frameForTasklabel:(UILabel *)label {
//    label.transform = [self rotate];
    CGRect frame;
    if (self.rotated) {
        [self setLabel:label fontSizeForWidth:self.subViewSize.height];
        if (self.landscapeLeft) {
//            label.transform = [self rotateLeft];
//            frame = CGRectMake(([self hoffset] + self.subViewSize.height / 2.0) - label.attributedText.size.height / 2.0, [self hoffset], label.attributedText.size.height, self.subViewSize.width);
            frame = CGRectMake([self voffset], ([self hoffset] + self.subViewSize.width / 2.0) - label.attributedText.size.height / 2.0, self.subViewSize.height, label.attributedText.size.height);
        } else {
//            label.transform = [self rotateRight];
//            frame = CGRectMake((((self.size.height * (1 - SUBVIEW_HEIGHT_SCALE_PERCENTAGE)) + self.subViewSize.height / 2.0) + [self voffset]) - label.attributedText.size.height / 2.0, [self hoffset], label.attributedText.size.height, self.subViewSize.width);
            frame = CGRectMake(self.size.height * (1 - SUBVIEW_HEIGHT_SCALE_PERCENTAGE), ([self hoffset] + self.subViewSize.width / 2.0) - label.attributedText.size.height / 2.0, self.subViewSize.height, label.attributedText.size.height);
        }
    } else {
        [self setLabel:label fontSizeForWidth:self.subViewSize.width];
        frame = CGRectMake([self hoffset], ([self voffset] + self.subViewSize.height / 2.0) - label.attributedText.size.height / 2.0, self.subViewSize.width, label.attributedText.size.height);
    }
    return frame;
}

- (void)setLabel:(UILabel *)label fontSizeForWidth:(CGFloat)width {
    while (label.attributedText.size.width > width) {
        label.font = [label.font fontWithSize:label.font.pointSize - 1];
    }
}

- (void)setResolved:(BOOL)resolved {
    self.unresolvable = NO;
    _resolved = resolved;
}

- (void)setSize:(CGSize)size {
    if (!CGSizeEqualToSize(size, _size)) self.resolved = NO;
    _size = size;
}

- (void)setAspectRatio:(CGFloat)aspectRatio {
    if (ABS(aspectRatio) != ABS(_aspectRatio)) self.resolved = NO;
    _aspectRatio = aspectRatio;
}

- (void)setMaxSubViewWidth:(CGFloat)maxSubViewWidth {
    if (maxSubViewWidth != _maxSubViewWidth) self.resolved = NO;
    _maxSubViewWidth = maxSubViewWidth;
}

- (void)setMaxSubViewHeight:(CGFloat)maxSubViewHeight {
    if (maxSubViewHeight != _maxSubViewHeight) self.resolved = NO;
    _maxSubViewHeight = maxSubViewHeight;
}

- (CGSize)subViewSize
{
    [self validate];
    return _subViewSize;
}

@end
