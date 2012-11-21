//
//  GenProbUtil.cpp
//  engQuiz
//
//  Created by Baek, Jinuk on 12. 11. 20..
//  Copyright (c) 2012년 박 찬기. All rights reserved.
//

#include "GenProbUtil.h"
#import "NSData+Additions.h"

std::string getTranslate(std::string str)
{
    NSString *textFrom = [@"en" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *textTo = [@"ko" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *textEscaped = [[NSString stringWithUTF8String:str.c_str()] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"https://api.datamarket.azure.com/Data.ashx/Bing/MicrosoftTranslator/v1/Translate?Text=%%27%@%%27&From=%%27%@%%27&To=%%27%@%%27&$top=100&$format=Raw",
                     textEscaped,textFrom,textTo];
    
    NSString *translation = @"";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse *response = nil;
    NSError *err = nil;
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"89EuaUmsjfzAIVRgJzGvKuaTC1TNQqEOt3e3MbU1o8U=", @"89EuaUmsjfzAIVRgJzGvKuaTC1TNQqEOt3e3MbU1o8U="];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    //[request setValue:@"Basic 89EuaUmsjfzAIVRgJzGvKuaTC1TNQqEOt3e3MbU1o8U=" forHTTPHeaderField:@"Authorization"];
    
    
    
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString* contents = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    //NSLog(@"# %@ %@ %@", fromL, toL, contents);
    //return [self translateCharacters: [[[contents JSONValue] objectForKey: @"responseData"] objectForKey: @"translatedText"]];
    
    NSRange match;
    match = [contents rangeOfString: @">"];
    contents = [contents substringFromIndex: match.location+1];
    
    match = [contents rangeOfString: @"<"];
    translation = [contents substringWithRange: NSMakeRange (0, match.location)];
    //NSLog(@"%@", contents);

    
    return std::string([translation UTF8String]);
    
}