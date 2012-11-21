//
//  ChartViewController.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 6..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
//#include "GenTable.h"

@interface ChartViewController : UIViewController<UIWebViewDelegate>{
    
    IBOutlet UIWebView *webView;
    DataBase *dbMsg;
    
    IBOutlet UISegmentedControl *selectControlbar;
    NSArray *cArray;
    
//    GenTable table;

    int year;
    int month;
    int day;
}

- (IBAction)backBtnEvent:(id)sender;
- (IBAction)selectChangeEvent:(id)sender;
@end
 