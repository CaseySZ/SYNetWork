//
//  NSDictionary+ConvertObject.h
//  XPSPlatform
//
//  Created by sy on 2017/11/23.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ConvertObject)

- (id)convertToNewObjecWithClass:(Class)TargetClass;

- (void)convertToObject:(NSObject*)targetObject;

@end


@interface NSArray (ConvertObject)

- (NSArray*)convertToNewObjecWithClass:(Class)TargetClass;

@end

@interface NSNull (ConvertObject)

- (id)convertToNewObjecWithClass:(Class)TargetClass;

- (void)convertToObject:(NSObject*)targetObject;

@end


@interface NSObject (ConvertDictionary)

-(NSDictionary*)convertToDictionary;

@end

