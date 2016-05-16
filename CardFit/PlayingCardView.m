//
//  PlayingCardView.m
//  CardFit
//
//  Created by Braden Gray on 3/28/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView

#pragma mark - Properties

- (void)setSuit:(NSUInteger)suit {
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (NSString *)rankAsString {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"JOKER"] [self.rank];
}

- (NSString *)suitAsString {
    return @[@"♠️", @"♥️", @"♣️", @"♦️"] [self.suit];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 240.0
#define CORNER_RADIUS 30.0
#define FACE_CARD_IMAGE_SCALE_FACTOR 0.100

- (CGFloat)cornerScaleFactor {
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
    return CORNER_RADIUS / [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
    return [self cornerRadius] / 3.0;
}

- (void)drawRect:(CGRect)rect {
        
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    [roundedRect fill];
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.faceUp) {
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self rankAsString]]];
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * FACE_CARD_IMAGE_SCALE_FACTOR, self.bounds.size.height * FACE_CARD_IMAGE_SCALE_FACTOR);
            [faceImage drawInRect:imageRect];
        } else {
            [self drawPips];
        }
        [self drawCorners];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

- (void)drawCorners {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    NSAttributedString *cornterText = [[NSAttributedString alloc] initWithString:[self cornerTextString] attributes:@{NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [self fontColor]}];
    
    CGRect textbounds;
    textbounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textbounds.size = cornterText.size;
    [cornterText drawInRect:textbounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    [cornterText drawInRect:textbounds];
    [self popContext];
}

- (NSString *)cornerTextString {
    if (!(self.rank == 14)) {
        return [NSString stringWithFormat:@"%@\n%@", [self rankAsString], [self suitAsString]];
    } else {
        NSString *rankString = [self rankAsString];
        NSString *charachterString = @"";
        for (int i = 0; i < [rankString length]; i++) {
            charachterString = [charachterString stringByAppendingString:[NSString stringWithFormat:@"%@\n", [rankString substringWithRange:NSMakeRange(i, 1)]]];
        }
        return charachterString;
    }
}

- (UIColor *)fontColor {
    if (self.suit == 0 || self.suit == 2) {
        return [UIColor blackColor];
    } else {
        return [UIColor colorWithRed:.85 green:0 blue:0 alpha:1];
    }
}

#pragma mark - Draw Pips

#define PIP_HOFFSET_PERCENTAGE 0.200
#define PIP_VOFFSET1_PERCENTAGE 0.100
#define PIP_VOFFSET2_PERCENTAGE 0.150
#define PIP_VOFFSET3_PERCENTAGE 0.200
#define PIP_VOFFSET4_PERCENTAGE 0.300

- (void)drawPips {
    if (self.rank == 1 || self.rank == 3 || self.rank == 5 || self.rank == 9) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:0 mirroredVertically:NO];
    }
    if (self.rank == 6 || self.rank == 7) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:0 mirroredVertically:NO];
    }
    if (self.rank == 2 || self.rank == 3) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET4_PERCENTAGE mirroredVertically:YES];
    }
    if (self.rank == 10) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET3_PERCENTAGE mirroredVertically:YES];
    }
    if (self.rank == 7) {
        [self drawPipsWithHorizontalOffset:0 verticalOffset:PIP_VOFFSET2_PERCENTAGE mirroredVertically:NO];
    }
    if (self.rank == 4 || self.rank == 5 || self.rank == 6 || self.rank == 7 || self.rank == 8 || self.rank == 9 || self.rank == 10) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET4_PERCENTAGE mirroredVertically:YES];
    }
    if (self.rank == 8 || self.rank == 9 || self.rank == 10) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE verticalOffset:PIP_VOFFSET1_PERCENTAGE mirroredVertically:YES];
    }
}

#define PIP_FONT_SCALE_FACTOR 0.0085

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset mirroredVertically:(BOOL)mirroredVertically {
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset upsideDown:(BOOL)upsideDown {
    if (upsideDown) {
        [self pushContextAndRotateUpsideDown];
    }
    CGPoint middle = CGPointMake(self.bounds.size.width/2.0 - .5, self.bounds.size.height/2.0);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributesSuit = [[NSAttributedString alloc] initWithString:[self suitAsString] attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributesSuit size];
    CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width/2.0 - hoffset*self.bounds.size.width, middle.y - pipSize.height/2.0 - voffset*self.bounds.size.height);
    [attributesSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributesSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) {
        [self popContext];
    }
}

- (void)pushContextAndRotateUpsideDown {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext {
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Initialization

- (void)setUp {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [self setUp];
}

- (void)layoutSubviews {
    [self setUp];
}

@end
