#include "IProblemMaker.h"
#include <algorithm>


Problem::Problem()
{
}

void Problem::addItems(std::string qcontent, int solution, bool lower)
{
	ProblemItem item;
    
    if (lower)
        std::transform(qcontent.begin(), qcontent.end(), qcontent.begin(), tolower);
	item.qcontent = qcontent;
	item.solution = solution;
    
	items.push_back(item);
    
    if (solution > 0)
    {
        this->solution = items.size();
    }
}


std::string Problem::getFeedBack()
{
    return feedback;
}

Problem::~Problem()
{
}


IProblemMaker::IProblemMaker(Tokenizer& tokenizer)
{
    this->tokenizer = &tokenizer;
}

IProblemMaker::~IProblemMaker()
{
}


std::string IProblemMaker::getProblemContent()
{
	return problem_content;
}

std::vector<Problem> &IProblemMaker::getProblems()
{
	return problem;
}
