//
//  AppDelegate+NetException.m
//  ExamProject
//
//  Created by ksw on 2017/10/13.
//  Copyright © 2017年 SunYong. All rights reserved.
//

#import "AppDelegate+NetException.h"
#import "SYNetMananger.h"

@implementation AppDelegate (NetException)

// 统一处理网络部分异常
- (void)configHandleNetException{
    
    [SYNetMananger sharedInstance].exceptionBlock = ^(NSError * _Nullable error, NSMutableDictionary* result) {
        
        if(![result isKindOfClass:[NSDictionary class]]){
            return ;
        }
        
        // 统一处理网络异常错误信息
        if(error && [result allKeys].count == 0){
            
            [result setObject:error.localizedDescription forKey:@"msg"];
        }
        // (单点登录)登录异常处理
        if([[result objectForKey:@"statusCode"] integerValue] == 401){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:nil];
        }
        
    };
    
}

@end
