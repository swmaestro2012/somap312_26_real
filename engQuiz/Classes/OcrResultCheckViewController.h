//
//  OcrResultCheckViewController.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 15..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsertSentence.h"
#import "NextAddInfoView.h"

@class MBProgressHUD;

namespace tesseract {
    class TessBaseAPI;
};

@interface OcrResultCheckViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>{
    
    MBProgressHUD *progressHud;
    
    tesseract::TessBaseAPI *tesseract;
    uint32_t *pixels;
    //    UIImage *img;
    NSArray *imgArray;
    
    Boolean inputCheck;
    int checkNumber;

    
    IBOutlet UITextView *textView;
    NSString *_text;
    
    InsertSentence *insertSentence;
    NextAddInfoView *nextView;
    
    UITapGestureRecognizer *tap;
    
    Boolean textViewSize;
    
    BOOL thisTouch;
}
- (IBAction)backBtnEvent:(id)sender;
- (IBAction)nextBtnEvent:(id)sender;

-(void)setimage:(NSArray *)_imgArray;
@end
