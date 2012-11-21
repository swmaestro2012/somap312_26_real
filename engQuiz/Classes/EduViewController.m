//
//  EduViewController.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 4..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "EduViewController.h"

@interface EduViewController ()

@end

@implementation EduViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dbMsg = [DataBase getInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    if (vArray.count != 0) {
        [self setEduText:nowPoz];
    }else {
        [lastWordBtn setEnabled:NO];
        [nextWordBtn setEnabled:NO];
        [meanBtn setEnabled:NO];
        [vocaCheckBtn setEnabled:NO];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnEvent:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setVocaArray:(NSMutableArray *)getArray{
    vArray = getArray;
}

- (IBAction)lastWordBtnEvent:(id)sender {
    nowPoz--;
    [self setEduText:nowPoz];
}

- (IBAction)nextWordBtnEvent:(id)sender {
    nowPoz++;
    [self setEduText:nowPoz];
}

- (IBAction)meanBtnEvent:(id)sender {
    [meanBtn setHidden:YES];
} 

- (IBAction)vocaCheckBtnEvent:(id)sender {
    if (nowPoz == 0) {
        [dbMsg setVocaCheck:[[vArray objectAtIndex:3] intValue] :1];
    }else {
        [dbMsg setVocaCheck: [[vArray objectAtIndex:nowPoz * 4 + 3] intValue]:1];
    }
}

- (void)setEduText:(int)poz{
    
    if (poz == 0) {
        if(vArray.count ==  4){
            [lastWordBtn setEnabled:NO];
            [nextWordBtn setEnabled:NO];
        }else{
            [lastWordBtn setEnabled:NO];
            [nextWordBtn setEnabled:YES];
        }
        
        NSArray *array = [dbMsg getAndCheckSentence:[vArray objectAtIndex:0]];
        
        if (array.count != 0) {
            NSString *temp = [array objectAtIndex:arc4random() % array.count];
            
            if ([[temp substringWithRange:(NSRange){0,1}]isEqualToString:@" "]) {
                temp = [temp substringWithRange:(NSRange){1,temp.length-1}];
            }
            exLabel.text = temp;
        }else{
            exLabel.text = @"";
        }

        
        wordLabel.text = [vArray objectAtIndex:0];
        meanLabel.text = [vArray objectAtIndex:1];
    }else{
        if(poz == vArray.count/4 - 1){
            [lastWordBtn setEnabled:YES];
            [nextWordBtn setEnabled:NO];
        }else{
            [lastWordBtn setEnabled:YES];
            [nextWordBtn setEnabled:YES];
        }
        
        NSArray *array = [dbMsg getAndCheckSentence:[vArray objectAtIndex:poz * 4]];
        
        if (array.count != 0) {
            NSString *temp = [array objectAtIndex:arc4random() % array.count];
            
            if ([[temp substringWithRange:(NSRange){0,1}]isEqualToString:@" "]) {
                temp = [temp substringWithRange:(NSRange){1,temp.length-1}];
            }
            exLabel.text = temp;
        }else{
            exLabel.text = @"";
        }
        
        wordLabel.text = [vArray objectAtIndex:poz * 4];
        meanLabel.text = [vArray objectAtIndex:poz * 4 + 1];
    }
    
    [meanBtn setHidden:NO];
}



- (void)viewDidUnload {
    wordLabel = nil;
    meanLabel = nil;
    lastWordBtn = nil;
    nextWordBtn = nil;
    meanBtn = nil;
    vocaCheckBtn = nil;
    exLabel = nil;
    [super viewDidUnload];
}
@end