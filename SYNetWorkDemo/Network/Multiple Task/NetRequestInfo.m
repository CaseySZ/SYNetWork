//
//  NetRequestInfo.m
//  NetDemo
//
//  Created by     on 2017/9/15.
//  Copyright © 2017年    . All rights reserved.
//

#import "NetRequestInfo.h"
#import "NetMananger.h"


NS_ASSUME_NONNULL_BEGIN



@implementation NetRequestInfo



+ (NetRequestInfo*)requestWithURL:(NSString *)URLString
                           method:(NSString*)method
                       parameters:(NSDictionary *)parameters
                      headerParam:(NSDictionary*)headerParam
                       bodyEncode:(ParamEncodeStyle)style
                      ignoreCache:(BOOL)ignoreCache
                    cacheDuration:(NSTimeInterval)cacheDuration
                completionHandler:(RequestCompletionHandler)completionHandler{
    
    NetRequestInfo *requestInfo =  [NetRequestInfo new];
    requestInfo.urlStr = URLString;
    requestInfo.method = method;
    requestInfo.parameters = parameters;
    requestInfo.headerParam = headerParam;
    requestInfo.paramEncodeStyle = style;
    requestInfo.responsePaserStyle = JsonParser;
    requestInfo.ignoreCache = ignoreCache;
    requestInfo.cacheDuration = cacheDuration;
    requestInfo.completionBlock = completionHandler;
    return requestInfo;
}



#pragma mark - Get


+ (NetRequestInfo*)getCacheWithURL:(NSString *)URLString
                        parameters:(NSDictionary *)parameters
                        headerParam:(NSDictionary*)headerParam
                 completionHandler:(RequestCompletionHandler)completionHandler{
    
    NetRequestInfo *requestInfo =  [NetRequestInfo new];
    requestInfo.urlStr = URLString;
    requestInfo.method = @"GET";
    requestInfo.parameters = parameters;
    requestInfo.headerParam = headerParam;
    requestInfo.paramEncodeStyle = RequestBodyUrlEncode;
    requestInfo.responsePaserStyle = JsonParser;
    requestInfo.ignoreCache = NO;
    requestInfo.cacheDuration = NetCacheDuration;
    requestInfo.completionBlock = completionHandler;
    return requestInfo;
}




+ (NetRequestInfo*)getNoCacheWithURL:(NSString *)URLString
                                  parameters:(NSDictionary *)parameters
                                 headerParam:(NSDictionary*)headerParam
                           completionHandler:(RequestCompletionHandler)completionHandler{
    
    NetRequestInfo *requestInfo =  [NetRequestInfo new];
    requestInfo.urlStr = URLString;
    requestInfo.method = @"GET";
    requestInfo.parameters = parameters;
    requestInfo.headerParam = headerParam;
    requestInfo.paramEncodeStyle = RequestBodyUrlEncode;
    requestInfo.responsePaserStyle = JsonParser;
    requestInfo.ignoreCache = YES;
    requestInfo.cacheDuration = NetCacheDuration;
    requestInfo.completionBlock = completionHandler;
    return requestInfo;
}


#pragma mark - POST


+ (NetRequestInfo*)postJsonNoCacheWithURL:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                headerParam:(NSDictionary*)headerParam
                               completionHandler:(RequestCompletionHandler)completionHandler{
    
    NetRequestInfo *requestInfo =  [NetRequestInfo new];
    requestInfo.urlStr = URLString;
    requestInfo.method = @"POST";
    requestInfo.parameters = parameters;
    requestInfo.headerParam = headerParam;
    requestInfo.paramEncodeStyle = RequestBodyJsonEncode;
    requestInfo.responsePaserStyle = JsonParser;
    requestInfo.ignoreCache = YES;
    requestInfo.cacheDuration = 0;
    requestInfo.completionBlock = completionHandler;
    return requestInfo;
}


+ (NetRequestInfo*)postURLEncodeNoCacheWithURL:(NSString *)URLString
                               parameters:(NSDictionary *)parameters
                              headerParam:(NSDictionary*)headerParam
                        completionHandler:(RequestCompletionHandler)completionHandler{
    
    NetRequestInfo *requestInfo =  [NetRequestInfo new];
    requestInfo.urlStr = URLString;
    requestInfo.method = @"POST";
    requestInfo.parameters = parameters;
    requestInfo.headerParam = headerParam;
    requestInfo.paramEncodeStyle = RequestBodyUrlEncode;
    requestInfo.responsePaserStyle = JsonParser;
    requestInfo.ignoreCache = YES;
    requestInfo.cacheDuration = 0;
    requestInfo.completionBlock = completionHandler;
    return requestInfo;
}




+ (NetRequestInfo*)postJsonCacheWithURL:(NSString *)URLString
                               parameters:(NSDictionary *)parameters
                              headerParam:(NSDictionary*)headerParam
                        completionHandler:(RequestCompletionHandler)completionHandler{
    
    NetRequestInfo *requestInfo =  [NetRequestInfo new];
    requestInfo.urlStr = URLString;
    requestInfo.method = @"POST";
    requestInfo.parameters = parameters;
    requestInfo.headerParam = headerParam;
    requestInfo.paramEncodeStyle = RequestBodyJsonEncode;
    requestInfo.responsePaserStyle = JsonParser;
    requestInfo.ignoreCache = NO;
    requestInfo.cacheDuration = NetCacheDuration;
    requestInfo.completionBlock = completionHandler;
    return requestInfo;
}


+ (NetRequestInfo*)postURLEncodeCacheWithURL:(NSString *)URLString
                                    parameters:(NSDictionary *)parameters
                                   headerParam:(NSDictionary*)headerParam
                             completionHandler:(RequestCompletionHandler)completionHandler{
    
    NetRequestInfo *requestInfo =  [NetRequestInfo new];
    requestInfo.urlStr = URLString;
    requestInfo.method = @"POST";
    requestInfo.parameters = parameters;
    requestInfo.headerParam = headerParam;
    requestInfo.paramEncodeStyle = RequestBodyUrlEncode;
    requestInfo.responsePaserStyle = JsonParser;
    requestInfo.ignoreCache = NO;
    requestInfo.cacheDuration = NetCacheDuration;
    requestInfo.completionBlock = completionHandler;
    return requestInfo;
}



@end


NS_ASSUME_NONNULL_END


