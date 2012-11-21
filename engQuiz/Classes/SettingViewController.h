//
//  SettingViewController.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 15..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "MessageUI/MessageUI.h"

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>{
    
    IBOutlet UITableView *settingTable;
    
    DataBase *dbMsg;
    
    NSString *tempClass;
    UIAlertView *alert;
}

- (IBAction)backBtnEvent:(id)sender;
@end
