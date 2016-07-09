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

#define SUBVIEW_HEIGHT_SCALE_PERCENTAGE .120
#define MINIMUM_VOFFSET 40

- (CGFloat)subViewScaledHeight {
    return ((self.size.height * (1 - SUBVIEW_HEIGHT_SCALE_PERCENTAGE)) - MINIMUM_VOFFSET);
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
            self.subViewSize = CGSizeMake(subViewWidth, subViewHeight);
            self.resolved = YES;
        }
    }
}

- (CGSize)adjustedCardSize {
    if ([self defaultTotalHeightCardAndButton] > [self frameSize].height - MINIMUM_VOFFSET) {
        CGFloat sizeAdjustment = [self defaultTotalHeightCardAndButton] - ([self frameSize].height - MINIMUM_VOFFSET);
        return CGSizeMake([self defaultCardSize].width - sizeAdjustment, [self defaultCardSize].height - sizeAdjustment);
    } else {
        return CGSizeMake([self defaultCardSize].width, [self defaultCardSize].height);
    }
}

- (CGFloat)defaultTotalHeightCardAndButton {
    return [self defaultCardSize].height * (1 + SUBVIEW_HEIGHT_SCALE_PERCENTAGE);
}

- (CGFloat)adjustedTotalHeightCardAndButton {
    return [self adjustedCardSize].height * (1 + SUBVIEW_HEIGHT_SCALE_PERCENTAGE);
}

-(CGSize)frameSize {
    if (self.rotated) {
        return CGSizeMake(self.size.height, self.size.width);
    } else {
        return CGSizeMake(self.size.width, self.size.height);
    }
}

- (CGSize)defaultCardSize {
    if (self.rotated) {
        return CGSizeMake(self.subViewSize.height, self.subViewSize.width);
    } else {
        return CGSizeMake(self.subViewSize.width, self.subViewSize.height);
    }
}

- (CGFloat)voffset {
    CGFloat offset = ([self frameSize].height - [self adjustedTotalHeightCardAndButton]) / 2.0;
    if (offset < MINIMUM_VOFFSET) {
        offset = MINIMUM_VOFFSET;
    }
    return offset;
}

- (CGFloat)hoffset {
    return ([self frameSize].width - [self adjustedCardSize].width) / 2.0;
}

- (CGAffineTransform)rotate {
    return CGAffineTransformMakeRotation(2 * M_PI);
}

- (CGAffineTransform)rotateLeft {
    return CGAffineTransformMakeRotation(-M_PI_2);
}

- (CGRect)frameForCardView:(UIView *)cardView {
    cardView.transform = [self rotate];
    CGRect frame = CGRectMake([self hoffset], [self voffset], [self adjustedCardSize].width, [self adjustedCardSize].height);
    if (self.rotated) {
        cardView.transform = [self rotateLeft];
    }
    return frame;
}

- (CGRect)frameForStartButton:(UIButton *)button {
    button.transform = [self rotate];
    CGRect frame = CGRectMake([self hoffset], [self voffset] + [self adjustedCardSize].height, [self adjustedCardSize].width, [self adjustedCardSize].height * SUBVIEW_HEIGHT_SCALE_PERCENTAGE);
    return frame;
}

- (CGRect)frameForTasklabel:(UILabel *)label {
    [self setLabel:label fontSizeForWidth:self.subViewSize.width];
    CGRect frame = CGRectMake([self hoffset], ([self voffset] + [self adjustedCardSize].height / 2.0) - label.attributedText.size.height / 2.0, [self adjustedCardSize].width, label.attributedText.size.height);
    if (self.rotated) {
        [self setLabel:label fontSizeForWidth:self.subViewSize.height];
    }
    return frame;
}

- (CGRect)frameForTimerLabel:(UILabel *)label {
    CGRect frame = CGRectMake([self hoffset] + [self adjustedCardSize].width / 2.0 - label.attributedText.size.width / 2.0, [self voffset] + [self adjustedCardSize].height - label.attributedText.size.height, label.attributedText.size.width, label.attributedText.size.height);
//    [self setLabel:label fontSizeForWidth:self.subViewSize.height];
//    if (self.rotated) {
//        [self setLabel:label fontSizeForWidth:self.subViewSize.height];
//    }
    return frame;
}

- (void)setLabel:(UILabel *)label fontSizeForWidth:(CGFloat)width {
    if (label.attributedText.size.width > width) {
//        label.font = [label.font fontWithSize:label.font.pointSize - 1];
        label.numberOfLines = 2;
        NSRange range = NSMakeRange(0, 1);
        NSDictionary *attributes = [label.attributedText attributesAtIndex:0 effectiveRange:&range];
        NSArray *textArray = [label.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *textString = @"";
        int i = 0;
        for (NSString *string in textArray) {
            if (i > 0) {
                textString = [textString stringByAppendingString:[NSString stringWithFormat:@"%@ ", string]];
            } else {
                textString = [textString stringByAppendingString:[NSString stringWithFormat:@"%@\n", string]];
            }
            i++;
        }
        NSAttributedString *attributedTextString = [[NSAttributedString alloc] initWithString:textString attributes:attributes];
        label.attributedText = attributedTextString;
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
