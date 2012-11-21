//
//  InsertSentence.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 11. 15..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"

@interface InsertSentence : NSObject{
    DataBase *dbMsg;
}

- (void)insert:(NSString *)sentence theme:(NSString *)theme group:(NSString *)group;
@end
