//
//  AppDelegate+NetCache.m
//  ExamProject
//
//  Created by ksw on 2017/10/13.
//  Copyright © 2017年 SunYong. All rights reserved.
//

#import "AppDelegate+NetConfig.h"
#import "CaseyNetWorking.h"



@implementation AppDelegate (NetCache)

// 配置缓存条件
- (void)configNetCondition{
    
    // return YES 缓存， NO不缓存
    [NetMananger sharedInstance].cacheConditionBlock = ^BOOL(NSDictionary * _Nonnull result) {
     
        if([result isKindOfClass:[NSDictionary class]]){
            
            if([[result objectForKey:@"success"] intValue] == 0){
                
                return NO;
            }
        }
        
        return YES;
    };
    
    // 统一处理请求体参数
    [NetMananger sharedInstance].requestBodyCommonParamBlock = ^NSDictionary *(NSDictionary *paramDict) {
        
        
        NSMutableDictionary *newParam = paramDict.mutableCopy;
        
        [newParam setObject:@"test" forKey:@"test"];
        NSLog(@"%@", newParam);
        return newParam;
        
    };
    
    // 统一处理请求头
    [NetMananger sharedInstance].requestHeaderCommonParamBlock = ^NSDictionary *(NSDictionary *paramDict) {
       
        
        NSLog(@"requestHeaderParamCondictionBlock");
        
        return nil;
    };
    
    // 统一异常处理
    [NetMananger sharedInstance].exceptionBlock = ^NSDictionary *(NSError * _Nullable error, NSString * _Nullable cacheKey, NSDictionary *result) {
        
        
        if(![result isKindOfClass:[NSDictionary class]]){
            return nil;
        }
        
        NSMutableDictionary *newResult = result.mutableCopy;
        
        // 统一处理网络异常错误信息
        if(error && [newResult allKeys].count == 0){
            // 这个地方就可以在内部不需要去判断error，统一直接判断result相关信息
            // result错误信息配置
            [newResult setObject:error.localizedDescription forKey:@"msg"];
        }
        // (单点登录)登录异常处理
        if([[newResult objectForKey:@"statusCode"] integerValue] == 401){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginNotification" object:nil];
        }
        
        return newResult;
        
    };
    
    
}

@end
