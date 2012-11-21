//
//  CheckAnswer.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 19..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "CheckAnswer.h"

@implementation CheckAnswer
@synthesize answerImg;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setOimg{
    [answerImg setImage:[UIImage imageNamed:@"oimg.png"]];
}
-(void)setXimg{
    [answerImg setImage:[UIImage imageNamed:@"ximg.png"]];
}

@end
