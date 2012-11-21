//
//  Tokenizer.h
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 7..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#ifndef __engQuiz__Tokenizer__
#define __engQuiz__Tokenizer__

#include <vector>
#include <string>
#include <map>

enum token_type
{
    TOKEN_TYPE_WORD,
    TOKEN_TYPE_SPECIAL,
};


class Token
{
    std::string token;
    std::string origin;
    enum token_type type;
    char prob_num;
    bool existDB;
public:
    Token(std::string token, bool existDB);
    Token(std::string token, enum token_type type, bool existDB);
    inline std::string getToken();
    inline enum token_type getType();
    inline bool getExistDB();
    inline short getProbNum();
    std::string getOrigin();
    void setProbNum(char num);
    void setOrigin(std::string origin);
};


class Tokenizer
{
    void analysis_munzang();
    static void trim_left( std::string& s );
    void analysis_sooker();
public:
    std::vector<Token> tokens;
    std::vector<std::string> munzang;
    std::vector<int> munzang_count_word;
    std::vector<std::string> tag;
    std::string origin;
    int word_cnt;
    int word_cnt_real;
    int word_cnt_exist_dic;
    std::map<std::string, int> analysis;
    std::vector<std::string> find_sooker;
    
    Tokenizer(std::string origin);
    ~Tokenizer();
    void run();
    std::string cascadeData();
    int atWordToken(int num);
    int atWordRealToken(int num);
    int atWordExistDBToken(int num);
    
};

class JimoonMaker
{
public:
    static std::string replaceAll(const std::string &str, const std::string &pattern, const std::string &replace);
    static std::string getSTRJimoon(std::string gimoon);
    static std::string getHTMLJimoon(std::string gimoon);
};

#endif /* defined(__engQuiz__Tokenizer__) */
