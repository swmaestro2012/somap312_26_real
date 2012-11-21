//
//  CitarPOS.cpp
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 17..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#include "CitarPOS.h"
#include <fstream>

CitarPOS *CitarPOS::instance = NULL;

CitarPOS::CitarPOS(std::string lexicon, std::string ngrams)
{
    std::ifstream lexiconStream(lexicon.c_str());
    std::ifstream nGramStream(ngrams.c_str());
    
    model = citar::tagger::Model::readModel(lexiconStream, nGramStream);
    
	suffixWordHandler = new citar::tagger::SuffixWordHandler(model, 2, 2, 8);
    
	knownWordHandler = new citar::tagger::KnownWordHandler(model, suffixWordHandler);
    
	smoothing = new citar::tagger::LinearInterpolationSmoothing(model);
    
    
	hmmTagger = std::tr1::shared_ptr<citar::tagger::HMMTagger>(new citar::tagger::HMMTagger(model,
                                                                                            knownWordHandler, smoothing));
}

CitarPOS::~CitarPOS()
{
    delete suffixWordHandler;
    delete knownWordHandler;
    delete smoothing;
}

void CitarPOS::initInstance(std::string lexicon, std::string ngrams)
{
    if (instance != NULL)
        return ;
    instance = new CitarPOS(lexicon, ngrams);
}

CitarPOS *CitarPOS::getInstance()
{
    if (!instance)
        return NULL;
    
    return instance;
}

void CitarPOS::releaseInstance()
{
    if (instance != NULL)
    {
        delete instance;
        instance = NULL;
    }
}