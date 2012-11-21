//
//  ProblemFactory.cpp
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 21..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#include "ProblemMakerFactory.h"


IProblemMaker *ProblemMakerFactory::create(Tokenizer &tok)
{
    
    int what = 0;
    
    if (tok.find_sooker.size() > 0)
    {
        what = std::rand()%3;
    } else {
        what = std::rand()%2;
    }
    
    // 두문장 이상일때만 출력
    if (tok.munzang.size() < 3)
        what = 0;
    
    IProblemMaker *prob =NULL;
    switch (what)
    {
        case 0:
            prob = new SimpleProblemMaker(tok);
            break;
        case 1:
            prob = new SentenceProblemMaker(tok);
            break;
        case 2:
            prob = new SookerProblemMaker(tok);
            break;
        default:
            prob = new SimpleProblemMaker(tok);
    }
    
    return prob;
}