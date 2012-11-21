//
//  ProblemFactory.h
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 21..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#ifndef __engQuiz__ProblemMakerFactory__
#define __engQuiz__ProblemMakerFactory__

#include <iostream>
#include "IProblemMaker.h"
#include "SimpleProblemMaker.h"
#include "SentenceProblemMaker.h"
#include "SookerProblemMaker.h"

class ProblemMakerFactory
{
public:
    static IProblemMaker *create(Tokenizer &tok);
};
#endif /* defined(__engQuiz__ProblemMakerFactory__) */
