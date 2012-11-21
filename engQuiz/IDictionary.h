//
//  IDictionary.h
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 7..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#ifndef engQuiz_IDictionary_h
#define engQuiz_IDictionary_h
template <typename T>

class IDictionary {
private:
    static T * ms_Instance;
    
    
public:
    static T * InstancePtr()
    {
        if( ms_Instance == NULL ) ms_Instance = new T;
        return ms_Instance;
    };
    static T & Instance()
    {
        if(ms_Instance == NULL) ms_Instance = new T;
        return *ms_Instance;
    };
    static void DestroyInstance()
    {
        delete ms_Instance;
        ms_Instance = NULL;
    };
    
    
	virtual bool exsistWord(std::string word) = 0;
	virtual std::string getRandomWord() = 0;
};

template<typename T> T* IDictionary<T>::ms_Instance = 0;

#endif
