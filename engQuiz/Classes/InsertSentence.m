//
//  InsertSentence.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 15..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "InsertSentence.h"

@implementation InsertSentence

- (id)init
{
    self = [super init];
    if (self) {
        dbMsg = [DataBase getInstance];
    }
    return self;
}

- (void)insert:(NSString *)sentence theme:(NSString *)theme group:(NSString *)group{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    int year = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    [dateFormatter setDateFormat:@"MM"];
    int month = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    [dateFormatter setDateFormat:@"dd"];
    int day = [[dateFormatter stringFromDate:[NSDate date]] intValue];
    
    NSString *tempMonth = @"";
    NSString *tempDay = @"";
    if (month < 10) {
        tempMonth = [NSString stringWithFormat:@"0%d",month];
    }else{
        tempMonth = [NSString stringWithFormat:@"%d",month];
    }
    
    if (day < 10) {
        tempDay = [NSString stringWithFormat:@"0%d",day];
    }else{
        tempDay = [NSString stringWithFormat:@"%d",day];
    }
    
    NSString *date =[NSString stringWithFormat:@"%d%@%@",year,tempMonth,tempDay];
    
//    NSString *str1 =[NSString stringWithString :@"abc def hij"];
//    NSString *insertMsg = [sentence stringByReplacingOccurrencesOfString :@"'" withString:@"/'"];
    
    [dbMsg saveSentence:[NSString stringWithFormat:@"%@",sentence] :date :group:theme];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bookTableReload" object:nil];
}

@end
