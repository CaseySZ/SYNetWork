//
//  NetLocalCache.m
//  NetDemo
//
//  Created by     on 2017/9/14.
//  Copyright © 2017年    . All rights reserved.
//

#import "NetLocalCache.h"
#import <UIKit/UIKit.h>

static NSString *  CaseyCacheFileProcessingQueue = @"com.eoc.CaseyNetCache";
static NSString *  CaseyCacheDocument = @"CaseyNetCache";
static const NSInteger CaseyDefaultCacheMaxDeadline = 60 * 60 * 24 * 30; // 1 个月

@interface NetLocalCache (){
    NSCache          *_memoryCache;//cache 用来解决频繁从文件系统中 读取文件的 系能问题
    NSString         *_cachePath;
    NSFileManager    *_fileManager;
    dispatch_queue_t _CaseyIOQueue;
    NSMutableSet     *_protectCaches;
}

@end

@implementation NetLocalCache


+ (instancetype)sharedInstance
{
    static NetLocalCache *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backgroundCleanDisk) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        _memoryCache = [NSCache new];
        _protectCaches = [NSMutableSet new];
        _CaseyIOQueue = dispatch_queue_create([CaseyCacheFileProcessingQueue UTF8String], DISPATCH_QUEUE_CONCURRENT);
        _maxCacheDeadline = CaseyDefaultCacheMaxDeadline;
       
        dispatch_sync(_CaseyIOQueue, ^{
            self->_fileManager = [NSFileManager new];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            self->_cachePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:CaseyCacheDocument];
            BOOL isDir;
            if (![self->_fileManager fileExistsAtPath:self->_cachePath isDirectory:&isDir]){
                
                [self createCacheDocument];
            }else{
                if (!isDir) {
                    NSError *error = nil;
                    [self->_fileManager removeItemAtPath:self->_cachePath error:&error];
                    [self createCacheDocument];
                }
            }
            
        });
        
    }
    return self;
}

#pragma mark - Notification handle
-(void)removeAllObjects{
    [_memoryCache removeAllObjects];
}

- (void)backgroundCleanDisk{
    
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    [self cleanDiskWithCompletionBlock:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
}

- (void)createCacheDocument{
    __autoreleasing NSError *error = nil;
    BOOL created = [[NSFileManager defaultManager] createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!created) {
        NSLog(@"创建 缓存文件夹失败:%@", error);
    }else{
        NSURL *url = [NSURL fileURLWithPath:_cachePath];
        NSError *error = nil;
        [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];//避免缓存数据 被备份到iclouds
        if (error) {
            NSLog(@"没有成功的设置 ‘应用不能备份的属性’, error = %@", error);
        }
    }
}

-(void)addProtectCacheKey:(NSString*)urlkey{
    
    [_protectCaches addObject:urlkey];
}


-(BOOL)checkIfShouldSkipCacheWithCacheDuration:(NSTimeInterval)cacheDuration cacheKey:(NSString*)urlkey{
    
    if (cacheDuration == 0) {//如果不需要缓存
        return YES;
    }
    
    //处理缓存
    id localCache = [self searchCacheWithUrl:urlkey];
    if (localCache) {//缓存文件存在
        if ([self expiredWithCacheKey:urlkey cacheDuration:cacheDuration]) { //判断缓存文件是否过期了
            return YES;
        }
        
    }else{
        return YES;
    }
    return NO;
}

/**
 查找/读 缓存
 
 @param urlkey key
 @return 缓存
 */
- (id)searchCacheWithUrl:(NSString *)urlkey{
    id object = [_memoryCache objectForKey:urlkey];
    if (!object) {
        NSString *filePath = [_cachePath stringByAppendingPathComponent:urlkey];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {

            if (@available(iOS 11.0, *)) {
                object = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSDictionary class] fromData:[NSData dataWithContentsOfFile:filePath] error:nil];
            } else {
                object = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            }
            
            if (object){
                [_memoryCache setObject:object forKey:urlkey];
            }else{
                NSLog(@"NSKeyedUnarchiver fail in cache");
            }
        }
    }
    return object;
}

/**
 保存缓存

 @param data 缓存数据
 @param key 缓存文件名
 */
- (void)saveCacheData:(id<NSCopying>)data forKey:(NSString*)key{
    if (!data) {//解决 闪退问题
        return;
    }
    
    [_memoryCache setObject:data forKey:key];
    
    dispatch_async(_CaseyIOQueue, ^{
        
        NSString *filePath = [self->_cachePath stringByAppendingPathComponent:key];
        
        if (@available(iOS 11.0, *)) {
            NSData *archiveData =  [NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:nil];
            if (archiveData) {
                [archiveData writeToFile:filePath atomically:YES];
            }else{
                NSLog(@"NSKeyedArchiver fail in cache");
            }
            
        } else {
            
            BOOL written = [NSKeyedArchiver archiveRootObject:data toFile:filePath];
            if (!written) {
                
            }else {

            }
            
        }
    });
    
}

/**
 判断是否过期

 @param cacheFileNamekey 缓存文件名key
 @param expirationDuration 时间段
 @return YES 过期， NO 没过期
 */
-(BOOL)expiredWithCacheKey:(NSString*)cacheFileNamekey cacheDuration:(NSTimeInterval)expirationDuration{
    NSString *filePath = [_cachePath stringByAppendingPathComponent:cacheFileNamekey];
    BOOL fileExist = [_fileManager fileExistsAtPath:filePath];
    if (fileExist) {
        NSTimeInterval fileDuration = [self cacheFileDuration:filePath];
        if (fileDuration > expirationDuration) {
            [_fileManager removeItemAtURL:[NSURL fileURLWithPath:filePath] error:nil];
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;//如果文件不存在 则设置为  过期文件
    }
}

/**

 */
- (NSTimeInterval)cacheFileDuration:(NSString *)path {
    
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [_fileManager attributesOfItemAtPath:path
                                                              error:&attributesRetrievalError];
    if (!attributes) {
        
        return -1;
    }else {
       
    }
    NSTimeInterval seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}



//注意 这里如果是首页这种数据是不应该清除的 其他不应该清除的数据 即时添加
- (void)cleanDiskWithCompletionBlock:(void (^)(void))completionBlock {
    dispatch_async(_CaseyIOQueue, ^{
        NSURL *diskCacheURL = [NSURL fileURLWithPath:self->_cachePath isDirectory:YES];
        NSArray *resourceKeys = @[NSURLLocalizedNameKey,NSURLNameKey,NSURLIsDirectoryKey, NSURLContentModificationDateKey, NSURLTotalFileAllocatedSizeKey];
        
        NSDirectoryEnumerator *fileEnumerator = [self->_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-self.maxCacheDeadline];
        NSMutableDictionary *cacheFiles = [NSMutableDictionary dictionary];
        NSUInteger currentCacheSize = 0;
        
        // 遍历缓存文件夹中的所有文件，有2 个目的
        //  1. 删除过期的文件
        //  2. 删除比较的旧的文件 使得当前文件的大小 小于最大文件的大小
        NSMutableArray *urlsToDelete = [[NSMutableArray alloc] init];
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:NULL];
            // 跳过文件夹
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            // 跳过指定不能删除的文件 比如首页列表数据
            if ([self->_protectCaches containsObject:fileURL.lastPathComponent]) {
                continue;
            }
            
            // 删除过期文件
            NSDate *modificationDate = resourceValues[NSURLContentModificationDateKey];
            if ([[modificationDate laterDate:expirationDate] isEqualToDate:expirationDate]) {
                [urlsToDelete addObject:fileURL];
                continue;
            }
            
            // Store a reference to this file and account for its total size.
            NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
            currentCacheSize += [totalAllocatedSize unsignedIntegerValue];
            [cacheFiles setObject:resourceValues forKey:fileURL];
        }
        
        for (NSURL *fileURL in urlsToDelete) {
            [self->_fileManager removeItemAtURL:fileURL error:nil];
        }
        
        
        // 如果删除过期的文件后，缓存的总大小还大于maxsize 的话则删除比较快老的缓存文件
        if (self.maxCacheSize > 0 && currentCacheSize > self.maxCacheSize) {
            // 这个过程主要清除到最大缓存的一半大小
            const NSUInteger desiredCacheSize = self.maxCacheSize / 2;
            
            // 按照最后的修改时间来排序，旧的文件排在前面
            NSArray *sortedFiles = [cacheFiles keysSortedByValueWithOptions:NSSortConcurrent
                                                            usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                                                return [obj1[NSURLContentModificationDateKey] compare:obj2[NSURLContentModificationDateKey]];
                                                            }];
            //删除文件到一半的大小
            for (NSURL *fileURL in sortedFiles) {
                if ([self->_fileManager removeItemAtURL:fileURL error:nil]) {
                    NSDictionary *resourceValues = cacheFiles[fileURL];
                    NSNumber *totalAllocatedSize = resourceValues[NSURLTotalFileAllocatedSizeKey];
                    currentCacheSize -= [totalAllocatedSize unsignedIntegerValue];
                    if (currentCacheSize < desiredCacheSize) {
                        break;
                    }
                }
            }
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }
    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}
@end
