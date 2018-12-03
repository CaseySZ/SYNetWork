//
//  NSURLSessionTask+DownFile.h
//  SYNetWorkDemo
//
//  Created by Casey on 03/12/2018.
//  Copyright © 2018 SunYong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^DownLoadFinishBlock)(NSError *error);

typedef void (^ProgressBlock)(long allDataSize, long loadedSize);

@interface DownLoadFileModel: NSObject


@property (nonatomic, strong)NSString *fileUrl;
@property (nonatomic, strong)NSString *filePath;
@property (nonatomic, assign)long fileSize;
@property (nonatomic, assign)BOOL continuePre;
@property (nonatomic, copy)DownLoadFinishBlock completion;
@property (nonatomic, copy)ProgressBlock progressBlock;



- (NSURLRequest*)request;

- (void)loadingData:(NSData*)data;
- (void)downLoadFinish:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
