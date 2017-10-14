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
    [[SYNetMananger sharedInstance] sunyPostWithURLString:URLPath parameters:infodict ignoreCache:NO cacheDuration:1 completionHandler:^(NSError * _Nullable error, BOOL isCache, NSDictionary * _Nullable result) {
        
        if (isCache) {
            NSLog(@"isCache");
        }
        NSLog(@"%@", [NSThread currentThread]);
    
        
    }];
    
}

// 多任务处理
- (void)multiNetTask{
    NSDictionary *infodictOne = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"versions_id", @"1", @"system_type", nil];
    SYNetRequestInfo *infoNetOne = [[SYNetMananger sharedInstance] sunyNetRequestWithURLStr:URLPath method:@"POST" parameters:infodictOne ignoreCache:NO cacheDuration:2 completionHandler:^(NSError * _Nullable error, BOOL isCache, NSDictionary * _Nullable result) {
        
        if (isCache) {
            NSLog(@"isCache");
        }
        NSLog(@"===%@", [NSThread currentThread]);
    }];
    
    NSDictionary *infodictTwo = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"versions_id", @"1", @"system_type", nil];
    SYNetRequestInfo *infoNetTwo = [[SYNetMananger sharedInstance] sunyNetRequestWithURLStr:URLPath method:@"POST" parameters:infodictTwo ignoreCache:NO cacheDuration:2 completionHandler:^(NSError * _Nullable error, BOOL isCache, NSDictionary * _Nullable result) {
        
        if (isCache) {
            NSLog(@"isCache");
        }
        NSLog(@"===%@", [NSThread currentThread]);
    }];
    
    
    [[SYNetMananger sharedInstance] sunyBatchOfRequestOperations:[NSArray arrayWithObjects:infoNetOne,infoNetTwo, nil] progressBlock:^(NSUInteger numberOfFinishedTasks, NSUInteger totalNumberOfTasks) {
        
        NSLog(@" numberOfFinishedTasks::%ld==%@", numberOfFinishedTasks, [NSThread currentThread]);
        
    } completionBlock:^(NSArray * _Nonnull operationAry) {
        NSLog(@"completionBlock:%@", [NSThread currentThread]);
    }];
    
    
}


@end
