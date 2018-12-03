//
//  NetMananger+UpdateFile.m
//  OpenPlatformGame
//
//  Created by Casey on 03/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "NetMananger+UpdateFile.h"
#import "AFNetworking.h"

@implementation NetMananger (UpdateFile)




- (void)updateFileWithUrl:(NSString*)urlStr fileData:(NSData*)fileData name:(NSString*)nameServiceKey fileName:(NSString*)fileName mimeType:(NSString*)fileType uploadProgress:(UpdateProgressBlock)uploadProgress completion:(nullable void (^)(NSError * nullable))completion{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [manager setTaskDidSendBodyDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
        if (uploadProgress){
            
            uploadProgress(bytesSent, totalBytesSent)
        }
        
    }];
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:nameServiceKey fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull progress) {
      
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion){
            completion(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        if (completion){
            completion(error);
        }
        
    }];
    
}





@end
