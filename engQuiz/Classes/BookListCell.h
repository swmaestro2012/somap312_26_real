//
//  BookListCell.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 1..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *chapterLabel;
@property (strong, nonatomic) IBOutlet UILabel *themeLabel;

@end
