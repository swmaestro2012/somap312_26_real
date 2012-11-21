//
//  ExSentence.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 9..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"

@interface ExSentence : UIView{
    DataBase *dbMsg;
    IBOutlet UILabel *wordLabel;
    IBOutlet UITextView *exTextView;
    IBOutlet UILabel *meanLabel;
    
    NSString *word;
    NSString *mean;
    
    int getId;
}

-(void)setWord:(NSString *)_word:(NSString *)_mean:(int)_id;
- (IBAction)exitBtn:(id)sender;
- (IBAction)vocaCheckBtnEvent:(id)sender;

@end
