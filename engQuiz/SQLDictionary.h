//
//  SQLDictionary.h
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 7..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#ifndef __engQuiz__SQLDictionary__
#define __engQuiz__SQLDictionary__

#include <iostream>
#include "IDictionary.h"
#include "IProblemMaker.h"
#include <vector>

class Word;

class SQLDictionary : public IDictionary<SQLDictionary>
{
public:
	virtual bool exsistWord(std::string word);
	virtual std::string getRandomWord();
    Word getWordInfo(std::string word);
    bool getRandomSimItems(std::string word, std::string data[], int length);
    std::string getRandomMunzangs(int excnum);
    std::vector<std::string> getOriginWord(std::string word);
    std::vector<std::string> getSookEr();
};

#endif /* defined(__engQuiz__SQLDictionary__) */
