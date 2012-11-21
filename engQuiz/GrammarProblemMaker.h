//
//  GrammarProblemMaker.h
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 16..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#ifndef __engQuiz__GrammarProblemMaker__
#define __engQuiz__GrammarProblemMaker__

#include <iostream>
#include "iproblemmaker.h"
#include "SQLDictionary.h"
#include "Tokenizer.h"


class GrammarProblemMaker :
public IProblemMaker
{
    SQLDictionary *dic;
public:
	GrammarProblemMaker(Tokenizer &tokenizer);
	~GrammarProblemMaker();
	virtual bool makeProblem(int level, int d);
};


#endif /* defined(__engQuiz__GrammarProblemMaker__) */
