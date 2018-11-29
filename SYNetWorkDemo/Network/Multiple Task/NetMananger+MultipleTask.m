//
//  NetMananger+MultipleTask.m
//  OpenPlatformGame
//
//  Created by Casey on 29/11/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "NetMananger+MultipleTask.h"
#import "NetMananger.h"

#import <objc/runtime.h>


@interface NetMananger (MultipleTask_Property)

@property (nonatomic, strong) NSMutableArray *batchGroups;//批处理


@end



@implementation NetMananger (MultipleTask)


- (void)setBatchGroups:(NSMutableArray*)batchGroups{
    
    objc_setAssociatedObject(self, @selector(batchGroups), batchGroups, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray*)batchGroups{
    
    NSMutableArray *batchGroups = objc_getAssociatedObject(self, @selector(batchGroups));
    if (batchGroups == nil) {
        batchGroups = [NSMutableArray new];
        self.batchGroups = batchGroups;
    }
    return batchGroups;
}


- (void)batchOfRequestAsynOperations:(NSArray<NetRequestInfo *> *)tasks
                     progressBlock:(nullable void (^)(NSUInteger numberOfFinishedTasks, NSUInteger totalNumberOfTasks))progressBlock
                   completionBlock:(netSuccessbatchBlock)completionBlock{
    
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.caseyNetQueue, ^{
        
        __block dispatch_group_t group = dispatch_group_create();
        [weakSelf.batchGroups addObject:group];
        
        __block NSInteger finishedTasksCount = 0;
        __block NSInteger totalNumberOfTasks = tasks.count;
        
        [tasks enumerateObjectsUsingBlock:^(NetRequestInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj) {
                
                dispatch_group_enter(group);
                
                RequestCompletionHandler newCompletionBlock = ^( NSError* error,  BOOL isCache, NSDictionary* result){
                    
                    if (progressBlock) {
                        progressBlock(finishedTasksCount, totalNumberOfTasks);
                    }
                    
                    if (obj.completionBlock) {
                        obj.completionBlock(error, isCache, result);
                    }
                    dispatch_group_leave(group);
                    
                };
              
                    
                [[NetMananger sharedInstance] taskWithMethod:obj.method urlString:obj.urlStr parameters:obj.parameters headerParam:obj.headerParam paramEncodeStyle:obj.paramEncodeStyle parserStyle:obj.responsePaserStyle ignoreCache:obj.ignoreCache cacheDuration:obj.cacheDuration completionHandler:newCompletionBlock];
                    
               
            }
            
        }];
        
        //监听
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [weakSelf.batchGroups removeObject:group];
            if (completionBlock) {
                completionBlock(tasks);
            }
        });
    });
}

- (void)batchOfRequestAsynOperations:(NSArray<NetRequestInfo *> *)tasks completionBlock:(netSuccessbatchBlock)completionBlock{
    
    [self batchOfRequestAsynOperations:tasks progressBlock:nil completionBlock:completionBlock];
    
    
}

// 任务按照循序执行
- (void)batchOfRequestSynOperations:(NSArray<NetRequestInfo *> *)tasks completionBlock:(netSuccessbatchBlock)completionBlock{
    
    dispatch_async(self.caseyNetQueue, ^{
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        for (int i = 0; i < tasks.count; i++) {
            NetRequestInfo *obj = tasks[i];
            if (obj) {
                
                RequestCompletionHandler newCompletionBlock = ^( NSError* error,  BOOL isCache, NSDictionary* result){
                    
                    if (obj.completionBlock) {
                        obj.completionBlock(error, isCache, result);
                    }
                    
                    dispatch_semaphore_signal(sema);
                };
                
                [[NetMananger sharedInstance] taskWithMethod:obj.method urlString:obj.urlStr parameters:obj.parameters headerParam:obj.headerParam paramEncodeStyle:obj.paramEncodeStyle parserStyle:obj.responsePaserStyle ignoreCache:obj.ignoreCache cacheDuration:obj.cacheDuration completionHandler:newCompletionBlock];
                
                
                dispatch_wait(sema, DISPATCH_TIME_FOREVER);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(tasks);
            }
        });
        
    });
}




+ (void)resumeTask:(NetRequestInfo*)requestInfo{
    
    [[NetMananger sharedInstance] taskWithMethod:requestInfo.method urlString:requestInfo.urlStr parameters:requestInfo.parameters headerParam:requestInfo.headerParam paramEncodeStyle:requestInfo.paramEncodeStyle parserStyle:requestInfo.responsePaserStyle ignoreCache:requestInfo.ignoreCache cacheDuration:requestInfo.cacheDuration completionHandler:requestInfo.completionBlock];
    
}


@end
