//
//  CardFitLayoutView.m
//  CardFit
//
//  Created by Braden Gray on 4/7/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardFitLayoutView.h"

@interface CardFitLayoutView ()

@property (nonatomic) BOOL resolved; //Bool value for whether card did fit in container view
@property (nonatomic, readwrite) CGSize subViewSize; //Writes to the size of the card

@end

@implementation CardFitLayoutView

#pragma mark - Validation

#define MINIMUM_VOFFSET 15
#define MAX_HEIGHT 736.0

- (void)validate { //Validates whether card will fit in container view
    
    if (self.resolved) return;    // already valid, nothing to do
    
    double overallHeight = ABS([self frameSizeForCard].height);
    double overallWidth = ABS([self frameSizeForCard].width);
    double aspectRatio = ABS(0.5625);
    
    if (overallHeight > MAX_HEIGHT) {
        overallHeight = MAX_HEIGHT;
    }
    overallWidth = overallHeight * aspectRatio;
    self.subViewSize = CGSizeMake(overallHeight * aspectRatio, overallHeight);

    self.resolved = YES;
}

- (CGSize)frameSizeForCard {
    if (self.rotated) {
        return CGSizeMake(self.size.height, self.size.width);
    } else {
        return CGSizeMake(self.size.width, self.size.height);
    }
}

#pragma mark - Frame Calculations

- (CGSize)cardSize { //Returns default card size for orientation
    if (self.rotated) {
        return CGSizeMake(self.subViewSize.height, self.subViewSize.width);
    } else {
        return CGSizeMake(self.subViewSize.width, self.subViewSize.height);
    }
}

- (CGFloat)voffset { //Calculates vertical offset for frames
    if ([self frameSizeForCard].height > [self cardSize].height) {
        return ([self frameSizeForCard].height - [self cardSize].height) / 2.0;
    } else {
        return MINIMUM_VOFFSET;
    }
}

- (CGFloat)hoffset { //Calculates horizontal offset for frames
    if ([self frameSizeForCard].width > [self cardSize].width) {
        return ([self frameSizeForCard].width - [self cardSize].width) / 2.0;
    } else {
        return 0;
    }
}

- (CGAffineTransform)rotate { //Rotates context 90 degrees back to portrait
    return CGAffineTransformMakeRotation(2 * M_PI);
}

- (CGAffineTransform)rotateLeft { //Rotates context 90 degrees for landscape
    return CGAffineTransformMakeRotation(-M_PI_2);
}

#pragma mark - Frames

- (CGRect)frameForCardView:(UIView *)cardView { //Returns frame of card view
    cardView.transform = [self rotate];
    CGRect frame = CGRectMake([self hoffset], [self voffset], [self cardSize].width, [self cardSize].height - MINIMUM_VOFFSET * 2);
    if (self.rotated) {
        cardView.transform = [self rotateLeft];
    }
    return frame;
}

#pragma mark Properties

- (void)setSize:(CGSize)size { //Sets size of container view
    if (!CGSizeEqualToSize(size, _size)) self.resolved = NO;
    _size = size;
}

- (CGSize)subViewSize { //Returns subview height and call validate
    [self validate];
    return _subViewSize;
}

@end
