//
//  NetRequestInfo.h
//  NetDemo
//
//  Created by     on 2017/9/15.
//  Copyright © 2017年    . All rights reserved.
//  github地址: 

#import <Foundation/Foundation.h>

@class NetMananger;


// 请求公用参数
typedef NSDictionary* (^RequsetAddCommonBodyParamBlock)(NSDictionary *paramDict);

// 请求体公用参数
typedef NSDictionary* (^RequestCompletionAddExcepetionHanle)(NSError* _Nullable errror, NSString * _Nullable cacheKey, NSDictionary* result);
typedef BOOL (^RequestAddCacheCondition)(NSDictionary *result);

typedef void (^RequestCompletionHandler)( NSError* _Nullable error,  BOOL isCache, NSDictionary* _Nullable result);
typedef void (^netSuccessbatchBlock)(NSArray *operationAry);




typedef enum : NSUInteger {
    RequestBodyJsonEncode = 0,
    RequestBodyUrlEncode,
    RequestBodyStringEncode
} ParamEncodeStyle;

typedef enum : NSInteger {
    JsonParser = 0,
    XmlParser,
    FileParser
} RepsonsePaserStyle;




NS_ASSUME_NONNULL_BEGIN




@interface NetRequestInfo : NSObject


@property(nonatomic, strong)NSString *urlStr;
@property(nonatomic, strong)NSString *method;
@property(nonatomic, strong)NSDictionary *parameters;
@property(nonatomic, strong)NSDictionary *headerParam;
@property(nonatomic, assign)ParamEncodeStyle paramEncodeStyle;
@property(nonatomic, assign)RepsonsePaserStyle responsePaserStyle;
@property(nonatomic, assign)BOOL ignoreCache;
@property(nonatomic, assign)NSTimeInterval cacheDuration;
@property(nonatomic, copy)RequestCompletionHandler completionBlock;


/**
 NetRequestInfo 创建
 @param URLString url地址
 @param method 请求方式
 @param parameters 请求参数
 @param headerParam 请求参数头
 @param style 请求参数题表单格式
 @param ignoreCache 是否忽略缓存，YES 忽略，NO 不忽略
 @param cacheDuration 缓存实效
 @param completionHandler 请求结果处理
 */
+ (NetRequestInfo*)requestWithURL:(NSString *)URLString
                           method:(NSString*)method
                       parameters:(NSDictionary *)parameters
                      headerParam:(NSDictionary*)headerParam
                       bodyEncode:(ParamEncodeStyle)style
                      ignoreCache:(BOOL)ignoreCache
                    cacheDuration:(NSTimeInterval)cacheDuration
                completionHandler:(RequestCompletionHandler)completionHandler;



#pragma mark - GET


+ (NetRequestInfo*)getCacheWithURL:(NSString *)URLString
                        parameters:(NSDictionary *)parameters
                       headerParam:(NSDictionary*)headerParam
                 completionHandler:(RequestCompletionHandler)completionHandler;


+ (NetRequestInfo*)getNoCacheWithURL:(NSString *)URLString
                          parameters:(NSDictionary *)parameters
                         headerParam:(NSDictionary*)headerParam
                   completionHandler:(RequestCompletionHandler)completionHandler;

#pragma mark - POST

+ (NetRequestInfo*)postJsonNoCacheWithURL:(NSString *)URLString
                               parameters:(NSDictionary *)parameters
                              headerParam:(NSDictionary*)headerParam
                        completionHandler:(RequestCompletionHandler)completionHandler;



+ (NetRequestInfo*)postURLEncodeNoCacheWithURL:(NSString *)URLString
                                    parameters:(NSDictionary *)parameters
                                   headerParam:(NSDictionary*)headerParam
                             completionHandler:(RequestCompletionHandler)completionHandler;


+ (NetRequestInfo*)postJsonCacheWithURL:(NSString *)URLString
                             parameters:(NSDictionary *)parameters
                            headerParam:(NSDictionary*)headerParam
                      completionHandler:(RequestCompletionHandler)completionHandler;

+ (NetRequestInfo*)postURLEncodeCacheWithURL:(NSString *)URLString
                                  parameters:(NSDictionary *)parameters
                                 headerParam:(NSDictionary*)headerParam
                           completionHandler:(RequestCompletionHandler)completionHandler;






@end





NS_ASSUME_NONNULL_END
