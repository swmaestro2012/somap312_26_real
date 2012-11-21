//
//  DataBase.m
//  engQuiz
//
//  Created by 박 찬기 on 12. 10. 27..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#import "DataBase.h"


#define DataBase_Name @"engquiz.sqlite"
#define Publisher_TableName @"Publisher"
#define Book_TableName @"Book"
#define ContentBook_TableName @"contentbook"
#define Dictionary_TableName @"dictionary"
#define Chapter_TableName @"chapter"

#define Problem_TableName @"problem"
#define Problemitem_TableName @"problemitem"
#define Contenttray_TableName @"contenttray"

#define GetContentBook_TableName @"getcontentbook"
#define Log_content_TableName @"log_content"
#define settingtable_TableName @"settingtable"

@implementation DataBase
+ (DataBase*) getInstance{
    static DataBase* _db = nil;
    
    if (_db == nil) {
        _db = [[DataBase alloc] init];
    }
    
    return _db;
}

-(void)LoadDataBaseFile{
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DataBase_Name];
    
    NSString *testFilePath = [documentsDirectory stringByAppendingPathComponent:@"test.txt"];
    
    
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if([fileMgr fileExistsAtPath:filePath]){
        NSLog(@"file exist");
        
        //        [fileMgr removeItemAtPath:filePath error:&error];
        //
        //        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"engquiz" ofType:@"sqlite"];
        //
        //        [fileMgr copyItemAtPath:resourcePath toPath:filePath error:&error];
        
    }else {
        NSLog(@"file not exist");
        
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"engquiz" ofType:@"sqlite"];
        
        [fileMgr copyItemAtPath:resourcePath toPath:filePath error:&error];
        
    }
    //
    //    if (![fileMgr fileExistsAtPath:testFilePath]) {
    //        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    //
    //        [fileMgr copyItemAtPath:resourcePath toPath:testFilePath error:&error];
    //    }else{
    //        [fileMgr removeItemAtPath:testFilePath error:&error];
    //        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
    //
    //        [fileMgr copyItemAtPath:resourcePath toPath:testFilePath error:&error];
    //    }
    
    
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        
        NSLog(@"Error");
    }else{
        NSLog(@"Create / Open DataBase");
    }
    
}

-(void)fileList{
    
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT _id FROM Exam"];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            NSLog(@"%@",[NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)]);
            
        }
        
    }else {
        NSLog(@"fail");
    }
    
    sqlite3_finalize(selectStatement);
    
}

-(NSMutableArray *)getPublisherIds{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT pid FROM %@",Publisher_TableName];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}


-(NSString *)getPublisherName:(int)_id{
    NSString *data;
    sqlite3_stmt *selectStatement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT content FROM %@ WHERE pid = %d",Publisher_TableName,_id];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            NSString *msg = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            
            data = [NSString stringWithFormat:@"%@", msg];
            
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return data;
}







-(NSMutableArray *)getBookIds:(int)pNum:(int)cNum1:(int)cNum2{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT bid FROM %@ ",Book_TableName];
    
    NSString *q1 = [NSString stringWithFormat:@"pid = %d",pNum];
    NSString *q2 = [NSString stringWithFormat:@"class1 = %d",cNum1];
    NSString *q3 = [NSString stringWithFormat:@"class2 = %d",cNum2];
    
    if (pNum != 0) {
        query = [NSString stringWithFormat:@"%@ WHERE %@",query, q1];
        count++;
    }
    if (cNum1 != 0) {
        if (count == 0) {
            query = [NSString stringWithFormat:@"%@ WHERE %@",query, q2];
        }else {
            query = [NSString stringWithFormat:@"%@ And %@",query, q2];
        }
        count++;
    }
    if (cNum2 != 0) {
        if (count == 0) {
            query = [NSString stringWithFormat:@"%@ WHERE %@",query, q3];
        }else {
            query = [NSString stringWithFormat:@"%@ And %@",query, q3];
        }
    }
    
    count = 0;
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    //    NSLog(@"count :: %d",array.count);
    
    return array;
}


-(NSString *)getBookName:(int)_id{
    NSString *data;
    sqlite3_stmt *selectStatement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT name FROM %@ WHERE bid = %d",Book_TableName,_id];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            NSString *msg = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            
            data = [NSString stringWithFormat:@"%@", msg];
            
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return data;
}

-(NSMutableArray *)getInsertBook{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT id, content, groupname, theme FROM %@",GetContentBook_TableName];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3) ] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(NSMutableArray *)getInsertBookGroup{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT DISTINCT groupname FROM %@",GetContentBook_TableName];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(NSMutableArray *)getInsertBookFromGroup:(NSString *)group{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT id, content, groupname, theme FROM %@ WHERE groupname = '%@'",GetContentBook_TableName,group];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3) ] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(NSMutableArray *)getExamIds:(int)bId{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT id FROM %@ WHERE cid = %d",ContentBook_TableName, bId];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}


-(NSMutableArray *)getExamTheme:(int)_id{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    sqlite3_stmt *selectStatement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT theme, pagemin, pagemax FROM %@ WHERE id = %d",ContentBook_TableName,_id];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ] atIndex:0];
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 1)] atIndex:1];
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 1)] atIndex:2];
            
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(NSString *)getExamSentence:(int)_id{
    NSString *data;
    sqlite3_stmt *selectStatement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT text FROM %@ WHERE id = %d",ContentBook_TableName,_id];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            NSString *msg = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            
            data = [NSString stringWithFormat:@"%@", msg];
            
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return data;
}

-(NSMutableArray *)getVocaData:(int)type:(int)check{
    
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    sqlite3_stmt *selectStatement;
    int count = 0;
    NSString *query;
    if (check == 3) {
        if (type == 0) {
            query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@",Dictionary_TableName];
        }else {
            query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE wtype = %d",Dictionary_TableName,type];
        }
    }else{
        if (type == 0) {
            query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE vcheck = %d",Dictionary_TableName, check];
        }else {
            query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE wtype = %d AND vcheck = %d",Dictionary_TableName,type,check];
        }
    }
    
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ] atIndex:count];
            
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3) ] atIndex:count];
            count++;
            
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(NSMutableArray *)searchVoca:(NSString *)msg:(int)type:(int)check{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    NSString *query;
    
    sqlite3_stmt *selectStatement;
    
    
    
    if (check == 3) {
        if (type == 0) {
            
            query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE word LIKE '%@%%' ORDER BY word ASC" ,Dictionary_TableName,msg];
        }else {
            query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE word LIKE '%@%%' And wtype = %d ORDER BY word ASC",Dictionary_TableName,msg,type];
        }
    }else if (check == 2){
        //        if (type == 0) {
        query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE word LIKE '%@%%' AND checker > 0 ORDER BY checker DESC",Dictionary_TableName,msg];
        //        }else {
        //            query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE word LIKE '%@%%' And wtype = %d AND checker >= '1' ORDER BY word ASC",Dictionary_TableName,msg,type];
        //        }
    }else{
        if (type == 0) {
            query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE word LIKE '%@%%' And vcheck = %d ORDER BY word ASC",Dictionary_TableName,msg, check];
        }else {
            query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE word LIKE '%@%%' And wtype = %d AND vcheck = %d ORDER BY word ASC",Dictionary_TableName,msg,type,check];
        }
    }
    
    
    //    query = [NSString stringWithFormat:@"SELECT word, mean, dtype, did FROM %@ WHERE word LIKE '%@%%'",Dictionary_TableName,msg];
    //    query = [NSString stringWithFormat:@"SELECT word, mean, type, class FROM %@ WHERE word LIKE '%%%@%%'",Voca_TableName,msg];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ] atIndex:count];
            
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3) ] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    
    
    return array;
}




-(NSMutableArray *)getChapterData:(int)bid{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    sqlite3_stmt *selectStatement;
    int count = 0;
    
    NSString *query = [NSString stringWithFormat:@"SELECT cid, text FROM %@ WHERE bid = %d",Chapter_TableName, bid];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}


-(NSMutableArray *)getThemeData:(int)cid{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    sqlite3_stmt *selectStatement;
    int count = 0;
    
    NSString *query = [NSString stringWithFormat:@"SELECT id, theme, text FROM %@ WHERE cid = %d",ContentBook_TableName, cid];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
            count++;
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

- (int)saveRSentence:(NSString *)content:(NSString *)date:(int)type{
    sqlite3_stmt *insertStatement;
    
    int sid;
    
    NSLog(@"content  :: %@ ,, date :: %@ ,, tyep :: %d",content, date, type);
    
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (content,gdate,type) VALUES('%@','%@',%d)",Contenttray_TableName,content,date,type];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(insertStatement, 2, insertSql,  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }else{
            sqlite3_stmt *selectStatement;
            NSString *squery = [NSString stringWithFormat:@"SELECT cid FROM %@ ORDER BY cid DESC LIMIT 1",Contenttray_TableName];
            
            const char *selectSql = [squery UTF8String];
            
            if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
                
                // while문을 돌면서 각 레코드의 데이터를 받아서 출력한다.
                if (sqlite3_step(selectStatement) == SQLITE_ROW) {
                    sid = sqlite3_column_int(selectStatement, 0);
                }
                
            }
            
            //statement close
            sqlite3_finalize(selectStatement);
        }
    }
    
    sqlite3_finalize(insertStatement);
    
    return sid;
}
-(int)saveRQuestion:(int)sid:(NSString *)qtext:(int)qnumber:(NSString*) feedback{
    sqlite3_stmt *insertStatement;
    int qid;
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (pid,level,pcontent,feedback) VALUES(%d,%d,'%@','%@')",Problem_TableName,sid,qnumber,qtext,feedback];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(insertStatement, 2, insertSql,  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }else{
            sqlite3_stmt *selectStatement;
            NSString *squery = [NSString stringWithFormat:@"SELECT tid FROM %@ ORDER BY pid DESC LIMIT 1",Problem_TableName];
            
            const char *selectSql = [squery UTF8String];
            
            if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
                
                // while문을 돌면서 각 레코드의 데이터를 받아서 출력한다.
                while (sqlite3_step(selectStatement) == SQLITE_ROW) {
                    qid = sqlite3_column_int(selectStatement, 0);
                }
                
            }
            
            //statement close
            sqlite3_finalize(selectStatement);
        }
    }
    
    sqlite3_finalize(insertStatement);
    
    return qid;
}

-(void)saveRAnswer:(int)pid:(NSString *)qcontent:(int)solution{
    sqlite3_stmt *insertStatement;
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (pid,qcontent,solution) VALUES(%d,'%@',%d)",Problemitem_TableName,pid,qcontent,solution];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(insertStatement, 2, insertSql,  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }
    }
    sqlite3_finalize(insertStatement);
}


-(void)setVocaCheck:(int)did:(int)check{
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET vcheck = %d  WHERE did = %d",Dictionary_TableName,check,did];
    
    const char *updateSql = [query UTF8String];
    
    if (sqlite3_exec(database, updateSql, nil,nil,nil) != SQLITE_OK) {
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
    }
    
}

-(NSMutableArray *)getAndCheckSentence:(NSString *)word{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    
    //    NSString *result = @"단어가 없습니다";
    int check = 0;
    Boolean checkOut = false;
    int index = 0;
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT text FROM %@ WHERE text LIKE '%%%@%%'",ContentBook_TableName,word];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            NSString *temp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0)];
            int tempInt;
            index = 0;
            check = 0;
            NSString *resultTemp = temp;
            
            while (!checkOut) {
                if ((tempInt = [temp rangeOfString:word options:NSCaseInsensitiveSearch].location) != 0 && [temp rangeOfString:word options:NSCaseInsensitiveSearch].location <= temp.length) {
                    NSLog(@"check ::: %d",tempInt);
                    
                    if ([[temp substringWithRange:(NSRange){tempInt - 1, 1}] isEqualToString:@" "]||
                        [[temp substringWithRange:(NSRange){tempInt - 1, 1}] isEqualToString:@""]||
                        [[temp substringWithRange:(NSRange){tempInt - 1, 1}] isEqualToString:@"."]){
                        check++;
                        NSLog(@"check1");
                    }
                    
                    if ([[temp substringWithRange:(NSRange){tempInt + word.length, 1}] isEqualToString:@" "]||
                        [[temp substringWithRange:(NSRange){tempInt + word.length, 1}] isEqualToString:@""]||
                        [[temp substringWithRange:(NSRange){tempInt + word.length, 1}] isEqualToString:@"."]||
                        [[temp substringWithRange:(NSRange){tempInt + word.length, 1}] isEqualToString:@"!"]||
                        [[temp substringWithRange:(NSRange){tempInt + word.length, 1}] isEqualToString:@"?"]) {
                        check++;
                        NSLog(@"check2");
                        
                    }
                    
                    
                    if (check != 2) {
                        index = index + tempInt + 1;
                        
                        NSLog(@"check 2 == %d",index);
                        temp = [temp substringWithRange:(NSRange){tempInt+1, temp.length - (tempInt+1)}];
                        check = 0;
                    }else{
                        index = index + tempInt + 1;
                        break;
                    }
                    
                }else {
                    checkOut = true;
                    check = 0;
                }
            }
            
            checkOut = false;
            
            if (check == 2) {
                
                //                NSLog(@"%d",resultTemp.length);
                resultTemp = [resultTemp substringWithRange:(NSRange){[self leftCheck:resultTemp :index] + 1, [self rightCheck:resultTemp :index] - [self leftCheck:resultTemp :index]}];
                NSLog(@"%@\nindex :: %d",resultTemp,index);
                [array insertObject:resultTemp atIndex:count];
                count++;
                
                if (count == 3) {
                    break;
                }
            }else {
                check = 0;
            }
            
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(int)leftCheck:(NSString *)msg:(int)poz{
    int result = -1;
    int check = 0;
    for (int i = poz; i > 0; i--) {
        if([[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"."]||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"\n"]||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@","]||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"?"]||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@":"]||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"."]){
            check = 1;
            result = i;
            break;
        }
    }
    return result;
}

-(int)rightCheck:(NSString *)msg:(int)poz{
    int result = msg.length - 1;
    
    int check = 0;
    for (int i = poz; i < msg.length; i++) {
        if([[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"."] ||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"\n"]||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@""]||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"!"]||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@":"]||
           [[msg substringWithRange:(NSRange){i,1}] isEqualToString:@"?"]){
            check = 1;
            result = i;
            break;
        }
    }
    return result;
}


-(void)deleteRdata:(int)cid{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE cid = %d",Contenttray_TableName,cid];
    
    const char *delSql = [query UTF8String];
    
    
    if (sqlite3_exec(database, delSql, nil,nil,nil) != SQLITE_OK) {
        
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
        
        
        sqlite3_stmt *selectStatement;
        
        query = [NSString stringWithFormat:@"SELECT tid FROM %@ WHERE pid = %d",Problem_TableName,cid];
        
        const char *selectSql = [query UTF8String];
        
        if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
            while (sqlite3_step(selectStatement) == SQLITE_ROW) {
                NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE pid = %d",Problemitem_TableName,[[NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] intValue]];
                
                const char *delSql = [query UTF8String];
                
                
                if (sqlite3_exec(database, delSql, nil,nil,nil) != SQLITE_OK) {
                    
                    NSLog(@"Error");
                }else{
                    NSLog(@"OK");
                }
            }
        }
        
        sqlite3_finalize(selectStatement);
        
        
        query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE pid = %d",Problem_TableName,cid];
        delSql = [query UTF8String];
        if (sqlite3_exec(database, delSql, nil,nil,nil) != SQLITE_OK) {
            
            NSLog(@"Error");
        }else{
            NSLog(@"다 지웠다 ㅋㅋㅋ ");
        }
    }
}



-(void)deleteInsertSentence:(int)_id{
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %d",GetContentBook_TableName,_id];
    
    const char *delSql = [query UTF8String];
    
    
    if (sqlite3_exec(database, delSql, nil,nil,nil) != SQLITE_OK) {
        
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
    }
}


-(NSString *)getMean:(NSString *)word{
    NSString *data;
    sqlite3_stmt *selectStatement;
    
    NSString *query = [NSString stringWithFormat:@"SELECT mean FROM %@ WHERE word = '%@'",Dictionary_TableName,word];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            NSString *msg = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            
            data = [NSString stringWithFormat:@"%@", msg];
            
        }
    }
    
    sqlite3_finalize(selectStatement);
    
    return data;
}

-(NSMutableArray *)getRSentenceData:(int)type{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT cid, content, gdate FROM %@ WHERE type = %d",Contenttray_TableName,type];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
            count++;
            
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}



-(NSMutableArray *)getReservedRSentenceData:(int)cid{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT cid, content, gdate FROM %@ WHERE cid = %d ",Contenttray_TableName, cid];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
            count++;
            
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}



-(int)checkMakedProblem:(int)type{    int n = -1;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT tid FROM %@ WHERE id = %d",ContentBook_TableName,type];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            n = sqlite3_column_int(selectStatement, 0);
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return n;
}

-(NSMutableArray *)getRQuestion:(int)tid{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT pid, pcontent, feedback FROM %@ WHERE tid = %d",Problem_TableName,tid];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
            count++;
            
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(NSMutableArray *)getRAnswer:(int)pid{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT piid, qcontent, solution FROM %@ WHERE pid = %d",Problemitem_TableName,pid];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 2)] atIndex:count];
            count++;
            
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}



-(bool)existsWord:(NSString *)word{
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT word FROM %@ WHERE lower(word) = lower('%@')",
                       Dictionary_TableName,word];
    
    const char *selectSql = [query UTF8String];
    bool result = false;
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(selectStatement) == SQLITE_ROW) {
            result = true;
            
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return result;
}


-(NSString *)getRandomWord{
    
    sqlite3_stmt *selectStatement;
    NSString *res = @"";
    NSString *query = [NSString stringWithFormat:@"SELECT word FROM %@ ORDER BY RANDOM() LIMIT 1",
                       Dictionary_TableName];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(selectStatement) == SQLITE_ROW)
        {
            res = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0)];
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return res;
}

-(NSString *)getRandomMunzang:(int)excnum{
    
    sqlite3_stmt *selectStatement;
    NSString *res = @"";
    NSString *query = [NSString stringWithFormat:@"SELECT text FROM %@ where id <> %d ORDER BY RANDOM() LIMIT 1 ;",
                       ContentBook_TableName, excnum];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(selectStatement) == SQLITE_ROW)
        {
            res = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0)];
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return res;
}


-(NSMutableArray *)getWordInformation:(NSString*)word{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT word, mean, dtype, wtype, sim, wclass, exps, vcheck FROM %@ WHERE lower(word) = lower('%@');",Dictionary_TableName,word];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSString stringWithUTF8String: (char *)sqlite3_column_text(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 4) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 5) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 6) ] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 7) ] atIndex:count];
            count++;
            
            
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(NSMutableArray *)getNormWord:(NSString*)word{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    
    sqlite3_stmt *selectStatement;
    NSString *query = [NSString stringWithFormat:@"SELECT word, exps FROM %@ WHERE exps like lower('%%%@%%');",Dictionary_TableName,word];
    
    const char *selectSql = [query UTF8String];
    
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(selectStatement) == SQLITE_ROW) {
            
            [array insertObject: [NSString stringWithUTF8String: (char *)sqlite3_column_text(selectStatement, 0)] atIndex:count];
            count++;
            [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
            count++;
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(void)saveSentence:(NSString *)sentence:(NSString *)gdate:(NSString *)groupname:(NSString *)theme{
    sqlite3_stmt *insertStatement;
    NSString *query = [NSString stringWithFormat:@"INSERT INTO %@ (content,gdate,groupname,theme) VALUES('%@','%@','%@', '%@')",GetContentBook_TableName,sentence,gdate,groupname,theme];
    
    const char *insertSql = [query UTF8String];
    
    //프리페어스테이트먼트를 사용
    if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
        
        sqlite3_bind_text(insertStatement, 2, insertSql,  -1, SQLITE_TRANSIENT);
        
        // sql문 실행
        if (sqlite3_step(insertStatement) != SQLITE_DONE) {
            NSLog(@"Error");
            
        }else {
            NSLog(@"sentence Save");
        }
    }else {
        NSLog(@"error");
    }
    
    sqlite3_finalize(insertStatement);
}


-(void)vocaXUpdate:(NSString *)word:(Boolean)check{
    
    
    sqlite3_stmt *selectStatement;
    int checkCount = 0;
    NSString *query = [NSString stringWithFormat:@"SELECT checker FROM %@ WHERE word = '%@'",
                       Dictionary_TableName,word];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(selectStatement) == SQLITE_ROW)
        {
            checkCount =[[NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] intValue];
            if (check) {
                checkCount = checkCount - 2;
            }else{
                checkCount = checkCount + 3;
            }
            
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    
    query = [NSString stringWithFormat:@"UPDATE %@ SET checker = %d  WHERE word = '%@'",Dictionary_TableName,checkCount,word];
    
    const char *updateSql = [query UTF8String];
    
    if (sqlite3_exec(database, updateSql, nil,nil,nil) != SQLITE_OK) {
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
    }
}


-(void)logUpdate:(NSString *)date:(NSString *)content:(Boolean)check{
    sqlite3_stmt *selectStatement;
    int _id = 0;
    int trueCount = 0;
    int falseCount = 0;
    NSString *query = [NSString stringWithFormat:@"SELECT lcid,truecount,falsecount FROM %@ WHERE lid = '%@' And log_text ='%@'", Log_content_TableName,date,content];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(selectStatement) == SQLITE_ROW)
        {
            _id =[[NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] intValue];
            trueCount =[[NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 1)] intValue];
            falseCount =[[NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 2)] intValue];
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    
    if (_id == 0) {
        if (check) {
            trueCount++;
        }else {
            falseCount++;
        }
        sqlite3_stmt *insertStatement;
        query = [NSString stringWithFormat:@"INSERT INTO %@ (lid,log_text,truecount,falsecount) VALUES('%@','%@',%d,%d)",Log_content_TableName,date,content,trueCount,falseCount];
        
        const char *insertSql = [query UTF8String];
        
        //프리페어스테이트먼트를 사용
        if (sqlite3_prepare_v2(database, insertSql, -1, &insertStatement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text(insertStatement, 2, insertSql,  -1, SQLITE_TRANSIENT);
            
            // sql문 실행
            if (sqlite3_step(insertStatement) != SQLITE_DONE) {
                NSLog(@"Error");
                
            }else {
                NSLog(@"sentence Save");
            }
        }else {
            NSLog(@"error");
        }
        
        sqlite3_finalize(insertStatement);
        
    }else {
        if (check) {
            trueCount++;
        }else {
            falseCount++;
        }
        query = [NSString stringWithFormat:@"UPDATE %@ SET truecount = %d, falsecount = %d  WHERE lcid = %d",Log_content_TableName,trueCount,falseCount,_id];
        
        const char *updateSql = [query UTF8String];
        
        if (sqlite3_exec(database, updateSql, nil,nil,nil) != SQLITE_OK) {
            NSLog(@"Error");
        }else{
            NSLog(@"OK");
        }
    }
}


-(NSMutableArray *)getLogData:(int)type:(int)yy:(int)mm:(int)dd{
    NSMutableArray *array =[NSMutableArray arrayWithCapacity:0];
    int count = 0;
    NSString *query = @"";
    int maxCount = 0;
    
    sqlite3_stmt *selectStatement;
    
    if (type == 0) {
        query = [NSString stringWithFormat:@"SELECT lcid, lid, truecount, falsecount FROM %@ WHERE log_text = 'problem' ORDER BY log_text DESC",Log_content_TableName];
        
        maxCount = 7 * 4;
        
        const char *selectSql = [query UTF8String];
        
        
        if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
            
            while (sqlite3_step(selectStatement) == SQLITE_ROW && count < maxCount) {
                
                [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] atIndex:count];
                count++;
                [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1) ] atIndex:count];
                count++;
                [array insertObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2) ] atIndex:count];
                count++;
                [array insertObject: [NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 3)] atIndex:count];
                count++;
                
            }
            
        }
        
    }else if (type == 1) {
        
        int trueCount = 0;
        int falseCount = 0;
        
        int check = 0;
        int y = yy;
        int m = mm;
        
        //        NSString *tempMonth = @"";
        //        if (m < 10) {
        //            tempMonth = [NSString stringWithFormat:@"0%d",m];
        //        }else{
        //            tempMonth = [NSString stringWithFormat:@"%d",m];
        //        }
        
        for (int i = 0; i < 12; i++) {
            
            
            NSString *tempMonth = @"";
            if (m < 10) {
                tempMonth = [NSString stringWithFormat:@"0%d",m];
            }else{
                tempMonth = [NSString stringWithFormat:@"%d",m];
            }
            
            //            NSString *date = [NSString stringWithFormat:@"%d%d",y,m];
            
            NSString *date = [NSString stringWithFormat:@"%d%@",y,tempMonth];
            
            
            query = [NSString stringWithFormat:@"SELECT truecount, falsecount FROM %@ WHERE log_text = 'problem' And lid LIKE '%@%%' ORDER BY log_text",Log_content_TableName,date];
            
            
            const char *selectSql = [query UTF8String];
            
            
            if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
                
                while (sqlite3_step(selectStatement) == SQLITE_ROW) {
                    trueCount = trueCount + [[NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 0)] intValue];
                    falseCount = falseCount + [[NSNumber numberWithInteger: sqlite3_column_int(selectStatement, 1)] intValue];
                    
                    check = 1;
                }
                
            }
            
            if (check == 1) {
                check = 0;
                [array insertObject:date atIndex:count];
                count++;
                [array insertObject:[NSNumber numberWithInt:trueCount] atIndex:count];
                count++;
                [array insertObject:[NSNumber numberWithInt:falseCount] atIndex:count];
                count++;
                
                m--;
                if (m < 1) {
                    m = 12;
                    y = y - 1;
                }
            }
        }
        
    }
    sqlite3_finalize(selectStatement);
    
    return array;
}

-(void)dataInit{
    
    sqlite3_close(database);
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DataBase_Name];
    
    
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if([fileMgr fileExistsAtPath:filePath]){
        NSLog(@"file exist");
        
        [fileMgr removeItemAtPath:filePath error:&error];
        
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"engquiz" ofType:@"sqlite"];
        
        [fileMgr copyItemAtPath:resourcePath toPath:filePath error:&error];
        
    }else {
        NSLog(@"file not exist");
        
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"engquiz" ofType:@"sqlite"];
        
        [fileMgr copyItemAtPath:resourcePath toPath:filePath error:&error];
        
    }
    
    
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        
        NSLog(@"Error");
    }else{
        NSLog(@"Create / Open DataBase");
    }
}

-(int)getStteingData{
    sqlite3_stmt *selectStatement;
    int res = 0;
    NSString *query = [NSString stringWithFormat:@"SELECT class FROM %@",
                       settingtable_TableName];
    
    const char *selectSql = [query UTF8String];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        if (sqlite3_step(selectStatement) == SQLITE_ROW)
        {
            res = sqlite3_column_int(selectStatement, 0);
        }
        
    }
    
    sqlite3_finalize(selectStatement);
    
    return res;
}
-(void)updateClass:(int)c{
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET class = %d",settingtable_TableName,c];
    
    const char *updateSql = [query UTF8String];
    
    if (sqlite3_exec(database, updateSql, nil,nil,nil) != SQLITE_OK) {
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
    }
    
}

-(void)updateThemeAndGroup:(int)_id Theme:(NSString *)theme Group:(NSString *)group{
    NSString *query = [NSString stringWithFormat:@"UPDATE %@ SET theme = '%@', groupname = '%@' WHERE id = %d",GetContentBook_TableName,theme,group,_id];
    
    const char *updateSql = [query UTF8String];
    
    if (sqlite3_exec(database, updateSql, nil,nil,nil) != SQLITE_OK) {
        NSLog(@"Error");
    }else{
        NSLog(@"OK");
    }
}


@end
