//
//  HttpNetMananger.h
//  NetDemo
//
//  Created by     on 2017/9/14.
//  Copyright © 2017年    . All rights reserved.
//  github地址: 

#import <Foundation/Foundation.h>
#import "NSDictionary+ConvertObject.h"
#import "NetRequestInfo.h"



@class NetRequestInfo;


NS_ASSUME_NONNULL_BEGIN


#define NetCacheDuration 60*10





@interface NetMananger : NSObject


@property (nonatomic, strong)dispatch_queue_t caseyNetQueue;

+ (nonnull instancetype)sharedInstance;


/*
 请求参数体 处理
 
*/

@property (nonatomic, copy)RequsetAddBodyParamBlock requestParamCondictionBlock;


/*
    请求头参数 处理
 
*/
@property (nonatomic, copy)RequsetAddBodyParamBlock requestHeaderParamCondictionBlock;



/**
 外部添加异常处理 （根据服务器返回的数据，统一处理，如处理登录实效），默认不做处理
 */
@property (nonatomic, copy)RequestCompletionAddExcepetionHanle exceptionBlock;



// 返回NO， cache不保存
@property (nonatomic, copy)RequestAddCacheCondition cacheConditionBlock;



#pragma mark - Get Method 方法少了入参，使用默认参数

// 不使用cache
- (void)getNoCacheWithUrl:(NSString*)urlString
               parameters:(NSDictionary * _Nullable)parameters
        completionHandler:(RequestCompletionHandler)completionHandler;

// 不使用cache
- (void)getNoCacheWithUrl:(NSString*)urlString
               parameters:(NSDictionary * _Nullable)parameters
              headerParam:(NSDictionary* _Nullable)headerParam
        completionHandler:(RequestCompletionHandler)completionHandler;


// 使用cache
- (void)getCachWithUrl:(NSString*)urlString
            parameters:(NSDictionary * _Nullable)parameters
     completionHandler:(RequestCompletionHandler)completionHandler;


// 使用cache
- (void)getCacheWithUrl:(NSString*)urlString
             parameters:(NSDictionary * _Nullable)parameters
            headerParam:(NSDictionary* _Nullable)headerParam
          cacheDuration:(NSTimeInterval)cacheDuration
      completionHandler:(RequestCompletionHandler)completionHandler;


#pragma mark - POST JsonEncode Method 方法少了入参，使用默认参数
// 不使用cache
- (void)postJsonNoCacheWithURL:(NSString *)URLString
                    parameters:(NSDictionary * _Nullable)parameters
             completionHandler:(RequestCompletionHandler)completionHandler;
// 不使用cache
- (void)postJsonNoCacheWithURL:(NSString *)URLString
                    parameters:(NSDictionary * _Nullable)parameters
                   headerParam:(NSDictionary* _Nullable)headerParam
             completionHandler:(RequestCompletionHandler)completionHandler;

// 使用cache
- (void)postJsonUseCacheWithURL:(NSString *)URLString
                     parameters:(NSDictionary * _Nullable)parameters
              completionHandler:(RequestCompletionHandler)completionHandler;

// 使用cache
- (void)postJsonUseCacheWithURL:(NSString *)URLString
                     parameters:(NSDictionary * _Nullable)parameters
                    headerParam:(NSDictionary* _Nullable)headerParam
              completionHandler:(RequestCompletionHandler)completionHandler;

/**
 POST请求 参数 JSON表单
 @param URLString url地址
 @param parameters 请求参数
 @param headerParam 请求参数头
 @param ignoreCache 是否忽略缓存，YES 忽略，NO 不忽略
 @param cacheDuration 缓存实效
 @param completionHandler 请求结果处理
 */

- (void)postJsonWithURL:(NSString *)URLString
             parameters:(NSDictionary * _Nullable)parameters
            headerParam:(NSDictionary* _Nullable)headerParam
            ignoreCache:(BOOL)ignoreCache
          cacheDuration:(NSTimeInterval)cacheDuration
      completionHandler:(RequestCompletionHandler)completionHandler;






#pragma mark - POST UrlEncode Method 方法少了入参，使用默认参数

// 不使用cache
- (void)postUrlEncodeNoCacheWithURL:(NSString *)URLString
                         parameters:(NSDictionary * _Nullable)parameters
                  completionHandler:(RequestCompletionHandler)completionHandler;

// 不使用cache
- (void)postUrlEncodeNoCacheWithURL:(NSString *)URLString
                         parameters:(NSDictionary * _Nullable)parameters
                        headerParam:(NSDictionary* _Nullable)headerParam
                  completionHandler:(RequestCompletionHandler)completionHandler;

// 使用cache
- (void)postUrlEncodeUseCacheWithURL:(NSString *)URLString
                          parameters:(NSDictionary * _Nullable)parameters
                   completionHandler:(RequestCompletionHandler)completionHandler;

// 使用cache
- (void)postUrlEncodeUseCacheWithURL:(NSString *)URLString
                          parameters:(NSDictionary * _Nullable)parameters
                         headerParam:(NSDictionary* _Nullable)headerParam
                   completionHandler:(RequestCompletionHandler)completionHandler;


/**
 POST请求 参数 URLEncode表单
 @param URLString url地址
 @param parameters 请求参数
 @param headerParam 请求参数头
 @param ignoreCache 是否忽略缓存，YES 忽略，NO 不忽略
 @param cacheDuration 缓存实效
 @param completionHandler 请求结果处理
 */
- (void)postUrlEncodeWithURL:(NSString *)URLString
                  parameters:(NSDictionary * _Nullable)parameters
                 headerParam:(NSDictionary* _Nullable)headerParam
                 ignoreCache:(BOOL)ignoreCache
               cacheDuration:(NSTimeInterval)cacheDuration
           completionHandler:(RequestCompletionHandler)completionHandler;






#pragma mark - 网络请求

/**
 网络请求
 @param method 请求方式
 @param urlStr url地址
 @param parameters 请求参数
 @param headerParam 请求参数头
 @param encodeStyle 请求参数题表单格式
 @param paserStyle 响应参数解析方式
 @param ignoreCache 是否忽略缓存，YES 忽略，NO 不忽略
 @param cacheDuration 缓存实效
 @param completionHandler 请求结果处理
 */

- (void)taskWithMethod:(NSString*)method
             urlString:(NSString*)urlStr
            parameters:(NSDictionary *)parameters
           headerParam:(NSDictionary*)headerParam
      paramEncodeStyle:(ParamEncodeStyle)encodeStyle
           parserStyle:(RepsonsePaserStyle)paserStyle
           ignoreCache:(BOOL)ignoreCache
         cacheDuration:(NSTimeInterval)cacheDuration
     completionHandler:(RequestCompletionHandler)completionHandler;



@end


NS_ASSUME_NONNULL_END


