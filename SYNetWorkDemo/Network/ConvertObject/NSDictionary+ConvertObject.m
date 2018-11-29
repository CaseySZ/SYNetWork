//
//  NSDictionary+ConvertObject.m
//  XPSPlatform
//
//  Created by sy on 2017/11/23.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "NSDictionary+ConvertObject.h"
#import <objc/runtime.h>

@implementation NSObject (SYConvert)

- (void)setProValue:(id)propertyValue property:(NSString*)propertyName{
    
    if (!propertyName || propertyName.length == 0) {
        return;
    }
    
    NSString *setterSEL = [NSString stringWithFormat:@"set%@%@:", [[propertyName substringToIndex:1] capitalizedString], [propertyName substringFromIndex:1]];
    
    if([self respondsToSelector:NSSelectorFromString(setterSEL)]){
        
        // value异常没处理
        if ([propertyValue isKindOfClass:[NSNull class]] || propertyValue == nil) {
            propertyValue = @"";
        }
        [self setValue:propertyValue forKey:propertyName];
        
    }else {
        
    }
}
@end

@implementation NSDictionary (ConvertObject)

- (id)convertToNewObjecWithClass:(Class)TargetClass{
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSObject *targetObj = (NSObject*)[[TargetClass alloc] init];
        [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj != [NSNull null]) {
                [targetObj setProValue:obj property:key];
            }
        }];
        return targetObj;
    }
    return nil;
}

- (void)convertToObject:(NSObject*)targetObject{
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        
        [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSNull class]] || obj == nil) {
                [targetObject setProValue:@"" property:key];
            }else if([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]){
                [targetObject setProValue:obj property:key];
            }else{
                [targetObject setProValue:[obj description] property:key];
            }
        }];
    }
}

@end


@implementation NSArray (ConvertObject)

- (NSArray*)convertToNewObjecWithClass:(Class)TargetClass{
    
    NSMutableArray *backArr = [NSMutableArray new];
    for (int i = 0; i< self.count; i++) {
        
        NSDictionary *infoDict = self[i];
        if ([infoDict isKindOfClass:[NSDictionary class]]) {
            [backArr addObject:[infoDict convertToNewObjecWithClass:TargetClass]];
        }
        
    }
    return backArr;
}


@end


@implementation NSNull (ConvertObject)

- (id)convertToNewObjecWithClass:(Class)TargetClass{
    
    return nil;
}

- (void)convertToObject:(NSObject*)targetObject{
    
}

@end

@implementation NSObject (ConvertDictionary)

-(NSDictionary*)convertToDictionary{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
   
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([self class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [self valueForKey:propName];
        if(value == nil) {
            value = [NSNull null];
            
        } else {
            // 暂时只做一层转换
            //value = [value objectInternalConvertDictionary];
        }
        [dic setObject:value forKey:propName];
    }
    
    return dic;
}

// 内部如有对象，继续转换
- (id)objectInternalConvertDictionary{
    
    if([self isKindOfClass:[NSString class]]
       || [self isKindOfClass:[NSNumber class]]
       || [self isKindOfClass:[NSNull class]]
       || [self isKindOfClass:[NSValue class]]) {
        
        return self;
    }
    
    if([self isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = (NSArray*)self;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0; i < objarr.count; i++) {
            
            NSObject *object = objarr[i];
            [arr setObject:[object objectInternalConvertDictionary] atIndexedSubscript:i];
        }
        return arr;
    }
    if([self isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *objdic = (NSDictionary*)self;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys) {
            NSObject *object = [objdic objectForKey:key];
            [dic setObject:[object objectInternalConvertDictionary] forKey:key];
        }
        return dic;
    }
    return [self convertToDictionary];
    
}

@end

