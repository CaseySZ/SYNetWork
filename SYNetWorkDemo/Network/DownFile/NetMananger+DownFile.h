//
//  NetMananger+DownFile.h
//  OpenPlatformGame
//
//  Created by Casey on 03/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "NetMananger.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetMananger (DownFile)<NSURLSessionDelegate, NSURLConnectionDataDelegate>


/**
 下载文件, 支持断点续载

 @param fileUrl 文件url
 @param continuePre 是否断点下载 （yes 基于上次的文件继续下载， no重新下载）
 @param downloadProgressBlock 下载进度
 @param filePath 文件的存储路径
 @param completion 回调
 */

- (void)downLoadFileWithUrl:(NSString*)fileUrl continueOfPre:(BOOL)continuePre progress:(void (^)(long allDataSize, long loadedSize)) downloadProgressBlock targetPath:(NSString*)filePath completion:(void (^)(NSError *error))completion;


@end

NS_ASSUME_NONNULL_END
