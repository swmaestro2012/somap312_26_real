#pragma once

#include <map>
#include <string>
#include "IDictionary.h"

class TextDictionaryWord
{
	int level; // Do not use
	std::string word;
	std::string mean;
};

class TextDictionary : public IDictionary<TextDictionary>
{
	std::map<std::string, std::string> dic;
public:
	TextDictionary(void);
	~TextDictionary(void);
	virtual bool exsistWord(std::string word);
	virtual std::string getRandomWord();
};

