//
//  OcrResultCheckViewController.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 15..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "OcrResultCheckViewController.h"
#import "MBProgressHUD.h"

#include "baseapi.h"

#include "environ.h"
#import "pix.h"

#import "SentenceViewController.h"
#import "NSStringRegular.h"

@interface OcrResultCheckViewController ()

@end

@implementation OcrResultCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
        
        NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // If the expected store doesn't exist, copy the default store.
        if (![fileManager fileExistsAtPath:dataPath]) {
            // get the path to the app bundle (with the tessdata dir)
            NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
            NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
            if (tessdataPath) {
                [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
            }
        }
        
        setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
        
        // init the tesseract engine.
        tesseract = new tesseract::TessBaseAPI();
        tesseract->Init([dataPath cStringUsingEncoding:NSUTF8StringEncoding], "eng");
    }
    return self;
}

- (void)viewDidLoad
{
//    [textView setText:@"asdfsdf"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ocr_dismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backBtnEvent:) name:@"ocr_dismiss" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTextViewSize:) name:UIKeyboardWillShowNotification object:nil];
    [self start];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnEvent:(id)sender {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ocr_dismiss" object:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)nextBtnEvent:(id)sender {
    
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

- (void)viewDidUnload {
//    textView = nil;
    [super viewDidUnload];
    
    if (![progressHud isHidden])
        [progressHud hide:NO];
    progressHud = nil;
}

- (void)dealloc {
    delete tesseract;
    tesseract = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setimage:(NSArray *)_imgArray{
    imgArray = _imgArray;
    
    inputCheck = true;
}


-(void)setCheckNumber:(int)num{
    checkNumber = num;
    
    inputCheck = false;
}


- (void)start{

    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    progressHud.labelText = @"Processing OCR";
    
    [self.view addSubview:progressHud];
    [progressHud showWhileExecuting:@selector(processOcrAt:) onTarget:self withObject:imgArray animated:YES];
}


- (void)setImg:(NSString *)imgName{
    UIImage *image = [UIImage imageNamed:imgName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.view.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    progressHud.labelText = @"Processing OCR";
    
    [self.view addSubview:progressHud];
    [progressHud showWhileExecuting:@selector(processOcrAt:) onTarget:self withObject:image animated:YES];
}
- (void)processOcrAt:(NSArray *)_imgArray;
{
    NSString *temp = @"";
    for (int i = 0 ; i < _imgArray.count; i++) {
        [self setTesseractImage:[_imgArray objectAtIndex:i]];
        
        tesseract->Recognize(NULL);
        char* utf8Text = tesseract->GetUTF8Text();
        
        temp = [NSString stringWithFormat:@"%@%@",temp,[NSString stringWithUTF8String:utf8Text]];
    }
    
    
    
    
    [self performSelectorOnMainThread:@selector(ocrProcessingFinished:)
                           withObject:temp
                        waitUntilDone:NO];
}

- (void)ocrProcessingFinished:(NSString *)result
{
    NSStringRegular *regular = [[NSStringRegular alloc]init];
    
//    [textView setText:[regular stringChange:result]];
    [textView setText:[regular stringPaste:[regular stringChange:result]]];
}

- (void)setTesseractImage:(UIImage *)image
{
    free(pixels);
    
    CGSize size = [image size];
    int width = size.width;
    int height = size.height;
	
	if (width <= 0 || height <= 0)
		return;
	
    // the pixels will be painted to this array
    pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
	
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
	
	// we're done with the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    tesseract->SetImage((const unsigned char *) pixels, width, height, sizeof(uint32_t), width * sizeof(uint32_t));
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissModalViewControllerAnimated:YES];
}

/* ----------------------------------------
 Keyboard 높이만큼 TextView 의 사이즈 변경
 ---------------------------------------- */
-(void)setTextViewSize:(NSNotification *)notification
{
    if (!textViewSize) {
        NSDictionary *info = [notification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        
        //    [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height - kbSize.height)];
        [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height - kbSize.height)];
        
        textViewSize = true;
    }
    
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
@end
