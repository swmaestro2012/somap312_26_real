//
//  TextFileLoadViewController.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 13..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
@interface TextFileLoadViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>{
    NSMutableArray *items;
    IBOutlet UITableView *itemTable;
    
    NSString *text;
    DataBase *dbMsg;
}
- (IBAction)backBtnEvent:(id)sender;

@end
