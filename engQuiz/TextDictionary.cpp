#include "TextDictionary.h"
#include <fstream>
#include <algorithm>
#include <ctime>


TextDictionary::TextDictionary(void)
{
	std::ifstream in;

	in.open("Dictionary.txt", std::ios::in);
	
	while(!in.eof())
	{
		std::string word, mean;
		in >> word;
		std::getline(in, mean);

		dic.insert(std::pair<std::string, std::string> (word, mean));
	}

	in.close();
}


TextDictionary::~TextDictionary(void)
{
}

bool TextDictionary::exsistWord(std::string word)
{
	std::map<std::string, std::string>::iterator it;
	it = dic.find(word);

	if (it == dic.end())
	{
		return false;
	}

	return true;
}



std::string TextDictionary::getRandomWord()
{
	//std::srand(time(NULL));

	int n = std::rand() % dic.size();

	std::map<std::string, std::string>::iterator iter;
	iter = dic.begin();
	while (n--) { iter++; };

	return iter->first;
}