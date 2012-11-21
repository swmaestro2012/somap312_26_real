//
//  EditThemeAndGroup.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "EditThemeAndGroup.h"

@implementation EditThemeAndGroup
@synthesize themeLabel, groupLabel;

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
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return true;
}

-(void)keyBoardDown{
    [themeLabel resignFirstResponder];
    [groupLabel resignFirstResponder];
    [self removeGestureRecognizer:tap];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardDown)];
    [self addGestureRecognizer:tap];
    
    return YES;
}


// -------- TextField EndEditing -------- //


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

@end
