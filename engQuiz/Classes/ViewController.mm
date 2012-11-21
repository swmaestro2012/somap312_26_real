//
//  ViewController.m
//  TesseractSample
//
//  Created by Ângelo Suzuki on 11/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "MBProgressHUD.h"

#include "baseapi.h"

#include "environ.h"
#import "pix.h"

#import "SentenceViewController.h"
#import "NSStringRegular.h"

@implementation ViewController

@synthesize progressHud;

#pragma mark - View lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dbMsg = [DataBase getInstance];
        
        // Set up the tessdata path. This is included in the application bundle
        // but is copied to the Documents directory on the first run.
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

- (void)dealloc {
    delete tesseract;
    tesseract = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
//    if (inputCheck) {
        [self start];
//    }else{
//        if (checkNumber == 0) {
//            [self setImg:@"Lorem_Ipsum_Univers.png"];
//        }else if ( checkNumber == 1) {
//            [self setImg:@"test03.JPG"];
//        }else if ( checkNumber == 2) {
//            [self setImg:@"test00-1.png"];
//        }else if ( checkNumber == 3) {
//            [self setImg:@"test00-2.png"];
//        }else if ( checkNumber == 4) {
//            [self setImg:@"test00-6.png"];
//        }
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    if (![self.progressHud isHidden])
        [self.progressHud hide:NO];
    self.progressHud = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//-(void)setimage:(UIImage *)image{
//    img = image;
//    
//    inputCheck = true;
//}


-(void)setimage:(NSArray *)_imgArray{
    imgArray = _imgArray;
    
    inputCheck = true;
}


-(void)setCheckNumber:(int)num{
    checkNumber = num;
    
    inputCheck = false;
}


- (void)start{
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
//    imageView.frame = self.view.frame;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:imageView];
    
    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHud.labelText = @"Processing OCR";
    
    [self.view addSubview:self.progressHud];
    [self.progressHud showWhileExecuting:@selector(processOcrAt:) onTarget:self withObject:imgArray animated:YES];
}


- (void)setImg:(NSString *)imgName{
    UIImage *image = [UIImage imageNamed:imgName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.view.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHud.labelText = @"Processing OCR";
    
    [self.view addSubview:self.progressHud];
    [self.progressHud showWhileExecuting:@selector(processOcrAt:) onTarget:self withObject:image animated:YES];
}

//- (void) checking:(int)check:(NSString *)result{
//    NSString *test;
//    switch (check) {
//        case 0:
//            
//            test = @"Univers\nLorem ipsum dolor sit amet, consetetur sadipscing\nelitr, sed diam nonumy eirmod tempor invidunt ut\nlabore et dolore magna aliquyam erat, sed diam\nvoluptua. At vero eos et accusam et justo duo\ndolores et ea rebum. Stet clita kasd gubergren, no\nsea takimata sanctus est Lorem ipsum dolor sit\namet. Lorem ipsum dolor sit amet, consetetur\nsadipscing elitr, sed diam nonumy eirmod tempor\ninvidunt ut labore et dolore magna aliquyam erat,\nsed diam voluptua. At vero eos et accusam et justo\nduo dolores et ea rebum. Stet clita kasd gubergren,\nno sea takimata sanctus est Lorem ipsum dolor sit\namet. Lorem ipsum dolor sit amet, consetetur\nsadipscing elitr, sed diam nonumy eirmod tempor\ninvidunt ut labore et dolore magna aliquyam erat,\nsed diam voluptua. At vero eos et accusam et justo\nduo dolores et ea rebum. Stet clita kasd gubergren,\nno sea takimata sanctus est Lorem ipsum dolor sit\namet.";
//
//            break;
//        case 1:
//            
//            test =@"A\nWhat's Brian's sister like?\nHow is Amy these days?\nAre you hungry?\nCan you play chess?\nAre you enjoying your vacation?\nWhat's that book like?\nIs Bangkok an interesting place?\nMike was late for work again\ntoday.\nThe car broke down again\nyesterday.\nWho's that woman by the door?";
//            break;
//        case 2:
//            
//            test =@"Ongoing political unrest and trogic events aroud the world underscore the need for a diversified,\nglobal energy system - one that not only meets growing energy demand but also protects the\nenvironment and respects local communities.\nThese are among the sustainable development imperatives that drive our business at Shell and allow\nus to develop and deliver more energy in socially, economiclly and enviromentally responsible\nways. Let me share three examples.\nFirst, we're playing on important role to ensure that natural gas is a vital, long-term component of\nany future energy mix - one that has the potential to completely change the energy outlook for the\nUnited States. Natural gas is a lower-carbon energy source - in fact, it's the cleanest-burning and\nmost efficient fossil fuel. And with its 250-year global supply, natural gas is an affordable energy\nsolution that supports growth while reducing climate emissions.\nAt Shell, we're producing more natural gas, using advanced technologies to develop new resources\nand finding ways to make the most from existing resources. By next year, our company will produce\nmore natural gas than oil.\nSecond, Shell is focused on sustainable biofuels, which we believe provide the most practical and\ncommercial way to reduce CO2 from transport fuels over the next 20 years. Our recent joint venture\n- nomed Raizen - with the Brazilian ethanol company, Cosan, will have the capacily to produce\nmore than half a billion gallons of Brazilian sugarcane ethanol, which is the most sustainable biofuel\available today.\nFinally, we see great promise in carbon capture and storage technology. The Gorgon LNG project in\nAustralia, which will be the world's largest once completed, will capture and store nearly 4 million\ntons of CO2 per year - the equivalent of removing 700,000 cars from the road.\nThis year, we issued our 14th annual Shell Sustainability Report. I invite you to read it to learn more\nabout how Shell is helping to build a sustainable energy future.";
//            break;
//        case 3:
//            
//            test =@"Ongoing political unrest and trogic events aroud the world underscore the need for a diversified,\nglobal energy system - one that not only meets growing energy demand but also protects the\nenvironment and respects local communities.\nThese are among the sustainable development imperatives that drive our business at Shell and allow\nus to develop and deliver more energy in socially, economiclly and enviromentally responsible\nways. Let me share three examples.\nFirst, we're playing on important role to ensure that natural gas is a vital, long-term component of\nany future energy mix - one that has the potential to completely change the energy outlook for the\nUnited States. Natural gas is a lower-carbon energy source - in fact, it's the cleanest-burning and\nmost efficient fossil fuel. And with its 250-year global supply, natural gas is an affordable energy\nsolution that supports growth while reducing climate emissions.\nAt Shell, we're producing more natural gas, using advanced technologies to develop new resources\nand finding ways to make the most from existing resources. By next year, our company will produce\nmore natural gas than oil.\nSecond, Shell is focused on sustainable biofuels, which we believe provide the most practical and\ncommercial way to reduce CO2 from transport fuels over the next 20 years. Our recent joint venture\n- nomed Raizen - with the Brazilian ethanol company, Cosan, will have the capacily to produce\nmore than half a billion gallons of Brazilian sugarcane ethanol, which is the most sustainable biofuel\available today.\nFinally, we see great promise in carbon capture and storage technology. The Gorgon LNG project in\nAustralia, which will be the world's largest once completed, will capture and store nearly 4 million\ntons of CO2 per year - the equivalent of removing 700,000 cars from the road.\nThis year, we issued our 14th annual Shell Sustainability Report. I invite you to read it to learn more\nabout how Shell is helping to build a sustainable energy future.";
//            break;
//        case 4:
//            
//            test =@"Ongoing political unrest and trogic events aroud the world underscore the need for a diversified,\nglobal energy system - one that not only meets growing energy demand but also protects the\nenvironment and respects local communities.\nThese are among the sustainable development imperatives that drive our business at Shell and allow\nus to develop and deliver more energy in socially, economiclly and enviromentally responsible\nways. Let me share three examples.\nFirst, we're playing on important role to ensure that natural gas is a vital, long-term component of\nany future energy mix - one that has the potential to completely change the energy outlook for the\nUnited States. Natural gas is a lower-carbon energy source - in fact, it's the cleanest-burning and\nmost efficient fossil fuel. And with its 250-year global supply, natural gas is an affordable energy\nsolution that supports growth while reducing climate emissions.\nAt Shell, we're producing more natural gas, using advanced technologies to develop new resources\nand finding ways to make the most from existing resources. By next year, our company will produce\nmore natural gas than oil.\nSecond, Shell is focused on sustainable biofuels, which we believe provide the most practical and\ncommercial way to reduce CO2 from transport fuels over the next 20 years. Our recent joint venture\n- nomed Raizen - with the Brazilian ethanol company, Cosan, will have the capacily to produce\nmore than half a billion gallons of Brazilian sugarcane ethanol, which is the most sustainable biofuel\available today.\nFinally, we see great promise in carbon capture and storage technology. The Gorgon LNG project in\nAustralia, which will be the world's largest once completed, will capture and store nearly 4 million\ntons of CO2 per year - the equivalent of removing 700,000 cars from the road.\nThis year, we issued our 14th annual Shell Sustainability Report. I invite you to read it to learn more\nabout how Shell is helping to build a sustainable energy future.";
//            break;
//        case 5:
//            
//            test =@"Ongoing political unrest and trogic events aroud the world underscore the need for a diversified,\nglobal energy system - one that not only meets growing energy demand but also protects the\nenvironment and respects local communities.\nThese are among the sustainable development imperatives that drive our business at Shell and allow\nus to develop and deliver more energy in socially, economiclly and enviromentally responsible\nways. Let me share three examples.\nFirst, we're playing on important role to ensure that natural gas is a vital, long-term component of\nany future energy mix - one that has the potential to completely change the energy outlook for the\nUnited States. Natural gas is a lower-carbon energy source - in fact, it's the cleanest-burning and\nmost efficient fossil fuel. And with its 250-year global supply, natural gas is an affordable energy\nsolution that supports growth while reducing climate emissions.\nAt Shell, we're producing more natural gas, using advanced technologies to develop new resources\nand finding ways to make the most from existing resources. By next year, our company will produce\nmore natural gas than oil.\nSecond, Shell is focused on sustainable biofuels, which we believe provide the most practical and\ncommercial way to reduce CO2 from transport fuels over the next 20 years. Our recent joint venture\n- nomed Raizen - with the Brazilian ethanol company, Cosan, will have the capacily to produce\nmore than half a billion gallons of Brazilian sugarcane ethanol, which is the most sustainable biofuel\available today.\nFinally, we see great promise in carbon capture and storage technology. The Gorgon LNG project in\nAustralia, which will be the world's largest once completed, will capture and store nearly 4 million\ntons of CO2 per year - the equivalent of removing 700,000 cars from the road.\nThis year, we issued our 14th annual Shell Sustainability Report. I invite you to read it to learn more\nabout how Shell is helping to build a sustainable energy future.";
//            break;
//        default:
//            break;
//            
//    }
//
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
//    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:0];
//
//    [self getChecking:test:array];
//    [self getChecking:result:array2];
//    
//    [array2 removeObjectAtIndex:array2.count - 1];
//
//    int max = 0;
//    int min = 0;
//    int voCount = 0;
//    
//    if (array.count > array2.count) {
//        max = array.count;
//        min = array2.count;
//    }else {
//        max = array2.count;
//        min = array.count;
//    }
//    
//    min = min / 2;
//    max = max / 2;
//    
//    for (int i = 0; i < min; i++) {
//        if ([[array objectAtIndex:i] isEqual:[array2 objectAtIndex:i]])
//            voCount++;
////        else
////            NSLog(@"틀린곳\n원문 : %@ \nOCR : %@",[array objectAtIndex:i],[array2 objectAtIndex:i]);
//    }
//
//    double per = (double)voCount / (double)max * 100;
//    NSLog(@"맞는 단어 : %d, 전체 단어 : %d", voCount, max);
//    NSLog(@"단어별 %f 퍼센트",per);
//    
//    NSString *temp1;
//    NSString *temp2;
//    int subMax = 0;
//    int subMin = 0;
//    int checkingCount = 0;
//    int checkingCountMax = 0;
//
//    
//    for (int i = 0; i < min; i++) {
//        temp1 = [array objectAtIndex:i];
//        temp2 = [array2 objectAtIndex:i];
//        
//        if (temp1.length > temp2.length) {
//            subMax = temp1.length;
//            subMin = temp2.length;
//        }else {
//            subMax = temp2.length;
//            subMin = temp1.length;
//        }
//        checkingCountMax = checkingCountMax + subMax;
//        for(int j = 0; j < subMin; j++){
//            if ([[temp1 substringWithRange:(NSRange){j,1}] isEqual:[temp2 substringWithRange:(NSRange){j,1}]]) {
//                checkingCount++;
//            }
//
//        }
//
//    }
//    
//    
//    double per2 = (double)checkingCount / (double)checkingCountMax * 100;
//    NSLog(@"맞는 문자 : %d, 전체 문자 : %d", checkingCount, checkingCountMax);
//    NSLog(@"문자 %f 퍼센트",per2);
//
//
//
//}
//
//- (void)getChecking:(NSString *)checkString:(NSMutableArray *)array{
//    int voCount = 0;
//    Boolean isChecking = false;
//    int tempInt = 0;
//    int tempCount = 1;
//    for (int i = 0; i < checkString.length; i++) {
//        
//        if ([[checkString substringWithRange:(NSRange){i,1}] isEqualToString:@" "] || [[checkString substringWithRange:(NSRange){i,1}] isEqualToString:@"\n"]) {
//
//            [array insertObject:[checkString substringWithRange:(NSRange){tempInt,tempCount}] atIndex:voCount];
//            voCount++;
//            isChecking = false;
//        }else if(i == checkString.length -1){
//            [array insertObject:[checkString substringWithRange:(NSRange){tempInt,tempCount+1}] atIndex:voCount];
//
//            voCount++;
//            isChecking = false;
//        }else if(!isChecking){
//            isChecking = true;
//            tempInt = i;
//            tempCount = 1;
//        }else{
//            tempCount++;
//        }
//    }
//}

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
//    [[[UIAlertView alloc] initWithTitle:@"Tesseract Sample"
//                                message:[NSString stringWithFormat:@"%@", result]
//                               delegate:self
//                      cancelButtonTitle:nil
//                      otherButtonTitles:@"OK", nil] show];
    
//    [self checking:checkNumber :result];

//    SentenceViewController *sentenceView = [[SentenceViewController alloc]init];
    
    
    resultCheckView = [[OcrResultCheckViewController alloc]init];
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy"];
//    int year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
//    [dateFormatter setDateFormat:@"MM"];
//    int month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
//    [dateFormatter setDateFormat:@"dd"];
//    int day = [[dateFormatter stringFromDate:[NSDate date]] intValue];
//    
//    NSString *tempMonth = @"";
//    NSString *tempDay = @"";
//    if (month < 10) {
//        tempMonth = [NSString stringWithFormat:@"0%d",month];
//    }else{
//        tempMonth = [NSString stringWithFormat:@"%d",month];
//    }
//    
//    if (day < 10) {
//        tempDay = [NSString stringWithFormat:@"0%d",day];
//    }else{
//        tempDay = [NSString stringWithFormat:@"%d",day];
//    }
//    
//    NSString *date =[NSString stringWithFormat:@"%d%@%@",year,tempMonth,tempDay];
//    NSStringRegular *regular = [[NSStringRegular alloc]init];

//    [resultCheckView setTextView:[regular stringChange:result]];
    [self presentModalViewController:resultCheckView animated:YES];
    [self dismissModalViewControllerAnimated:NO];

    
    
//    [dbMsg saveSentence:[NSString stringWithFormat:@"%@",[regular stringChange:result]] :date :@"filename"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"bookTableReload" object:nil];
//    [self dismissModalViewControllerAnimated:YES];
    
    
    //    [self dismissModalViewControllerAnimated:YES];
    
    //    [sentenceView setInit:@"추가지문" :result :0 :0 ];

    
//    [self presentModalViewController:sentenceView animated:NO];
    
//    [dbMsg saveSentence:result :@"000000" :@"filename"];
    
//    [dbMsg saveSentence:[NSString stringWithFormat:@"%@", result] :@"000000" :@"filename"];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"bookTableReload" object:nil];
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

@end
