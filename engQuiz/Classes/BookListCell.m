//
//  BookListCell.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 1..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "BookListCell.h"

@implementation BookListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
