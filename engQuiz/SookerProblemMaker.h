//
//  SookerProblemMaker.h
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 21..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#ifndef __engQuiz__SookerProblemMaker__
#define __engQuiz__SookerProblemMaker__

#include <iostream>
#include "iproblemmaker.h"
#include "SQLDictionary.h"
#include "Tokenizer.h"


class SookerProblemMaker :
public IProblemMaker
{
    SQLDictionary *dic;
public:
	SookerProblemMaker(Tokenizer &tokenizer);
	~SookerProblemMaker();
	virtual bool makeProblem(int level, int d);
};


#endif /* defined(__engQuiz__SookerProblemMaker__) */
