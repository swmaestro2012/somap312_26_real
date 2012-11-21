//
//  SookerProblemMaker.cpp
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 21..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#include "SookerProblemMaker.h"
#include "GenProbUtil.h"

SookerProblemMaker::SookerProblemMaker(Tokenizer &tokenizer) : IProblemMaker(tokenizer)
{
    
}


SookerProblemMaker::~SookerProblemMaker()
{
    
}


bool SookerProblemMaker::makeProblem(int level, int d)
{
    SQLDictionary *dic = SQLDictionary::InstancePtr();
    problem_content = tokenizer->cascadeData();
    
    std::string solution = tokenizer->find_sooker[std::rand()%tokenizer->find_sooker.size()];
    
    
    
    // 숙어는 두 가지 유형이 있음.
    // 1) word word
    // 2) word A word B
    
    int res = std::rand() % 4;
    
    Problem prob;
    prob.pcontent = "빈칸에 알맞은 단어를 고르시오.";
    
    // 1번 유형
    if (solution.find("A") == std::string::npos)
    {
        problem_content = JimoonMaker::replaceAll(problem_content, solution, "{1}");
    
        prob.solution = res+1;
        
        int sol = std::rand() % 4;
        std::string simstr[3];
        
        if (!dic->getRandomSimItems(solution, simstr, 3))
        {
            simstr[0] = dic->getRandomWord();
            simstr[1] = dic->getRandomWord();
            simstr[2] = dic->getRandomWord();
        }
        
        int simcnt = 0;
        
        for (int i=0; i<4; i++)
        {
            std::string tmp;
            
            if (sol == i)
            {
                tmp = solution;
                prob.addItems(solution, 1);
            } else {
                tmp = simstr[simcnt++];
                prob.addItems(tmp, 0);
            }
            
            std::string res = dic->getWordInfo(tmp).mean;
            if (res == "")
                res = getTranslate(res);
            
            prob.feedback += "(" + tmp + "): " + res + "\r";
        }
    }
    else  // 2번 유형
    {
        int pos = solution.find("A")-1;
        std::string new_sol = solution;
        new_sol.erase(new_sol.begin()+pos, new_sol.end());
        
        problem_content = JimoonMaker::replaceAll(problem_content, new_sol, "{1}");
        
        int sol = std::rand() % 4;
        std::string simstr[3];
        
        if (!dic->getRandomSimItems(new_sol, simstr, 3))
        {
            simstr[0] = dic->getRandomWord();
            simstr[1] = dic->getRandomWord();
            simstr[2] = dic->getRandomWord();
        }
        
        int simcnt = 0;
        
        for (int i=0; i<4; i++)
        {
            
            if (sol == i)
            {
                
                std::string res = dic->getWordInfo(solution).mean;
                if (res == "")
                    res = getTranslate(res);
                
                prob.addItems(new_sol, 1);
                prob.feedback += "(" + solution + "): " + res + "\r";
            } else {
                std::string tmp = simstr[simcnt++];
                
                std::string res = dic->getWordInfo(tmp).mean;
                if (res == "")
                    res = getTranslate(res);
                
                prob.addItems(tmp, 0);
                prob.feedback += "(" + tmp + "): " + res + "\r";
            }
            
            
        }
    }
    
    problem.push_back(prob);
    
    return true;
}
