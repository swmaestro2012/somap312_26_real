//
//  DataBase.h
//  engQuiz
//
//  Created by 박 찬기 on 12. 10. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"

@interface DataBase : NSObject{
    sqlite3 *database;
}
+ (DataBase*) getInstance;

-(void)LoadDataBaseFile;
-(void)fileList;

-(NSMutableArray *)getPublisherIds;
-(NSString *)getPublisherName:(int)_id;

-(NSMutableArray *)getBookIds:(int)pNum:(int)cNum1:(int)cNum2;
-(NSString *)getBookName:(int)_id;

-(NSMutableArray *)getInsertBook;
-(NSMutableArray *)getInsertBookGroup;
-(NSMutableArray *)getInsertBookFromGroup:(NSString *)group;

-(NSMutableArray *)getExamIds:(int)bId;
-(NSMutableArray *)getExamTheme:(int)_id;
-(NSString *)getExamSentence:(int)_id;

-(NSMutableArray *)getVocaData:(int)type:(int)check;
-(NSMutableArray *)searchVoca:(NSString *)msg:(int)type:(int)check;

-(NSMutableArray *)getChapterData:(int)bid;
-(NSMutableArray *)getThemeData:(int)cid;

-(int)saveRSentence:(NSString *)content:(NSString *)date:(int)type;
-(int)saveRQuestion:(int)sid:(NSString *)qtext:(int)qnumber:(NSString*) feedback;
-(void)saveRAnswer:(int)pid:(NSString *)qcontent:(int)solution;

-(void)setVocaCheck:(int)did:(int)check;

-(NSMutableArray *)getAndCheckSentence:(NSString *)word;

-(void)deleteRdata:(int)cid;

-(void)deleteInsertSentence:(int)_id;

-(NSString *)getMean:(NSString *)word;

-(NSMutableArray *)getReservedRSentenceData:(int)cid;
-(NSMutableArray *)getRSentenceData:(int)type;
-(NSMutableArray *)getRQuestion:(int)tid;
-(NSMutableArray *)getRAnswer:(int)pid;


-(bool)existsWord:(NSString *)word;
-(NSString *)getRandomWord;
-(NSString *)getRandomMunzang:(int)excnum;
-(NSMutableArray *)getWordInformation:(NSString*)word;
-(NSMutableArray *)getNormWord:(NSString*)word;

-(void)saveSentence:(NSString *)sentence:(NSString *)gdate:(NSString *)groupname:(NSString *)theme;

-(void)vocaXUpdate:(NSString *)word:(Boolean)check;

-(int)checkMakedProblem:(int)type;

-(void)logUpdate:(NSString *)date:(NSString *)content:(Boolean)check;

-(NSMutableArray *)getLogData:(int)type:(int)yy:(int)mm:(int)dd;

-(void)dataInit;

-(int)getStteingData;
-(void)updateClass:(int)c;


-(void)updateThemeAndGroup:(int)_id Theme:(NSString *)theme Group:(NSString *)group;
@end