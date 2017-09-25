//
//  SYHttpNetMananger.h
//  SYNetDome
//
//  Created by ksw on 2017/9/14.
//  Copyright © 2017年 ksw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYNetRequestInfo.h"

NS_ASSUME_NONNULL_BEGIN




@interface SYNetMananger : NSObject

+ (nonnull instancetype)sharedInstance;


/**
 外部添加异常处理 （根据服务器返回的数据，统一处理，如处理登录实效），默认不做处理
 */
@property (nonatomic, copy)SYRequestCompletionAddExcepetionHanle exceptionBlock;



/**
 POST请求

 @param URLString url地址
 @param parameters 请求参数
 @param ignoreCache 是否忽略缓存，YES 忽略，NO 不忽略
 @param cacheDuration 缓存实效
 @param completionHandler 请求结果处理
 */
- (void)sunyPostWithURLString:(NSString *)URLString
               parameters:(NSDictionary *)parameters
              ignoreCache:(BOOL)ignoreCache
            cacheDuration:(NSTimeInterval)cacheDuration
        completionHandler:(SYRequestCompletionHandler)completionHandler;


/**
 GET请求
 
 @param URLString url地址
 @param parameters 请求参数
 @param ignoreCache 是否忽略缓存，YES 忽略，NO 不忽略
 @param cacheDuration 缓存实效
 @param completionHandler 请求结果处理
 */
- (void)sunyGetWithURLString:(NSString *)URLString
              parameters:(NSDictionary *)parameters
             ignoreCache:(BOOL)ignoreCache
           cacheDuration:(NSTimeInterval)cacheDuration
       completionHandler:(SYRequestCompletionHandler)completionHandler;




/**
 保存网络请求信息 和 batchOfRequestOperations方法一起用
 */
- (SYNetRequestInfo*)sunyNetRequestWithURLStr:(NSString *)URLString
                                     method:(NSString*)method
                                 parameters:(NSDictionary *)parameters
                                ignoreCache:(BOOL)ignoreCache
                              cacheDuration:(NSTimeInterval)cacheDuration
                          completionHandler:(SYRequestCompletionHandler)completionHandler;



/**
 执行多个网络请求
 
 @param tasks 请求信息
 @param progressBlock 网络任务完成的进度
 @param completionBlock tasks中所有网络任务结束
 */
- (void)sunyBatchOfRequestOperations:(NSArray<SYNetRequestInfo *> *)tasks
                   progressBlock:(void (^)(NSUInteger numberOfFinishedTasks, NSUInteger totalNumberOfTasks))progressBlock
                 completionBlock:(netSuccessbatchBlock)completionBlock;


NS_ASSUME_NONNULL_END

@end
