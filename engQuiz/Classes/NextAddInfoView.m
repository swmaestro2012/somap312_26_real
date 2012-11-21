//
//  NextAddInfoView.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 15..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "NextAddInfoView.h"

@implementation NextAddInfoView
@synthesize themeTextField, groupTextField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardDown)];
    }
    return self;
}

// ------------------------ TextField Setting ------------------------ //


// ------- TextField 'Retrun' Key Event ------- //

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return true;
}

-(void)keyBoardDown{
    [themeTextField resignFirstResponder];
    [groupTextField resignFirstResponder];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
