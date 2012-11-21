//
//  CitarPOS.h
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 17..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#ifndef __engQuiz__CitarPOS__
#define __engQuiz__CitarPOS__

#include <iostream>
#include <vector>
#include <sstream>
#include <stack>
#include <algorithm>
#include <vector>

#include <tr1/memory>

#include <citar/corpus/TaggedWord.hh>
#include <citar/tagger/hmm/HMMTagger.hh>
#include <citar/tagger/hmm/LinearInterpolationSmoothing.hh>
#include <citar/tagger/hmm/Model.hh>
#include <citar/tagger/wordhandler/KnownWordHandler.hh>
#include <citar/tagger/wordhandler/SuffixWordHandler.hh>

class CitarPOS
{
    citar::tagger::SuffixWordHandler *suffixWordHandler;
    citar::tagger::KnownWordHandler *knownWordHandler;
    citar::tagger::LinearInterpolationSmoothing *smoothing;
    CitarPOS(std::string lexicon, std::string ngrams);
    static CitarPOS *instance;
    static bool init;
public:
    ~CitarPOS();
    std::tr1::shared_ptr<citar::tagger::HMMTagger> hmmTagger;
    std::tr1::shared_ptr<citar::tagger::Model> model;
    static void initInstance(std::string lexicon, std::string ngrams);
    static CitarPOS *getInstance();
    static void releaseInstance();
};

#endif /* defined(__engQuiz__CitarPOS__) */
