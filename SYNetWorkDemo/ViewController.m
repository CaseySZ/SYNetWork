//
//  ViewController.m
//  SYNetDome
//
//  Created by ksw on 2017/9/14.
//  Copyright © 2017年 ksw. All rights reserved.
//

#import "ViewController.h"
#import "CaseyNetWorking.h"


NS_ASSUME_NONNULL_BEGIN

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSDictionary *infodict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"versions_id", @"1", @"system_type", nil];
    
    
    [[NetMananger sharedInstance] postJsonNoCacheWithURL:URLPath parameters:infodict completionHandler:^(NSError * _Nullable error, BOOL isCache, NSDictionary * _Nullable result) {
        
        NSLog(@"%@", result);
        
    }];
    
}

// 多任务处理
- (void)multiNetTask{
    
    
    NSDictionary *infodictOne = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"versions_id", @"1", @"system_type", nil];
    
   NetRequestInfo *infoNetOne =  [NetRequestInfo postURLEncodeCacheWithURL:URLPath parameters:infodictOne headerParam:nil completionHandler:^(NSError * _Nullable error, BOOL isCache, NSDictionary * _Nullable result) {
       
       if (isCache) {
           NSLog(@"isCache");
       }
       
    }];
    


    NetRequestInfo *infoNetTwo =  [NetRequestInfo postURLEncodeCacheWithURL:URLPath parameters:infodictOne headerParam:nil completionHandler:^(NSError * _Nullable error, BOOL isCache, NSDictionary * _Nullable result) {
        
        if (isCache) {
            NSLog(@"isCache");
        }
        
    }];


    NSArray *taskAry = [NSArray arrayWithObjects:infoNetOne, infoNetTwo, nil];
    [[NetMananger sharedInstance] batchOfRequestAsynOperations:taskAry completionBlock:^(NSArray *operationAry) {
        
    }];
    
    
}


@end



NS_ASSUME_NONNULL_END
