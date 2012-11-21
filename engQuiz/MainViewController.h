//
//  ViewController.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 10. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamLoadViewController.h"
#import "VocaViewController.h"
#import "RepositoryViewController.h"
#import "ChartViewController.h"
#import "SettingViewController.h"
#import "DataBase.h"

@interface MainViewController : UIViewController{
    
    ExamLoadViewController *exView;
    VocaViewController *vocaView;
    RepositoryViewController *repositoryView;
    ChartViewController *chartView;
    SettingViewController *settingView;
    DataBase *dbMsg;
}

- (IBAction)exBtnEvent:(id)sender;
- (IBAction)vocaBtnEvent:(id)sender;
- (IBAction)repositoryBtnEvent:(id)sender;
- (IBAction)chartBtnEvent:(id)sender;
- (IBAction)settingBtnEvent:(id)sender;
@end
