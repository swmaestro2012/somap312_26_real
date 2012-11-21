//
//  TextPasteViewController.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 10..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "TextPasteViewController.h"
#import "NSStringRegular.h"
#import "SentenceViewController.h"

@interface TextPasteViewController ()

@end

@implementation TextPasteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dbMsg = [DataBase getInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTextViewSize:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ocr_dismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnEvent:) name:@"ocr_dismiss" object:nil];
    
    
//    [textView becomeFirstResponder];
    
//    if (textCheck != 0) {
//        textView.text = text;
//    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnEvent:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ocr_dismiss" object:nil];
}

- (IBAction)saveBtnEvent:(id)sender {
    [self saveEvent];
}

//- (void)setText:(NSString *)_text{
//    textCheck = 1;
//    text = _text;
//}


-(void)saveEvent{
    NSStringRegular *regular = [[NSStringRegular alloc]init];
    textView.text = [regular stringChange:textView.text];


    [textView resignFirstResponder];    
    
    if (nextView != nil) {
        [nextView removeFromSuperview];
        nextView = nil;
    }
    
    nextView = [[NextAddInfoView alloc]init];
    
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"NextAddInfoView" owner:self options:nil];
    nextView = (NextAddInfoView *)[xibs objectAtIndex:0];
    [nextView awakeFromNib];
    
    nextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [nextView.cancelBtn addTarget:self action:@selector(cancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [nextView.nextBtn addTarget:self action:@selector(subNextBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [nextView.saveBtn addTarget:self action:@selector(saveCheckBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [nextView.themeTextField setDelegate:nextView];
    [nextView.groupTextField setDelegate:nextView];
    
    [self.view addSubview:nextView];
}

- (IBAction)saveCheckBtnEvent:(UIButton *)sender{
    if (insertSentence != nil) {
        insertSentence = nil;
    }
    insertSentence = [[InsertSentence alloc]init];
    NSString *theme = nextView.themeTextField.text;
    NSString *group = nextView.groupTextField.text;
    
    [insertSentence insert:textView.text theme:theme group:group];
    [sender setTitle:@"저장되었습니다." forState:UIControlStateNormal];
    [sender setEnabled:NO];
}
- (IBAction)cancelBtnEvent:(id)sender {
    NSLog(@"cancelBtn Event");
    [nextView removeFromSuperview];
}

- (IBAction)subNextBtnEvent:(id)sender {
    SentenceViewController *sentenceView = [[SentenceViewController alloc]init];
    
    [sentenceView setInit:@"추가지문" :textView.text :0 :0 ];
    [sentenceView setDIsType:NO];
    [self presentModalViewController:sentenceView animated:YES];
}


/* ----------------------------------------
 Keyboard 높이만큼 TextView 의 사이즈 변경
 ---------------------------------------- */
-(void)setTextViewSize:(NSNotification *)notification
{
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [textView setFrame:CGRectMake(0, 44, textView.frame.size.width, textView.frame.size.height - kbSize.height)];
//    textView.frame = CGRectMake(0, 44, textView.frame.size.width, textView.frame.size.height - kbSize.height);

    
//    NSLog(@"%f /// %f",textView.frame.size.height - kbSize.height, textView.frame.size.height);

}


- (BOOL)textView:(UITextView *)textview shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    //textView에 어느 글을 쓰더라도 이 메소드를 호출합니다.
    if ([text isEqualToString:@"\n"]) {
        textView.text = [textview.text stringByReplacingCharactersInRange:range withString:@"\r"];
        return false;
    }
    return TRUE; //평소에 경우에는 입력을 해줘야 하므로, TRUE를 리턴하면 TEXT가 입력됩니다.
}

- (void)textViewDidBeginEditing:(UITextView *)textview{
    if (!thisTouch) {
        textView.text =@"";
        thisTouch = true;
    }
}

- (void)viewDidUnload {
    textView = nil;
    [super viewDidUnload];
}
@end
