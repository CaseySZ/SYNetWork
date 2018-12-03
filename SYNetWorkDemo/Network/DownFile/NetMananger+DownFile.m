//
//  NetMananger+DownFile.m
//  OpenPlatformGame
//
//  Created by Casey on 03/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "NetMananger+DownFile.h"
#import <UIKit/UIKit.h>
#import "DownLoadFileModel.h"
#import <objc/runtime.h>



NSString *__filePathInTemp(NSString* fileName){
    
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
}

NSString *__filePathInDocument(NSString* fileName){
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return  [docPath stringByAppendingPathComponent:fileName];
    
}



@interface NetMananger (__DownFile)<NSURLSessionDelegate, NSURLConnectionDataDelegate>



@property (nonatomic, strong)NSMutableDictionary *downTaskInfo;

@end



@implementation NetMananger (DownFile) 





/**
 下载文件, 支持断点续载

 @param fileUrl 文件url
 @param continuePre 是否断点下载 （yes 基于上次的文件继续下载， no重新下载）
 @param downloadProgressBlock 下载进度
 @param filePath 下载完文件存储路径
 */

- (void)downLoadFileWithUrl:(NSString*)fileUrl continueOfPre:(BOOL)continuePre progress:(void (^)(long allDataSize, long loadedSize)) downloadProgressBlock targetPath:(NSString*)filePath completion:(void (^)(NSError *error))completion{
    
    DownLoadFileModel *model = [[DownLoadFileModel alloc] init];
    model.fileUrl = fileUrl;
    model.filePath = filePath;
    model.continuePre = continuePre;
    model.progressBlock = downloadProgressBlock;
    model.completion = completion;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionTask *task = [session dataTaskWithRequest:model.request];
    [self.downTaskInfo setObject:model forKey:@(task.taskIdentifier)];
    [task resume];
}



#define parm - mark NSURLSessionDelegate


//NSURLConnection
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    DownLoadFileModel *model = [self.downTaskInfo objectForKey:@(dataTask.taskIdentifier)];
    if (model && [model isKindOfClass:[DownLoadFileModel class]]) {
        NSHTTPURLResponse *responseHeader = (NSHTTPURLResponse*)response;
        NSDictionary *infoDict =  [responseHeader allHeaderFields];
        NSString *lengthStr =  [infoDict objectForKey:@"Content-Length"];
        if (lengthStr.longLongValue > 0){
            model.fileSize = lengthStr.longLongValue;
        }else{
            model.fileSize = INTMAX_MAX;
        }
    }
    completionHandler(NSURLSessionResponseAllow);
    
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    DownLoadFileModel *model = [self.downTaskInfo objectForKey:@(dataTask.taskIdentifier)];
    if (model && [model isKindOfClass:[DownLoadFileModel class]]) {
        
        [model loadingData:data];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    DownLoadFileModel *model = [self.downTaskInfo objectForKey:@(task.taskIdentifier)];
    if (model && [model isKindOfClass:[DownLoadFileModel class]]) {
        
        [model downLoadFinish:error];
    }
    [self.downTaskInfo removeObjectForKey:@(task.taskIdentifier)];
    
}

#pragma mark - lazyLoaing

- (void)setDownTaskInfo:(NSMutableDictionary *)downTaskInfo{
    
    objc_setAssociatedObject(self, @selector(setDownTaskInfo:), downTaskInfo, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary*)downTaskInfo{
    
    NSMutableDictionary *downTaskInfo = objc_getAssociatedObject(self, @selector(setDownTaskInfo:));
    if (downTaskInfo == nil) {
        downTaskInfo = [[NSMutableDictionary alloc] init];
        self.downTaskInfo = downTaskInfo;
    }
    return downTaskInfo;
}


@end
