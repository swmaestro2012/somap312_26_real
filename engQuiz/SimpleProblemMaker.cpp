#include "SimpleProblemMaker.h"
#include "GenProbUtil.h"
#include <sstream>
#include <vector>
#include <ctime>

SimpleProblemMaker::SimpleProblemMaker(Tokenizer &tokenizer) : IProblemMaker(tokenizer)
{
    dic = SQLDictionary::InstancePtr();
}


SimpleProblemMaker::~SimpleProblemMaker(void)
{
}

bool SimpleProblemMaker::makeProblem(int level, int num)
{
	std::istringstream iss(example);
    this->example = example;
	std::srand(time(NULL));
    bool res;
    
    if (tokenizer->word_cnt_exist_dic > 0)
    {
        res = procExistDic();
    } else {
        res = procReal();
    }
    
	return res;
}

bool SimpleProblemMaker::procReal()
{
    int num_ex, num_real;
	///////////////////// 문제생성
	Problem prob;
    
    num_ex = std::rand() % tokenizer->word_cnt_real;
    num_real = tokenizer->atWordRealToken(num_ex);
    
    std::string solution = tokenizer->tokens[num_real].getToken();
    
	tokenizer->tokens[num_real].setProbNum((char)1);
    
	problem_content = tokenizer->cascadeData();
    
	prob.pcontent = "빈칸에 알맞은 단어를 고르시오.";
	
	int sol = std::rand() % 4;
    
	for (int i=0; i<4; i++)
	{
		if (sol == i)
		{
			prob.addItems(solution, 1);
		} else {
			prob.addItems(dic->getRandomWord(), 0);
		}
	}
    
	problem.push_back(prob);
    
    return true;
}

bool SimpleProblemMaker::procExistDic()
{
    int num_ex, num_real;
    bool bOrigin =  false;
	///////////////////// 문제생성
	Problem prob;
    
    num_ex = std::rand() % tokenizer->word_cnt_exist_dic;
    num_real = tokenizer->atWordExistDBToken(num_ex);
    
    std::string solution = tokenizer->tokens[num_real].getToken();
    if (!dic->exsistWord(solution))
        bOrigin = true;
    
	tokenizer->tokens[num_real].setProbNum((char)1);
    
	problem_content = tokenizer->cascadeData();
    
	prob.pcontent = "빈칸에 알맞은 단어를 고르시오.";
	
	int sol = std::rand() % 4;
    std::string simstr[3];
    
    if (!dic->getRandomSimItems(solution, simstr, 3))
    {
        return false;
    }
    
    int simcnt = 0;
	for (int i=0; i<4; i++)
	{
        std::string tmp;
        
		if (sol == i)
		{
            tmp = solution;
            
            if (bOrigin)
            {
                tmp = tokenizer->tokens[num_real].getOrigin();
            }
            
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
    
	problem.push_back(prob);
    
    return true;
}
