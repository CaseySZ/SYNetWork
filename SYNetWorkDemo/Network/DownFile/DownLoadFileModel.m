//
//  NSURLSessionTask+DownFile.m
//  SYNetWorkDemo
//
//  Created by Casey on 03/12/2018.
//  Copyright © 2018 SunYong. All rights reserved.
//

#import "DownLoadFileModel.h"
#import <CommonCrypto/CommonDigest.h>


@interface DownLoadFileModel ()

@property (nonatomic, strong)NSString *tmpFilePath;
@property (nonatomic, strong)NSOutputStream *fileOutputStream;
@property (nonatomic, assign)long loadingSize; // 已下载大小

@end


@implementation DownLoadFileModel
@synthesize fileOutputStream = _fileOutputStream;


- (void)setFilePath:(NSString *)filePath{
    
    _filePath = filePath;
    if (filePath.length > 0) {
        
        NSString *fileName = [filePath stringByDeletingLastPathComponent];
        if(fileName.length == 0){
            
            if (DEBUG){
                
                NSLog(@"error: %@不是文件路径, DEBUG模式默认存入到Document文件下",filePath);
                NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                _filePath = [docPath stringByAppendingPathComponent:filePath];
                
            }else{
    
                NSLog(@"error: %@不是文件路径",filePath);
            }
        }
        
    }else{
        
    }
    
}


- (void)setFileUrl:(NSString *)fileUrl{
    
    _fileUrl = fileUrl;
    _tmpFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[self md5FromStr:_fileUrl]];
    
}

- (NSURLRequest *)request{
    
    if (_fileOutputStream) {
        [_fileOutputStream close];
        _fileOutputStream = nil;
    }
    
    
    
    
    NSURL *url = [NSURL URLWithString:self.fileUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    BOOL isAppend = NO;
    if (self.continuePre) {
        
        long dataPreLength = [self backFileLegnth:_tmpFilePath];
        self.loadingSize = dataPreLength;
        if (self.loadingSize > 0) {
            [request setValue:[NSString stringWithFormat:@"bytes=%ld-", self.loadingSize] forHTTPHeaderField:@"Range"];
            isAppend = YES;
        }
        
    }
    
    _fileOutputStream = [[NSOutputStream alloc] initToFileAtPath:_tmpFilePath append:isAppend];
    [_fileOutputStream open];
    
    
    return request;
    
}


- (void)loadingData:(NSData*)data{
    
    self.loadingSize = self.loadingSize + data.length;
    
    if (self.progressBlock){
        if (self.fileSize == INTMAX_MAX) {
            
             self.progressBlock(self.loadingSize, self.loadingSize);
            
        }else{
            
             self.progressBlock(self.fileSize, self.loadingSize);
        }
       
    }
    [self.fileOutputStream write:[data bytes] maxLength:data.length];
}


- (void)downLoadFinish:(NSError*)error{
    
    [_fileOutputStream close];
    _fileOutputStream = nil;

    if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];
    }
    [[NSFileManager defaultManager] moveItemAtPath:_tmpFilePath toPath:_filePath error:nil];
    
    if (self.completion) {
        
        self.completion(error);
        _completion = nil;
        
    }
    _progressBlock = nil;
}



- (long)backFileLegnth:(NSString*)filePath{
    
    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    long fileLength = (long)[[fileDict objectForKey:NSFileSize] unsignedLongLongValue];
    if(fileLength < 500){
        return 0;
    }
    return fileLength;
}


- (NSString*)md5FromStr:(NSString*)targetStr{
    
    if(targetStr.length == 0){
        return nil;
    }
    const char *original_str = [targetStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (unsigned int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}



@end
