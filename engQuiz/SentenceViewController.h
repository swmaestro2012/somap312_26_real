//
//  SentenceViewController.h
//  TesseractSample
//
//  Created by 박 찬기 on 12. 10. 26..
//
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "CheckAnswer.h"
#import "MessageUI/MessageUI.h"

@interface SentenceViewController : UIViewController<UIAlertViewDelegate,MFMessageComposeViewControllerDelegate>{
    
    IBOutlet UILabel *bookName;
    IBOutlet UILabel *pageNumber;
    
    NSString *examSentence;
    
    DataBase *dbMsg;
    NSString *bName;
    NSString *pNumber;
    
    NSString *exam;
    NSString *exam2;
    
    NSString *originJimoon;
    NSString *feedback;
    
    int sid;
    int qid;
    
    int check;
    
    int nowType;
    int nowId;
    
    int nowCheck;
    
    int checkedNumber;
    
    BOOL navi;
    
    BOOL checkState;
    
    BOOL dismissType;
    
    
    IBOutlet UILabel *questionLabel;
    IBOutlet UILabel *answerLabel01;
    IBOutlet UILabel *answerLabel02;
    IBOutlet UILabel *answerLabel03;
    IBOutlet UILabel *answerLabel04;
    
    NSMutableArray *pArray;
    UILabel *label[5];
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIView *sentenceView;
    
    IBOutlet UIButton *answerCheck1Btn;
    IBOutlet UIButton *answerCheck2Btn;
    IBOutlet UIButton *answerCheck3Btn;
    IBOutlet UIButton *answerCheck4Btn;
    
    IBOutlet UIButton *answerHiddenBtn1;
    IBOutlet UIButton *answerHiddenBtn2;
    IBOutlet UIButton *answerHiddenBtn3;
    IBOutlet UIButton *answerHiddenBtn4;
    
    
    IBOutlet UIWebView *webView;
    IBOutlet UIButton *saveBtn;
    
    CheckAnswer *checkView;
    IBOutlet UIButton *reExamBtn;
    
}
- (IBAction)backEvent:(id)sender;
- (void)setInit:(NSString *)name:(NSString *)getSentence:(int)type:(int)_id;
- (IBAction)saveExam:(id)sender;
- (IBAction)naviEvent:(id)sender;
- (IBAction)answerCheck1:(id)sender;
- (IBAction)answerCheck2:(id)sender;
- (IBAction)answerCheck3:(id)sender;
- (IBAction)answerCheck4:(id)sender;
- (void)setDIsType:(BOOL)type;
- (IBAction)messageSend:(id)sender;
- (IBAction)kakaoSend:(id)sender;
- (IBAction)reExamBtnEvent:(id)sender;
@end
