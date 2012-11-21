//
//  TextCheckViewController.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 16..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsertSentence.h"
#import "NextAddInfoView.h"

@interface TextCheckViewController : UIViewController<UITextViewDelegate>{
    
    IBOutlet UITextView *textView;
    NSString *msg;
    Boolean textViewSize;
    
    InsertSentence *insertSentence;
    NextAddInfoView *nextView;
    
    BOOL thisTouch;
}
- (IBAction)backBtnEvent:(id)sender;
- (IBAction)nextBtnEvent:(id)sender;

-(void)setTextViewMsg:(NSString *)_msg;
@end
