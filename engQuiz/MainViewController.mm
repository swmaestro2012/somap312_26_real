//
//  ViewController.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 10. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "MainViewController.h"
#include "CitarPOS.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dbMsg = [DataBase getInstance];
    
    [dbMsg LoadDataBaseFile];
    
    NSLog(@"initialize citarpos");
    std::string lexicon = std::string([[[NSBundle mainBundle] pathForResource:@"brown-simplified" ofType:@"lexicon"] UTF8String]);
    std::string ngrams = std::string([[[NSBundle mainBundle] pathForResource:@"brown-simplified" ofType:@"ngrams"] UTF8String]);
    
    CitarPOS::initInstance(lexicon, ngrams);
    
    
//    exView = [[ExamLoadViewController alloc]init];
//    vocaView = [[VocaViewController alloc]init];
//    repositoryView = [[RepositoryViewController alloc]init];
//    chartView = [[ChartViewController alloc]init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exBtnEvent:(id)sender {
    if (exView != nil) {
        exView = nil;
        [exView removeFromParentViewController];
    }
    exView = [[ExamLoadViewController alloc]init];
    [self presentModalViewController:exView animated:YES];
}

- (IBAction)vocaBtnEvent:(id)sender {
    if (vocaView != nil) {
        vocaView = nil;
        [vocaView removeFromParentViewController];
    }
    vocaView = [[VocaViewController alloc]init];
    [self presentModalViewController:vocaView animated:YES];
}

- (IBAction)repositoryBtnEvent:(id)sender {
    if (repositoryView != nil) {
        repositoryView = nil;
        [repositoryView removeFromParentViewController];
    }
    repositoryView = [[RepositoryViewController alloc]init];
    [repositoryView reLoadTable];
    [self presentModalViewController:repositoryView animated:YES];
}

- (IBAction)chartBtnEvent:(id)sender {
    if (chartView != nil) {
        chartView = nil;
        [chartView removeFromParentViewController];
    }
    chartView = [[ChartViewController alloc]init];
    [self presentModalViewController:chartView animated:YES];
}

- (IBAction)settingBtnEvent:(id)sender {
    if (settingView != nil) {
        settingView = nil;
        [settingView removeFromParentViewController];
    }
    
    settingView = [[SettingViewController alloc]init];
    
    [self presentModalViewController:settingView animated:YES];
}
@end
