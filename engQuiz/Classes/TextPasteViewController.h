//
//  TextPasteViewController.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 10..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "NextAddInfoView.h"
#import "InsertSentence.h"

@interface TextPasteViewController : UIViewController<UITextViewDelegate>{
    DataBase *dbMsg;
    IBOutlet UITextView *textView;
    
    NextAddInfoView *nextView;
    InsertSentence *insertSentence;
    
    float textH;
    
    BOOL thisTouch;
}

- (IBAction)backBtnEvent:(id)sender;
- (IBAction)saveBtnEvent:(id)sender;
@end
