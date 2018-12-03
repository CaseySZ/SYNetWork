//
//  ViewController.m
//  SYNetDome
//
//  Created by ksw on 2017/9/14.
//  Copyright © 2017年 ksw. All rights reserved.
//

#import "ViewController.h"
#import "CaseyNetWorking.h"




@interface ViewController ()

@end

#define filePath  @"http://a06mobileimage.cnsupu.com/static/A06M/_default/__static/__images/dasheng/app/bank/icbc40.png"

//#define filePath  @"http://img.hb.aicdn.com/d01fe4b6ec142f14fb2f13cf80f22a7356e3922110df2-8mnSCV_fw658"
//#define filePath  @"http://img.hb.aicdn.com/ebf88b4fa5ab5d84d33b0d51a89f5fbe4ded9efe169c6-5zJhaW_fw658"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
   
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self downLoadFileNet];
}



- (void)downLoadFileNet{
    
    
    [[NetMananger sharedInstance] downLoadFileWithUrl:filePath continueOfPre:YES progress:^(long allDataSize, long loadedSize) {
        
        NSLog(@"progress::%d, %d", allDataSize, loadedSize);
        
    } targetPath:@"FileName" completion:^(NSError * _Nonnull error) {
        
    }];
    
    
}


- (void)simpleNetTask {
    
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


