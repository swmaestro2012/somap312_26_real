//
//  NSStringRegular.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 15..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "NSStringRegular.h"

@implementation NSStringRegular

-(NSString *)stringChange:(NSString *)msg{
    NSError *error   = nil;
    
    msg = [msg stringByReplacingOccurrencesOfString :@"'" withString:@"’"];
    msg = [msg stringByReplacingOccurrencesOfString :@"\n" withString:@"\r"];
//    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9:space:|-|_|?|:|&|;|,|.|!|'|\"]" options:0 error:&error];
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z0-9:space:|-|_|?|:|&|;|,|.|!|’|\"]" options:0 error:&error];
    
    NSString *resultSentence = @"";
    for (int i = 0; i < msg.length; i++) {
        NSTextCheckingResult *match = [regexp firstMatchInString:[msg substringWithRange:(NSRange){i,1}] options:0 range:NSMakeRange(0, [msg substringWithRange:(NSRange){i,1}].length)];
        if(match.numberOfRanges!=0){
            resultSentence = [NSString stringWithFormat:@"%@%@",resultSentence,[msg substringWithRange:(NSRange){i,1}]];
            
        }else if([[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"\r"]||
                 [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@" "]){
            resultSentence = [NSString stringWithFormat:@"%@%@",resultSentence,[msg substringWithRange:(NSRange){i,1}]];
        }
    }
    return resultSentence;
}
-(NSString *)stringPaste:(NSString *)msg{
//    NSString *resultTemp = @"";
    NSString *resultTemp = msg;
    int count = 0;
    while (count < resultTemp.length) {
        if ([[msg substringWithRange:(NSRange){count,1}] isEqualToString:@"\r"]
            || [[msg substringWithRange:(NSRange){count,1}] isEqualToString:@"\n"]
            || [[msg substringWithRange:(NSRange){count,1}] isEqualToString:@"\r\n"]) {
            if (![[msg substringWithRange:(NSRange){count -1,1}] isEqualToString:@"!"]&
                ![[msg substringWithRange:(NSRange){count -1,1}] isEqualToString:@"."]&
                ![[msg substringWithRange:(NSRange){count -1,1}] isEqualToString:@" "]&
                ![[msg substringWithRange:(NSRange){count -1,1}] isEqualToString:@"\""]&
                ![[msg substringWithRange:(NSRange){count -1,1}] isEqualToString:@"?"]) {
                
//                NSLog(@"%@",[msg substringWithRange:(NSRange){count -1,1}]);
                
                resultTemp = [NSString stringWithFormat:@"%@ %@",[resultTemp substringWithRange:(NSRange){0, count}],[resultTemp substringWithRange:(NSRange){count + 1, msg.length - count - 1}]];
                
                count ++;
            }else{
                count++;
            }
        }else{
            count++;
        }
        
//        NSLog(@"%d",count);
    }

//    for (int i = 1; i < msg.length - 1; i++) {
////        if([[msg substringWithRange:(NSRange){i,2}] isEqualToString:@"\r "]
////           || [[msg substringWithRange:(NSRange){i,2}] isEqualToString:@"\n "]
////           || [[msg substringWithRange:(NSRange){i,2}] isEqualToString:@"\r\n "]) {
////        }else {
//
//        if ([[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"\r"]
//            || [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"\n"]
//                || [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"\r\n"]) {
//            if (![[msg substringWithRange:(NSRange){i -1,1}] isEqualToString:@"!"]||
//                ![[msg substringWithRange:(NSRange){i -1,1}] isEqualToString:@"."]||
//                ![[msg substringWithRange:(NSRange){i -1,1}] isEqualToString:@"\""]||
//                ![[msg substringWithRange:(NSRange){i -1,1}] isEqualToString:@" "]||
//                ![[msg substringWithRange:(NSRange){i -1,1}] isEqualToString:@"?"]) {
//                
//                resultTemp = [NSString stringWithFormat:@"%@ %@",[resultTemp substringWithRange:(NSRange){0, i}],[msg substringWithRange:(NSRange){i + 1, msg.length - i - 1}]];
//            }
////            else if(![[msg substringWithRange:(NSRange){i +1,1}] isEqualToString:@" "] && i <msg.length - 1){
////                
////                resultTemp = [NSString stringWithFormat:@"%@\r%@",[resultTemp substringWithRange:(NSRange){0, i}],[msg substringWithRange:(NSRange){i + 1, msg.length - i - 1}]];
////                
////                NSLog(@"cc");
////            }
////        }
//        }
//    }
    
    return resultTemp;
}
@end
