//
//  NetMananger+UpdateFile.h
//  OpenPlatformGame
//
//  Created by Casey on 03/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "NetMananger.h"

NS_ASSUME_NONNULL_BEGIN


typedef void (^UpdateProgressBlock)(long bytesSent, long totalBytesSent);



@interface NetMananger (UpdateFile)



/**
 文件上传

 @param urlStr 上传地址
 @param fileData 文件数据
 @param nameServiceKey 文件Key（⚠️和服务器的key要一致）
 @param fileName 文件名
 @param fileType 文件类型
 @param uploadProgress 上传进度(bytesSent已上传了字节数， totalBytesSent总共需要上传的字节数)
 @param completion 完成回调
 
 */


- (void)updateFileWithUrl:(NSString*)urlStr fileData:(NSData*)fileData name:(NSString*)nameServiceKey fileName:(NSString*)fileName mimeType:(NSString*)fileType uploadProgress:(UpdateProgressBlock)uploadProgress completion:(nullable void (^)(NSError * nullable))completion;


@end

NS_ASSUME_NONNULL_END
