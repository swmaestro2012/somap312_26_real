//
//  Tokenizer.cpp
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 7..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#include "Tokenizer.h"
#include "SQLDictionary.h"
#include <stack>
#include <sstream>
#include <regex.h>

std::string token2str(Token &token)
{
    return token.getToken();
}


Token::Token(std::string token, enum token_type type, bool existDB) : type(type), token(token), prob_num(0), existDB(existDB)
{
    
}


Token::Token(std::string token, bool existDB) : type(TOKEN_TYPE_WORD), token(token), prob_num(0), existDB(existDB)
{
    
}

std::string Token::getToken()
{
    return token;
}

enum token_type Token::getType()
{
    return type;
}

short Token::getProbNum()
{
    return this->prob_num;
}

void Token::setProbNum(char num)
{
    this->prob_num = num;
}

bool Token::getExistDB()
{
    return this->existDB;
}


std::string Token::getOrigin()
{
    return origin;
}

void Token::setOrigin(std::string origin)
{
    this->origin = origin;
}

Tokenizer::Tokenizer(std::string origin): word_cnt(0), word_cnt_real(0), word_cnt_exist_dic(0)
{
    this->origin = JimoonMaker::replaceAll(origin, "\r\n", "\r");
    this->origin = JimoonMaker::replaceAll(this->origin, "\n", "\r");
}

Tokenizer::~Tokenizer()
{
}

void Tokenizer::run()
{
    int i;
    int buf_pos = 0;
    char buf[1024];
    //std::stack<char> nor_stack;
    bool sign = false;
    SQLDictionary dic = SQLDictionary::Instance();
    //CitarPOS *pos = CitarPOS::getInstance();
    
    //tokens.push_back(Token("<BEGIN>", false));
    
    for(i=0;i<origin.length();i++)
    {
        if ((origin[i] <= 'Z' && origin[i] >= 'A') || (origin[i] <= 'z' && origin[i] >= 'a'))
        {
            buf[buf_pos++] = origin[i];
            sign = true;
            continue;
        } else {
            if (sign)
            {
                buf[buf_pos] = '\0';
                bool existDB = dic.exsistWord(buf);
                std::vector<std::string> origins = dic.getOriginWord(buf);
                
                
                Token token(std::string(buf), existDB);
                if (origins.size() > 0)
                {
                    existDB = dic.exsistWord(origins[0].c_str());
                    token.setOrigin(origins[0]);
                }
                
                tokens.push_back(token);
                
                if (buf_pos>2)
                {
                    word_cnt_real++;
                }
                
                if(buf_pos>2 && existDB)
                {
                    word_cnt_exist_dic++;
                }
                word_cnt++;
                buf_pos = 0;
                sign = false;
            }
        }
        
        if (origin[i-1] != origin[i])
        {
            buf[0] = origin[i];
            buf[1] = '\0';
            
            Token token(std::string(buf), TOKEN_TYPE_SPECIAL, false);
            tokens.push_back(token);
            
            
        }
    }
    
    //tokens.push_back(Token("<END>", false));
    //    std::vector<std::string> sentents(tokens.size()+1);
    //    std::transform(tokens.begin(), tokens.end(), sentents.begin(), token2str);
    
    //    tag = pos->hmmTagger->tag(sentents);
    
    //    std::vector<std::string>::iterator iter;
    //    std::vector<Token>::iterator iter2;
    //    for (iter = tag.begin(), iter2 = tokens.begin(); iter != tag.end(); iter++, iter2++)
    //    {
    //        if (iter2->getType() == TOKEN_TYPE_SPECIAL)
    //            continue;
    //
    //        if (analysis.find(*iter) == analysis.end())
    //        {
    //            analysis[*iter] = 1;
    //        } else {
    //            analysis[*iter]++;
    //        }
    //    }
    //
    
    
    
    analysis_munzang();
}

void Tokenizer::trim_left( std::string& s )
{
    auto it = s.begin(), ite = s.end();
    
    while( ( it != ite ) && std::isspace( *it ) ) {
        ++it;
    }
    s.erase( s.begin(), it );
}

void Tokenizer::analysis_munzang()
{
    std::stack<char> data;
    int munzang_word = 0;
    std::vector<Token>::iterator iter;
    std::ostringstream oss;
    
    for (iter = tokens.begin(); iter != tokens.end(); iter++)
    {
        if (iter->getToken() != "\r" &&
            iter->getToken() != "\n")
        {
            oss << iter->getToken();
        }
        
        if (iter->getType() == TOKEN_TYPE_WORD)
        {
            munzang_word++;
        }
        
        if (iter->getToken() == "." ||
            iter->getToken() == "!" ||
            iter->getToken() == "?" ||
            iter->getToken() == "\r" ||
            (iter->getToken() == ":" && (iter-1)->getType() == TOKEN_TYPE_WORD ))
        {
            if (munzang_word >= 3)
            {
                std::string temp(oss.str());
                trim_left(temp);
                munzang.push_back(temp);
                munzang_count_word.push_back(munzang_word);
            }
            oss.str("");
            munzang_word = 0;
        }
    }
    
    
    analysis_sooker();
}



void Tokenizer::analysis_sooker()
{
    SQLDictionary dic = SQLDictionary::Instance();
    std::vector<std::string> sooker;
    sooker = dic.getSookEr();
    std::vector<std::string>::iterator iter;
    std::vector<std::string>::iterator iter2;
    
    
    for(iter2 = sooker.begin(); iter2 != sooker.end(); iter2++)
    {
        regex_t fsm;
        
        std::string tmp = JimoonMaker::replaceAll(*iter2, "A ", "([a-zA-Z]+ )+");
        tmp = JimoonMaker::replaceAll(tmp, "B", "[a-zA-Z]+");
        tmp = JimoonMaker::replaceAll(tmp, "B ", "([a-zA-Z]+ )+");
        tmp = JimoonMaker::replaceAll(tmp, "C", "[a-zA-Z]+");
        
        if (regcomp(&fsm, tmp.c_str(), REG_ICASE | REG_EXTENDED))
            return;
        
        for(iter = munzang.begin(); iter != munzang.end(); iter++)
        {
            regmatch_t str[iter->size()+1];
            int fMatched = regexec(&fsm, iter->c_str(), iter->size()+1, str, 0);
            
            if ( fMatched != REG_NOMATCH )
            {
                find_sooker.push_back(*iter2);
            }
        }
    }
}


std::string Tokenizer::cascadeData()
{
    std::ostringstream oss;
    
    std::vector<Token>::iterator iter;
    for(iter = tokens.begin(); iter != tokens.end(); iter++)
    {
        if (iter->getProbNum() > 0)
        {
            oss << "{1}";
            
        } else {
            oss << iter->getToken();
        }
    }
    
    return oss.str();
}


int Tokenizer::atWordToken(int num)
{
    int cnt = 0;
    int ret = 0;
    std::vector<Token>::iterator iter;
    
    for(iter = tokens.begin(); iter != tokens.end(); iter++, ret++)
    {
        if (iter->getType() == TOKEN_TYPE_WORD)
        {
            if (cnt == num)
                return ret;
            cnt++;
        }
    }
    return -1;
}


int Tokenizer::atWordRealToken(int num)
{
    int cnt = 0;
    int ret = 0;
    std::vector<Token>::iterator iter;
    
    for(iter = tokens.begin(); iter != tokens.end(); iter++, ret++)
    {
        if (iter->getType() == TOKEN_TYPE_WORD && iter->getToken().length() > 2)
        {
            if (cnt == num)
                return ret;
            cnt++;
        }
    }
    return -1;
}
int Tokenizer::atWordExistDBToken(int num)
{
    int cnt = 0;
    int ret = 0;
    std::vector<Token>::iterator iter;
    
    for(iter = tokens.begin(); iter != tokens.end(); iter++, ret++)
    {
        if (iter->getType() == TOKEN_TYPE_WORD && iter->getToken().length() > 2 && iter->getExistDB())
        {
            if (cnt == num)
                return ret;
            cnt++;
        }
    }
    return -1;
}


std::string JimoonMaker::replaceAll(const std::string &str, const std::string &pattern, const std::string &replace)
{
	std::string result = str;
	std::string::size_type pos = 0;
	std::string::size_type offset = 0;
    
	while((pos = result.find(pattern, offset)) != std::string::npos)
	{
		result.replace(result.begin() + pos, result.begin() + pos + pattern.size(), replace);
		offset = pos + replace.size();
	}
    
	return result;
}

std::string JimoonMaker::getSTRJimoon(std::string gimoon)
{
    gimoon = replaceAll(gimoon, "{1}", "[[[1]]]");
    gimoon = replaceAll(gimoon, "\r\n", "\n");
    
    return gimoon;
}


std::string JimoonMaker::getHTMLJimoon(std::string gimoon)
{
    
    std::ostringstream oss;
    
    std::vector<Token>::iterator iter;
    oss << "<html><body bgcolor=\"#CDE998\">";
    oss << "<p style=\"font-size: 13px;\">";
    
    gimoon = replaceAll(gimoon, "{1}", "<input type=\"text\" size=\"5\" style=\"text-align:center;color:red;border-color:red;\" value=\"\" />");
    
    
    oss << replaceAll(gimoon, "\r", "<br />");
    
    oss << "</p>";
    oss << "</body></html>";
    
    return oss.str();
    
    
    return gimoon;
}