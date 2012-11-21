//
//  SentenceProblemMaker.h
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 19..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#ifndef __engQuiz__SentenceProblemMaker__
#define __engQuiz__SentenceProblemMaker__

#include <iostream>
#include "iproblemmaker.h"
#include "SQLDictionary.h"
#include "Tokenizer.h"


class SentenceProblemMaker :
public IProblemMaker
{
    SQLDictionary *dic;
public:
	SentenceProblemMaker(Tokenizer &tokenizer);
	~SentenceProblemMaker();
	virtual bool makeProblem(int level, int d);
};


#endif /* defined(__engQuiz__SentenceProblemMaker__) */
