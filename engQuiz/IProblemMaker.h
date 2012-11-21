#pragma once

#include "Tokenizer.h"
#include "SQLDictionary.h"
#include <string>
#include <vector>

#define MAX_ITEMS_LENGTH 4

class SQLDictionary;

class ProblemItem
{
public:
    std::string qcontent;
	int solution;
};

class Problem
{
public:
    std::string pcontent;
    std::string feedback;
    std::vector <ProblemItem> items;
    int solution;
    std::string getFeedBack();

	void addItems(std::string qcontent, int solution, bool lower=true);

	Problem();
	~Problem();
};

class Word
{
public:
    std::string word;
    std::string mean;
    int dtype;
    int wtype;
    std::string sim;
    int vcheck;
    std::string wclass;
    std::string exps;
};

class IProblemMaker
{
protected:
    Tokenizer *tokenizer;
	std::vector<Problem> problem;
	std::string example;
	std::string problem_content;
public:
    
	IProblemMaker(Tokenizer &tokenizer);
	virtual ~IProblemMaker(void);
	virtual bool makeProblem(int level, int num) = 0;
	std::vector<Problem> &getProblems();
	std::string getProblemContent();

};

