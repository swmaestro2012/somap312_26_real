//
//  SQLDictionary.cpp
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 7..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#include "SQLDictionary.h"
#include "DataBase.h"
#include <sstream>

bool SQLDictionary::exsistWord(std::string word)
{
    DataBase *dbMsg;
    
    dbMsg = [DataBase getInstance];
    
    bool result;
    
    NSString* nsword = [NSString stringWithUTF8String:word.c_str()];
    
    result = [dbMsg existsWord: nsword ];
    
    return result;
}


std::string SQLDictionary::getRandomWord()
{
    DataBase *dbMsg;
    
    dbMsg = [DataBase getInstance];
    
    std::string result([[dbMsg getRandomWord] UTF8String]);
    
    
    
    return result;
}


Word SQLDictionary::getWordInfo(std::string word)
{
    Word clsword;
    DataBase *dbMsg;
    
    dbMsg = [DataBase getInstance];
    
    NSString *nsword = [NSString stringWithUTF8String:word.c_str()];
    
    NSMutableArray *result = [dbMsg getWordInformation:nsword];
    
    if ([result count] == 0)
    {
        clsword.word = "";
        return clsword;
    }
    
    // 단어
    
    clsword.word = word;
    
    // 의미
    clsword.mean = std::string([[result objectAtIndex:1] UTF8String]);
    clsword.dtype = [[result objectAtIndex:2] intValue];
    clsword.wtype = [[result objectAtIndex:3] intValue];
    clsword.sim = std::string([[result objectAtIndex:4] UTF8String]);
    clsword.wclass =std::string([[result objectAtIndex:5] UTF8String]);
    clsword.exps = std::string([[result objectAtIndex:6] UTF8String]);
    clsword.vcheck = [[result objectAtIndex:7] intValue];
    
    return clsword;
}
bool SQLDictionary::getRandomSimItems(std::string word, std::string data[], int length)
{
    if (length > 10)
        return false;
    
    Word wordinfo = getWordInfo(word);
    
    // 사전에 없는 경우.
    if (wordinfo.word == "")
        return false;
    
    std::vector<std::string> wordtok;
    
    std::istringstream iss(wordinfo.sim);
    std::string substr;
    
    while (getline(iss, substr, ','))
    {
        int t;
        
        if (substr == word) {
            continue;
        }
        
        
        for (t=0; t<wordtok.size(); t++)
        {
            if (substr == wordtok[t])
                break;
        }
        if(t==wordtok.size())
            wordtok.push_back(substr);
    }
    
    int remain = length;
    for (int i=0; i<length; i++)
    {
        int sel = std::rand() % remain--;
        
        data[i] = wordtok[sel];
        wordtok.erase(wordtok.begin()+sel);
    }
    
    return true;
}

std::vector<std::string> SQLDictionary::getOriginWord(std::string word)
{
    std::vector<std::string> strs;
    
    DataBase *dMsg = [DataBase getInstance];
    
    NSMutableArray *arr = [dMsg getNormWord:[NSString stringWithUTF8String:word.c_str()]];
    
    int cnt = 0;
    while (cnt<[arr count])
    {
        std::string origin([[arr objectAtIndex:cnt] UTF8String]);
        cnt++;
        std::istringstream sim([[arr objectAtIndex:cnt] UTF8String]);
        cnt++;
        std::string substr;
        
        while (getline(sim, substr, ','))
        {
            if (word == substr)
            {
                strs.push_back(origin);
                break;
            }
        }
    }
    
    return strs;
}

std::string SQLDictionary::getRandomMunzangs(int excnum)
{
    DataBase *dMsg = [DataBase getInstance];
    
    std::string result([[dMsg getRandomMunzang:excnum] UTF8String]);
    
    Tokenizer tok(result);
    tok.run();
    
    /// 너무 긴거 자르기;
    for (std::vector<std::string>::iterator iter = tok.munzang.begin(); iter != tok.munzang.end(); iter++)
    {
        if (iter->size() > 40)
        {
            tok.munzang.erase(iter);
            iter = tok.munzang.begin();
        }
    }
    
    std::string ret = tok.munzang[std::rand()%tok.munzang.size()];
    
    return ret;
}


std::vector<std::string> SQLDictionary::getSookEr()
{
    DataBase *dMsg = [DataBase getInstance];
    std::vector<std::string> ret;
    
    NSMutableArray *arr = [dMsg getVocaData:2:0];
    
    
    for (int i=0; i<[arr count]; i+=4)
    {
        std::string tmp = [[arr objectAtIndex:i] UTF8String];
        ret.push_back(tmp);
    }
    
    return ret;
}
