//
//  SYHttpNetMananger.m
//  NetDemo
//
//  Created by     on 2017/9/14.
//  Copyright © 2017年    . All rights reserved.
//

#import "NetMananger.h"
#import "NetLocalCache.h"
#import "AFNetworking.h"



extern NSString *ConvertMD5FromParametern(NSString *url, NSString* method, NSDictionary* paramDict);

static NSString *CaseyNetProcessingQueue = @"com.eoc.CaseyNet";

NS_ASSUME_NONNULL_BEGIN

@interface NetMananger (){

}

@property (nonatomic, strong)NetLocalCache *cache;


@end

@implementation NetMananger


- (instancetype)init
{
    self = [super init];
    if (self) {
        _caseyNetQueue = dispatch_queue_create([CaseyNetProcessingQueue UTF8String], DISPATCH_QUEUE_CONCURRENT);
        _cache      = [NetLocalCache sharedInstance];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static NetMananger *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}



#pragma mark - GET Method


- (void)getNoCacheWithUrl:(NSString*)urlString
               parameters:(NSDictionary * _Nullable)parameters
        completionHandler:(RequestCompletionHandler)completionHandler{
    
    [self getWithURL:urlString parameters:parameters headerParam:nil ignoreCache:YES cacheDuration:0 completionHandler:completionHandler];
}


- (void)getNoCacheWithUrl:(NSString*)urlString
               parameters:(NSDictionary * _Nullable)parameters
              headerParam:(NSDictionary* _Nullable)headerParam
        completionHandler:(RequestCompletionHandler)completionHandler{
    
    [self getWithURL:urlString parameters:parameters headerParam:headerParam ignoreCache:YES cacheDuration:0 completionHandler:completionHandler];
}


- (void)getCacheWithUrl:(NSString*)urlString
               parameters:(NSDictionary * _Nullable)parameters
            headerParam:(NSDictionary* _Nullable)headerParam
            cacheDuration:(NSTimeInterval)cacheDuration
        completionHandler:(RequestCompletionHandler)completionHandler{
    
    [self getWithURL:urlString parameters:parameters headerParam:headerParam ignoreCache:NO cacheDuration:cacheDuration completionHandler:completionHandler];
    
}


- (void)getCachWithUrl:(NSString*)urlString
               parameters:(NSDictionary * _Nullable)parameters
        completionHandler:(RequestCompletionHandler)completionHandler{
    
    [self getWithURL:urlString parameters:parameters headerParam:nil ignoreCache:NO cacheDuration:NetCacheDuration completionHandler:completionHandler];
}



- (void)getWithURL:(NSString *)URLString
                parameters:(NSDictionary * _Nullable)parameters
                headerParam:(NSDictionary* _Nullable)headerParam
               ignoreCache:(BOOL)ignoreCache
             cacheDuration:(NSTimeInterval)cacheDuration
         completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        [weakSelf taskWithMethod:@"GET" urlString:URLString parameters:parameters headerParam:headerParam paramEncodeStyle:RequestBodyUrlEncode parserStyle:JsonParser ignoreCache:ignoreCache cacheDuration:cacheDuration completionHandler:completionHandler];
    });
    
}



#pragma mark - POST Of JSONEncode Method


- (void)postJsonNoCacheWithURL:(NSString *)URLString
                    parameters:(NSDictionary * _Nullable)parameters
             completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        [weakSelf postJsonWithURL:URLString parameters:parameters headerParam:nil ignoreCache:YES cacheDuration:0 completionHandler:completionHandler];
    });
    
}

- (void)postJsonNoCacheWithURL:(NSString *)URLString
                   parameters:(NSDictionary * _Nullable)parameters
                  headerParam:(NSDictionary* _Nullable)headerParam
            completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        [weakSelf postJsonWithURL:URLString parameters:parameters headerParam:headerParam ignoreCache:YES cacheDuration:0 completionHandler:completionHandler];
    });
    
}

- (void)postJsonUseCacheWithURL:(NSString *)URLString
                     parameters:(NSDictionary * _Nullable)parameters
              completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        [weakSelf postJsonWithURL:URLString parameters:parameters headerParam:nil ignoreCache:NO cacheDuration:NetCacheDuration completionHandler:completionHandler];
    });
    
}

- (void)postJsonUseCacheWithURL:(NSString *)URLString
                    parameters:(NSDictionary * _Nullable)parameters
                   headerParam:(NSDictionary* _Nullable)headerParam
             completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        [weakSelf postJsonWithURL:URLString parameters:parameters headerParam:headerParam ignoreCache:NO cacheDuration:NetCacheDuration completionHandler:completionHandler];
    });
    
}

- (void)postJsonWithURL:(NSString *)URLString
               parameters:(NSDictionary * _Nullable)parameters
             headerParam:(NSDictionary* _Nullable)headerParam
              ignoreCache:(BOOL)ignoreCache
            cacheDuration:(NSTimeInterval)cacheDuration
        completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        

        [weakSelf taskWithMethod:@"POST" urlString:URLString parameters:parameters headerParam:headerParam paramEncodeStyle:RequestBodyJsonEncode parserStyle:JsonParser ignoreCache:ignoreCache cacheDuration:cacheDuration completionHandler:completionHandler];
    });
    
}


#pragma mark - POST Of URLEncode Method

- (void)postUrlEncodeNoCacheWithURL:(NSString *)URLString
                    parameters:(NSDictionary * _Nullable)parameters
             completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        [weakSelf postUrlEncodeWithURL:URLString parameters:parameters headerParam:nil ignoreCache:YES cacheDuration:0 completionHandler:completionHandler];
    });
    
}


- (void)postUrlEncodeNoCacheWithURL:(NSString *)URLString
                          parameters:(NSDictionary * _Nullable)parameters
                         headerParam:(NSDictionary* _Nullable)headerParam
                   completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        [weakSelf postUrlEncodeWithURL:URLString parameters:parameters headerParam:headerParam ignoreCache:NO cacheDuration:NetCacheDuration completionHandler:completionHandler];
    });
    
}

- (void)postUrlEncodeUseCacheWithURL:(NSString *)URLString
                          parameters:(NSDictionary * _Nullable)parameters
                   completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        [weakSelf postUrlEncodeWithURL:URLString parameters:parameters headerParam:nil ignoreCache:NO cacheDuration:NetCacheDuration completionHandler:completionHandler];
    });
    
}

- (void)postUrlEncodeUseCacheWithURL:(NSString *)URLString
                     parameters:(NSDictionary * _Nullable)parameters
                    headerParam:(NSDictionary* _Nullable)headerParam
              completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        [weakSelf postUrlEncodeWithURL:URLString parameters:parameters headerParam:headerParam ignoreCache:NO cacheDuration:NetCacheDuration completionHandler:completionHandler];
    });
    
}


- (void)postUrlEncodeWithURL:(NSString *)URLString
             parameters:(NSDictionary * _Nullable)parameters
            headerParam:(NSDictionary* _Nullable)headerParam
            ignoreCache:(BOOL)ignoreCache
          cacheDuration:(NSTimeInterval)cacheDuration
      completionHandler:(RequestCompletionHandler)completionHandler{
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_caseyNetQueue, ^{
        
        
        [weakSelf taskWithMethod:@"POST" urlString:URLString parameters:parameters headerParam:headerParam paramEncodeStyle:RequestBodyUrlEncode parserStyle:JsonParser ignoreCache:ignoreCache cacheDuration:cacheDuration completionHandler:completionHandler];
    });
    
}


#pragma mark - 网络实现

- (void)taskWithMethod:(NSString*)method
                          urlString:(NSString*)urlStr
                         parameters:(NSDictionary *)parameters
                        headerParam:(NSDictionary*)headerParam
                        paramEncodeStyle:(ParamEncodeStyle)encodeStyle
                        parserStyle:(RepsonsePaserStyle)paserStyle
                        ignoreCache:(BOOL)ignoreCache
                      cacheDuration:(NSTimeInterval)cacheDuration
                  completionHandler:(RequestCompletionHandler)completionHandler{

    if (self.requestParamCondictionBlock) {
        parameters = self.requestParamCondictionBlock(parameters);
    }
    
    if (self.requestHeaderParamCondictionBlock){
        headerParam = self.requestHeaderParamCondictionBlock(headerParam);
    }
    
    NSString *fileKeyFromUrl = ConvertMD5FromParametern(urlStr, method, parameters);
    __weak typeof(self) weakSelf = self;
    
    if (!ignoreCache && [self.cache checkIfShouldSkipCacheWithCacheDuration:cacheDuration cacheKey:fileKeyFromUrl]) {
        
        NSMutableDictionary *localCache = [NSMutableDictionary dictionary];
        NSDictionary *cacheDict = [self.cache searchCacheWithUrl:fileKeyFromUrl];
        [localCache setDictionary:cacheDict];
        if (cacheDict) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (weakSelf.exceptionBlock) {
                    weakSelf.exceptionBlock(nil, nil, localCache);
                }
                completionHandler(nil, YES, localCache);
            });
            return;
        }
    }
    
    RequestCompletionHandler newCompletionBlock = ^( NSError* error,  BOOL isCache, NSDictionary* result){
       

        if (cacheDuration > 0) {
            if (result) {
                if (weakSelf.cacheConditionBlock) {
                    if (weakSelf.cacheConditionBlock(result)) {
                        [weakSelf.cache saveCacheData:result forKey:fileKeyFromUrl];
                    }
                }else{
                    [weakSelf.cache saveCacheData:result forKey:fileKeyFromUrl];
                }
            }
        }
    
        
        if (weakSelf.exceptionBlock) {
            result = weakSelf.exceptionBlock(error, fileKeyFromUrl, result);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            completionHandler(error, NO, result);
        });
//        NSLog(@"Url:%@，\nParams：%@，\nResult：%@\n",urlStr,parameters,result);
    };
    
    
    
    
    NSURLSessionTask *task = nil;
    
    //// 配置 AF
    AFHTTPSessionManager *manager = self.afHttpManager;
    if (encodeStyle == RequestBodyJsonEncode) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }else {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    
    [headerParam enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    if ([method isEqualToString:@"GET"]) {
        
        task = [manager  GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            newCompletionBlock(nil,NO, responseObject);
            [manager invalidateSessionCancelingTasks:NO];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            newCompletionBlock(error,NO, nil);
            [manager invalidateSessionCancelingTasks:NO];
        }];
        
       
    }else{
        
        task = [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            newCompletionBlock(nil,NO, responseObject);
            [manager invalidateSessionCancelingTasks:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            newCompletionBlock(error,NO, nil);
            [manager invalidateSessionCancelingTasks:NO]; // 解决af内存泄露问题
        }];
        
    }
    
    [task resume];
}


- (AFHTTPSessionManager*)afHttpManager{
    
    AFHTTPSessionManager *afManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    return afManager;
}



@end

NS_ASSUME_NONNULL_END
