//
//  SentenceProblemMaker.cpp
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 19..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#include "SentenceProblemMaker.h"
#include "GenProbUtil.h"

SentenceProblemMaker::SentenceProblemMaker(Tokenizer &tokenizer) : IProblemMaker(tokenizer)
{
    
}


SentenceProblemMaker::~SentenceProblemMaker()
{
    
}


bool SentenceProblemMaker::makeProblem(int level, int d)
{
    SQLDictionary *dic = SQLDictionary::InstancePtr();
    problem_content = tokenizer->cascadeData();
    
    std::string solution = tokenizer->munzang[std::rand()%tokenizer->munzang.size()];
    
    problem_content = JimoonMaker::replaceAll(problem_content, solution, "______________");
    
    int res = std::rand() % 4;
    
    Problem prob;
    prob.pcontent = "및줄 친 곳에 알맞은 문장을 고르시오.";
    prob.solution = res+1;
    
    for (int i=0; i<4; i++)
    {
        std::string save = "";
        
        if (res == i)
        {
            save = solution;
            prob.addItems(solution, 1, false);
        } else {
            save = dic->getRandomMunzangs(0);
            prob.addItems(save, 0, false);
        }
        prob.feedback += "("+save+") : " + getTranslate(save) + "\r";
    }
    
    problem.push_back(prob);
    
    return true;
}
