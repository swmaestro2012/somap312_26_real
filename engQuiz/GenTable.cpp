//
//  GenTable.cpp
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 9..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#include "GenTable.h"
#include <fstream>
#include <sstream>

#define HEIGHT_PIXEL 300


GenTableData::GenTableData(std::string label, int success, int fail)
: label(label), fail(fail), success(success)
{
    
}

std::string GenTable::run_gchart(const char *path, std::string title, std::string axisy)
{
    // 자료가 없으면 출력 안함
    if (datas.size() == 0)
    {
        return "자료가 없습니다.";
    }
    
    std::string str;
    std::vector<GenTableData>::iterator iter;
   
    std::ifstream is(path);
    std::ostringstream oss;
    
    while ( getline(is, str) )
    {
        oss << str;
    }
    
    str = oss.str();
    
    std::ostringstream oss2;
    
    oss2 << "[ ";
    // 헤더
    oss2 << "['', '맞은갯수', '틀린갯수', '총합'],";
 
    // 내용
    for (iter = datas.begin(); iter!=datas.end(); iter++)
    {
        if (iter != datas.begin())
        {
            oss2 << ",";
        }
        oss2 << "['" << iter->label << "', ";
        oss2 << "" << iter->success << ", ";
        oss2 << "" << iter->fail << ",";
        oss2 << "" << (iter->success+iter->fail) << "]";
    }
    
    oss2 << "]";
    
    str = replaceAll(str, "{0}", oss2.str());
    str = replaceAll(str, "{1}", title);
    str = replaceAll(str, "{2}", axisy);
    
    return str;
}

std::string GenTable::replaceAll(const std::string &str, const std::string &pattern, const std::string &replace)
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

std::string GenTable::run()
{
    std::string str;
    std::ostringstream oss(str);
    
    
    int maxdata = 0;
    
    std::vector<GenTableData>::iterator iter;
    
    oss << "<table border=\"0\" width=\"90%\" >";
    
    for (iter = datas.begin(); iter!=datas.end(); iter++)
    {
        int total;
        total = iter->fail + iter->success;
        
        maxdata = std::max(total, maxdata);
    }
    
    oss << "<tr>";
    for (iter = datas.begin(); iter!=datas.end(); iter++)
    {
        oss << "<td width=\"" << 100/datas.size() << "%\"  valign=\"bottom\">";
        oss << "<table border=\"0\" width=\"100%\" height=\"" << HEIGHT_PIXEL << "\">";
        
        
        // 공백
        oss << "<tr>";
        oss << "<td bgcolor=\"white\" height=\"" << (int)(HEIGHT_PIXEL * ((maxdata-iter->success-iter->fail)/(double)maxdata)) << "\">";
        oss << "&nbsp;";
        oss << "</td>";
        oss << "</tr>";
        
        
        // 성공
        oss << "<tr>";
        oss << "<td bgcolor=\"blue\" height=\"" << (int)(HEIGHT_PIXEL * ((iter->success)/(double)maxdata)) << "\">";
        oss << "<center>";
        oss << iter->success;
        oss << "</center>";
        oss << "</td>";
        oss << "</tr>";
        
        
        // 실패
        oss << "<tr>";
        oss << "<td bgcolor=\"red\" height=\"" << (int)(HEIGHT_PIXEL * ((iter->fail)/(double)maxdata)) << "\">";
        oss << "<center>";
        oss << iter->fail;
        oss << "</center>";
        oss << "</td>";
        oss << "</tr>";
        
        oss << "</table>";
        oss << "</td>";
    }
    oss << "</tr>";
    
    
    // 레이블 출력
    oss << "<tr>";
    for (iter = datas.begin(); iter!=datas.end(); iter++)
    {
        oss << "<td>";
        oss << iter->label;
        oss << "</td>";
    }
    oss << "</tr>";
    
    oss << "</table>";
    
    return oss.str();
}