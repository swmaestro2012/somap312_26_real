//
//  VocaViewController.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 10. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "ExSentence.h"

@interface VocaViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UIActionSheetDelegate, UITabBarDelegate>{
    
    IBOutlet UITableView *vocaTable;
    DataBase *dbMsg;
    
    NSMutableArray *vArray[26];
    NSMutableArray *wArray;
    NSMutableArray *mArray;
    
    NSMutableArray *muArray;
    
    NSMutableArray *xArray;
    
    IBOutlet UITextField *searchMsg;
    UITapGestureRecognizer *tap;

    int cellCount;
    IBOutlet UITabBar *tabbalContoller;
    IBOutlet UILabel *lblTitle;
    
    ExSentence *eSentence;
    
    UILocalizedIndexedCollation *collation;
    
    int type, check;
    IBOutlet UITabBarItem *item01;
}
- (IBAction)backBtnEvent:(id)sender;
- (IBAction)searchBtnEvent:(id)sender;
- (IBAction)eduBtnEvent:(id)sender;

@end
