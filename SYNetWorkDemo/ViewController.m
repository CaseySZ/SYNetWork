//
//  ViewController.m
//  SYNetDome
//
//  Created by ksw on 2017/9/14.
//  Copyright © 2017年 ksw. All rights reserved.
//

#import "ViewController.h"
#import "SYNetMananger.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSDictionary *infodict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"versions_id", @"1", @"system_type", nil];
    
    [[SYNetMananger sharedInstance] syPostNoCacheWithUrl:URLPath parameters:infodict completionHandler:^(NSError * _Nullable error, BOOL isCache, NSDictionary * _Nullable result) {
        if (isCache) {
            NSLog(@"isCache");
        }
    }];
    
}

// 多任务处理
- (void)multiNetTask{
    NSDictionary *infodictOne = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"versions_id", @"1", @"system_type", nil];
    SYNetRequestInfo *infoNetOne = [[SYNetMananger sharedInstance] syNetRequestWithURLStr:URLPath method:@"POST" parameters:infodictOne ignoreCache:NO cacheDuration:2 completionHandler:^(NSError * _Nullable error, BOOL isCache, NSDictionary * _Nullable result) {
        
        if (isCache) {
            NSLog(@"isCache");
        }
        
    }];
    
    NSDictionary *infodictTwo = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"versions_id", @"1", @"system_type", nil];
    SYNetRequestInfo *infoNetTwo = [[SYNetMananger sharedInstance] syNetRequestWithURLStr:URLPath method:@"POST" parameters:infodictTwo ignoreCache:NO cacheDuration:2 completionHandler:^(NSError * _Nullable error, BOOL isCache, NSDictionary * _Nullable result) {
        
        if (isCache) {
            NSLog(@"isCache");
        }
        
    }];
    
    
    NSArray *taskAry = [NSArray arrayWithObjects:infoNetOne, infoNetTwo, nil];
    [[SYNetMananger sharedInstance] syBatchOfRequestOperations:taskAry progressBlock:^(NSUInteger numberOfFinishedTasks, NSUInteger totalNumberOfTasks) {
        
    } completionBlock:^(NSArray * _Nonnull operationAry) {
        
    }];
    
    
}


@end
