//
//  GenTable.h
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 9..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#ifndef __engQuiz__GenTable__
#define __engQuiz__GenTable__

#include <iostream>
#include <vector>

class GenTableData
{
public:
    GenTableData(std::string label, int success, int fail);
    
    std::string label;
    int fail;
    int success;
};

class GenTable
{
    static std::string replaceAll(const std::string &str, const std::string &pattern, const std::string &replace);
public:
    std::vector<GenTableData> datas;
    std::string run();
    std::string run_gchart(const char *path, std::string title, std::string axisy);
    
};

#endif /* defined(__engQuiz__GenTable__) */
