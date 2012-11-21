//
//  ChartViewController.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 6..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "ChartViewController.h"
#include "GenTable.h"

@interface ChartViewController ()

@end

@implementation ChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dbMsg = [DataBase getInstance];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        [dateFormatter setDateFormat:@"MM"];
        month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        [dateFormatter setDateFormat:@"dd"];
        day = [[dateFormatter stringFromDate:[NSDate date]] intValue];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if(selectControlbar.selectedSegmentIndex == 0){
        [self dayChart];
    }else if(selectControlbar.selectedSegmentIndex == 1){
        [self monthChart];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)dayChart{
    GenTable table;
    cArray = [dbMsg getLogData:0:year:month:day];
    if (cArray.count != 0 ) {
        for (int i = 0;  i < cArray.count / 4; i++) {
            if (i == 0) {
//                std::string cppString = [[cArray objectAtIndex:1] UTF8String];
                
                NSString *temp = [cArray objectAtIndex:1];
                temp = [NSString stringWithFormat:@"%@.%@.%@",[temp substringWithRange:(NSRange){0,4}],[temp substringWithRange:(NSRange){4,2}],[temp substringWithRange:(NSRange){6,2}]];

                 std::string cppString = [temp UTF8String];
                
                table.datas.push_back(GenTableData(cppString,[[cArray objectAtIndex:2] intValue], [[cArray objectAtIndex:3] intValue]));
                
            }else {
//                std::string cppString = [[cArray objectAtIndex:i * 4 + 1] UTF8String];
                
                NSString *temp = [cArray objectAtIndex:i * 4 + 1];
                temp = [NSString stringWithFormat:@"%@.%@.%@",[temp substringWithRange:(NSRange){0,4}],[temp substringWithRange:(NSRange){4,2}],[temp substringWithRange:(NSRange){6,2}]];
                
                std::string cppString = [temp UTF8String];

                
                table.datas.push_back(GenTableData(cppString,[[cArray objectAtIndex:i * 4 + 2] intValue], [[cArray objectAtIndex:i * 4 + 3] intValue]));
            }
            // 1 5
        }
    }
    
    //    맞은 문제 빨강 ...
    
    std::string temp = table.run_gchart([[[NSBundle mainBundle] pathForResource:@"chart" ofType:@"html"] UTF8String], "", "");
    
    NSString *html = [NSString stringWithUTF8String:temp.c_str()];
    
    [webView loadHTMLString:html baseURL:nil];
}

- (void)monthChart{
    GenTable table;
    cArray = [dbMsg getLogData:1:year:month:day];
    if (cArray.count != 0 ) {
        for (int i = 0;  i < cArray.count / 3; i++) {
            
//            std::string cppString = [[cArray objectAtIndex:i * 3] UTF8String];
            
            NSString *temp = [cArray objectAtIndex:i * 3];
            temp = [NSString stringWithFormat:@"%@.%@",[temp substringWithRange:(NSRange){0,4}],[temp substringWithRange:(NSRange){4,2}]];
            
            std::string cppString = [temp UTF8String];
            
            
            table.datas.push_back(GenTableData(cppString,[[cArray objectAtIndex:i * 3 + 1] intValue], [[cArray objectAtIndex:i * 3 + 2] intValue]));
        }
    }
    
    //    맞은 문제 빨강 ...
    
    std::string temp = table.run_gchart([[[NSBundle mainBundle] pathForResource:@"chart" ofType:@"html"] UTF8String], "", "");
    
    NSString *html = [NSString stringWithUTF8String:temp.c_str()];
    
    [webView loadHTMLString:html baseURL:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnEvent:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectChangeEvent:(id)sender {
    if(selectControlbar.selectedSegmentIndex == 0){
        [self dayChart];
    }else if(selectControlbar.selectedSegmentIndex == 1){
        [self monthChart];
    }

}
- (void)viewDidUnload {
    webView = nil;
    selectControlbar = nil;
    [super viewDidUnload];
}
@end
