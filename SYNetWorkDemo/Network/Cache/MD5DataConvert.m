//
//  DataConvert.m
//  NetDemo
//
//  Created by     on 2017/9/15.
//  Copyright © 2017年    . All rights reserved.
//

#import "MD5DataConvert.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * ConvertMD5FromString(NSString *str){
    
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


static NSString *NetCacheVersion(){
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 对传入的参数一起进行MD5加密，并生成该请求的缓存文件名

 @param url url地址
 @param method 请求方式
 @param paramDict 请求参数
 @return md5结果
 */
NSString *ConvertMD5FromParametern(NSString *url, NSString* method, NSDictionary* paramDict){
    
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%@ Url:%@ Argument:%@ AppVersion:%@ ",
                             method,
                             url,
                             paramDict,
                             NetCacheVersion()];
    
    return ConvertMD5FromString(requestInfo);
}



@implementation MD5DataConvert


@end
