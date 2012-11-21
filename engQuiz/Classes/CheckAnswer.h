//
//  CheckAnswer.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 19..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckAnswer : UIView

@property (strong, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (strong, nonatomic) IBOutlet UIButton *reBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIImageView *answerImg;

-(void)setOimg;
-(void)setXimg;
@end
