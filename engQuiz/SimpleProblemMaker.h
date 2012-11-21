#pragma once
#include "iproblemmaker.h"
#include "SQLDictionary.h"
#include "Tokenizer.h"


class SimpleProblemMaker :
public IProblemMaker
{
    bool procReal();
    bool procExistDic();
	SQLDictionary *dic;
public:
	SimpleProblemMaker(Tokenizer &tokenizer);
	~SimpleProblemMaker(void);
	virtual bool makeProblem(int level, int d);
};

