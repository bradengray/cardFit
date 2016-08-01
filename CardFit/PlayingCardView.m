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

- (void)setSuit:(NSUInteger)suit { //Sets suit and redraws view
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank { //Sets rank and redraws view
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp { //Sets faceUp and redraws view
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (NSString *)rankAsString { //Returns string value for rank
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"JOKER"] [self.rank];
}

- (NSString *)suitAsString { //Returns string value for rank
    return @[@"♠️", @"♥️", @"♣️", @"♦️"] [self.suit];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 240.0 //Standard height of card
#define CORNER_RADIUS 30.0 //Used as scale factor for corner radius
#define FACE_CARD_IMAGE_SCALE_FACTOR 0.100 //Used as scale factor for card images

- (CGFloat)cornerScaleFactor { //
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
    return CORNER_RADIUS / [self cornerScaleFactor];
}

- (CGFloat)cornerOffset {
    return [self cornerRadius] / 3.0;
}

- (void)drawRect:(CGRect)rect { //Draws Card
    //Draws boundary of card card with BezierPath
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    [roundedRect fill];
    
    [[UIColor blackColor] setStroke];
    roundedRect.lineWidth = 2.0;
    [roundedRect stroke];
    
    //Draws the contents of the card
    if (self.faceUp) {
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self rankAsString]]];
        if (faceImage) { //Inserts image for face card
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * FACE_CARD_IMAGE_SCALE_FACTOR, self.bounds.size.height * FACE_CARD_IMAGE_SCALE_FACTOR);
            [faceImage drawInRect:imageRect];
        } else { //Draw pips
            [self drawPips];
        }
        [self drawCorners]; //Draw corners
    } else { //Set card face down
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

- (void)drawCorners { //Draws corner text on cards
    //Set alignment center
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    //Create font
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
    //Set attributed text with attributes
    NSAttributedString *cornterText = [[NSAttributedString alloc] initWithString:[self cornerTextString] attributes:@{NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [self fontColor]}];
    
    //Create Rect in corners for text based on text size and draw
    CGRect textbounds;
    textbounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textbounds.size = cornterText.size;
    [cornterText drawInRect:textbounds];
    
    //Rotate Context and draw opposite corner
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    [cornterText drawInRect:textbounds];
    [self popContext];
}

- (NSString *)cornerTextString { //Returns String for corner text
    if (!(self.rank == 14)) {//Draws any corner except joker
        return [NSString stringWithFormat:@"%@\n%@", [self rankAsString], [self suitAsString]];
    } else { //Draws joker
        NSString *rankString = [self rankAsString];
        NSString *charachterString = @"";
        for (int i = 0; i < [rankString length]; i++) {
            charachterString = [charachterString stringByAppendingString:[NSString stringWithFormat:@"%@\n", [rankString substringWithRange:NSMakeRange(i, 1)]]];
        }
        return charachterString;
    }
}

- (UIColor *)fontColor { //Returns font color for card based on suit
    if (self.suit == 0 || self.suit == 2) {
        return [UIColor blackColor];
    } else {
        return [UIColor colorWithRed:.85 green:0 blue:0 alpha:1];
    }
}

#pragma mark - Draw Pips

//Pip offsets
#define PIP_HOFFSET_PERCENTAGE 0.200
#define PIP_VOFFSET1_PERCENTAGE 0.100
#define PIP_VOFFSET2_PERCENTAGE 0.150
#define PIP_VOFFSET3_PERCENTAGE 0.200
#define PIP_VOFFSET4_PERCENTAGE 0.300

- (void)drawPips { //Draws pips vased on rank
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

#define PIP_FONT_SCALE_FACTOR 0.0085 //Used as pip scale factor based on view height

//Called for drawing pips bool value for drawing pips mirrored on card
- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset mirroredVertically:(BOOL)mirroredVertically {
    [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
    }
}

//Called for drawing pips the bool upside down will rotate the context of the entire view
- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset upsideDown:(BOOL)upsideDown {
    if (upsideDown) { //Flip context if upside down
        [self pushContextAndRotateUpsideDown];
    }
    //Create point from middle to draw text and draw at point
    CGPoint middle = CGPointMake(self.bounds.size.width/2.0 - .5, self.bounds.size.height/2.0);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributesSuit = [[NSAttributedString alloc] initWithString:[self suitAsString] attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributesSuit size];
    CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width/2.0 - hoffset*self.bounds.size.width, middle.y - pipSize.height/2.0 - voffset*self.bounds.size.height);
    [attributesSuit drawAtPoint:pipOrigin];
    if (hoffset) { //If horizontal offset adjust and draw new pip at new point
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributesSuit drawAtPoint:pipOrigin];
    } //If upside down pop context
    if (upsideDown) {
        [self popContext];
    }
}

- (void)pushContextAndRotateUpsideDown { //Called to flip the context of the view
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext { //Called to return view context to normal
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

#pragma mark - Initialization

- (void)setUp { //Sets background color to nil and sets content mode to redraw
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib { //Sets up for when cards are loaded from nib
    [super awakeFromNib];
    [self setUp];
}

- (void)layoutSubviews { //Sets up for when cards are layed out in subview
    [self setUp];
}

@end
