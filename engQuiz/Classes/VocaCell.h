//
//  VocaCell.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 10. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VocaCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UILabel *meanLabel;
@property (strong, nonatomic) IBOutlet UILabel *classLabel;
@end
