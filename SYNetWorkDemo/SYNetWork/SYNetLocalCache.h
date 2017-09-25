//
//  SYNetLocalCache.h
//  SYNetDome
//
//  Created by ksw on 2017/9/14.
//  Copyright © 2017年 ksw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYNetLocalCache : NSObject

+ (nonnull instancetype)sharedInstance;

@property (assign, nonatomic) NSInteger maxCacheDeadline;
@property (assign, nonatomic) NSUInteger maxCacheSize;

-(BOOL)checkIfShouldSkipCacheWithCacheDuration:(NSTimeInterval)cacheDuration cacheKey:(NSString*)urlkey;

-(void)addProtectCacheKey:(NSString*)key;

- (id)searchCacheWithUrl:(NSString *)urlkey;
- (void)saveCacheData:(id<NSCopying>)data forKey:(NSString*)key;

@end

NS_ASSUME_NONNULL_END
