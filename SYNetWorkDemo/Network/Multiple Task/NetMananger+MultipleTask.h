//
//  NetMananger+MultipleTask.h
//  OpenPlatformGame
//
//  Created by Casey on 29/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "NetMananger.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetMananger (MultipleTask)


/**
 执行多个网络请求
 
 @param tasks 请求信息
 @param progressBlock 网络任务完成的进度
 @param completionBlock tasks中所有网络任务结束
 */
- (void)batchOfRequestAsynOperations:(NSArray<NetRequestInfo *> *)tasks
                     progressBlock:(nullable void (^)(NSUInteger numberOfFinishedTasks, NSUInteger totalNumberOfTasks))progressBlock
                   completionBlock:(netSuccessbatchBlock)completionBlock;

/**
 执行多个网络请求，同上没有进度progress参数
 
 @param tasks 请求信息
 @param completionBlock tasks中所有网络任务结束
 */
- (void)batchOfRequestAsynOperations:(NSArray<NetRequestInfo *> *)tasks completionBlock:(netSuccessbatchBlock)completionBlock;


/**
 执行多个网络请求，注意⚠️按照tasks里的顺序先后执行
 
 @param tasks 请求信信
 @param completionBlock tasks中所有网络任务结束
 */
- (void)batchOfRequestSynOperations:(NSArray<NetRequestInfo *> *)tasks completionBlock:(netSuccessbatchBlock)completionBlock;




// 开启任务 用NetRequestInfo
+ (void)resumeTask:(NetRequestInfo*)requestInfo;


@end

NS_ASSUME_NONNULL_END
