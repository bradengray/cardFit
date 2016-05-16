//
//  NumOfCardsPopoverContentTVC.m
//  CardFit
//
//  Created by Braden Gray on 5/12/16.
//  Copyright © 2016 Graycode. All rights reserved.
//

#import "NumOfCardsPopoverContentTVC.h"

@implementation NumOfCardsPopoverContentTVC

#pragma mark - Properties

- (void)setNumberOfCardsSelections:(NSArray *)numberOfCardsSelections {
    _numberOfCardsSelections = numberOfCardsSelections;
    
    NSInteger rowCount = [_numberOfCardsSelections count];
    NSInteger rowHeight = [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSInteger totalRowsHeight = rowCount * rowHeight;
    
    CGFloat largestCellWidth = 0;
    for (NSString *numOfCards in _numberOfCardsSelections) {
        CGSize labelSize = [numOfCards sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20.0f]}];
        if (labelSize.width > largestCellWidth) {
            largestCellWidth = labelSize.width;
        }
    }
    
    CGFloat popoverWidth = largestCellWidth + 50;
    
    self.preferredContentSize = CGSizeMake(popoverWidth, totalRowsHeight);
    
    [self.tableView reloadData];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.numberOfCardsSelections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Popover Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.numberOfCardsSelections objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    NSString *selectedNumberOfCards = [self.numberOfCardsSelections objectAtIndex:indexPath.row];
    
    if (self.delegate != nil) {
        [self.delegate selectedNumberOfCards:selectedNumberOfCards];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
