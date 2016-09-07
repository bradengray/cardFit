//
//  CardView.m
//  CardFit
//
//  Created by Braden Gray on 9/6/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.numberOfLines = 0;
        _centerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_centerLabel setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.5]];
        _centerLabel.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:_centerLabel];
    }
    return _centerLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
