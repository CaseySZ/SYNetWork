//
//  SYDataConvert.m
//  SYNetDome
//
//  Created by ksw on 2017/9/15.
//  Copyright © 2017年 ksw. All rights reserved.
//

#import "SYMD5DataConvert.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * SYConvertMD5FromString(NSString *str){
    
    if(str.length == 0){
        return nil;
    }
    
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}


static NSString *SYNetCacheVersion(){
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 对传入的参数一起进行MD5加密，并生成该请求的缓存文件名

 @param url url地址
 @param method 请求方式
 @param paramDict 请求参数
 @return md5结果
 */
NSString *SYConvertMD5FromParameter(NSString *url, NSString* method, NSDictionary* paramDict){
    
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%@ Url:%@ Argument:%@ AppVersion:%@ ",
                             method,
                             url,
                             paramDict,
                             SYNetCacheVersion()];
    
    return SYConvertMD5FromString(requestInfo);
}



@implementation SYMD5DataConvert


@end
