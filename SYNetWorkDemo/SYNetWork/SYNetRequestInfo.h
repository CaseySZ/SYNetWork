//
//  SYNetRequestInfo.h
//  SYNetDome
//
//  Created by ksw on 2017/9/15.
//  Copyright © 2017年 ksw. All rights reserved.
//  github地址:https://github.com/sunyong445

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SYRequestCompletionHandler)( NSError* _Nullable error,  BOOL isCache, NSDictionary* _Nullable result);
typedef BOOL (^SYRequestCompletionAddCacheCondition)(NSDictionary *result);

typedef void (^netSuccessbatchBlock)(NSArray *operationAry);


@interface SYNetRequestInfo : NSObject

@property(nonatomic, strong)NSString *urlStr;
@property(nonatomic, strong)NSString *method;
@property(nonatomic, strong)NSDictionary *parameters;
@property(nonatomic, assign)BOOL ignoreCache;
@property(nonatomic, assign)NSTimeInterval cacheDuration;
@property(nonatomic, copy)SYRequestCompletionHandler completionBlock;


typedef void (^SYRequestCompletionAddExcepetionHanle)(NSError* _Nullable errror,  NSMutableDictionary* result);

@end

NS_ASSUME_NONNULL_END
