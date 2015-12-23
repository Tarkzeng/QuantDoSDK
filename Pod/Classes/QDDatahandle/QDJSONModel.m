//
//  QDJSONModel.m
//  SDKTest
//
//  Created by ZengTark on 15/9/10.
//  Copyright (c) 2015年 quantdo. All rights reserved.
//

#import "QDJSONModel.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, QDJSONModelDataType) {
    kQDJSONModelDataTypeObject = 0,
    kQDJSONModelDataTypeBOOL = 1,
    kQDJSONModelDataTypeInteger = 2,
    kQDJSONModelDataTypeFloat = 3,
    kQDJSONModelDataTypeDouble = 4,
    kQDJSONModelDataTypeLong = 5,
};

@implementation QDJSONModel

+ (NSDictionary *)dictionaryWithModel:(id)model
{
    if (model == nil) {
        return nil;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //获取类名、根据类名获取类对象
    NSString *className = NSStringFromClass([model class]);
    id classObject = objc_getClass([className UTF8String]);
    
    //获取所有属性
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    //遍历所有属性
    for (int i = 0; i < count; i ++) {
        //取得属性
        objc_property_t property = properties[i];
        //取得属性名
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //取得属性值
        id propertyValue = nil;
        id valueObject = [model valueForKey:propertyName];
        
        if ([valueObject isKindOfClass:[NSDictionary class]]) {
            propertyValue = [NSDictionary dictionaryWithDictionary:valueObject];
        }else if ([valueObject isKindOfClass:[NSArray class]]) {
            propertyValue = [NSArray arrayWithArray:valueObject];
        }else {
            propertyValue = [NSString stringWithFormat:@"%@",[model valueForKey:propertyName]];
        }
        [dict setObject:propertyValue forKey:propertyName];
    }
    return [dict copy];
}


+ (NSArray *)propertiesInModel:(id)model {
    if (model == nil) {
        return nil;
    }
    
    NSMutableArray *propertiesArray = [[NSMutableArray alloc] init];
    NSString *className = NSStringFromClass([model class]);
    id classObject = objc_getClass([className UTF8String]);
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    for (int i = 0; i < count; i ++) {
        //取得属性名
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propertiesArray addObject:propertyName];
    }
    return [propertiesArray copy];
}

+ (id)modelWithDictionary:(NSDictionary *)dict className:(NSString *)className
{
    if (dict == nil || className == nil || className.length == 0) {
        return nil;
    }
    
    id model = [[NSClassFromString(className) alloc] init];
    //取得类对象
    id classObject = objc_getClass([className UTF8String]);
    
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    Ivar *ivars = class_copyIvarList(classObject, nil);
    for (int i = 0; i < count; i ++) {
        //取得成员名
        NSString *menberName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        const char *type = ivar_getTypeEncoding(ivars[i]);
        NSString *dataType = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        
        NSLog(@"Data %@ type: %@",menberName,dataType);
        
        QDJSONModelDataType rtype = kQDJSONModelDataTypeObject;
        if ([dataType hasPrefix:@"c"]) {
            rtype = kQDJSONModelDataTypeBOOL;
        }else if ([dataType hasPrefix:@"i"]) {
            rtype = kQDJSONModelDataTypeInteger;
        }else if ([dataType hasPrefix:@"f"]) {
            rtype = kQDJSONModelDataTypeFloat;
        }else if ([dataType hasPrefix:@"d"]) {
            rtype = kQDJSONModelDataTypeDouble;
        }else if ([dataType hasPrefix:@"l"]) {
            rtype = kQDJSONModelDataTypeLong;
        }
        
        for (int j = 0; j < count; j ++) {
            objc_property_t property = properties[j];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            NSRange range = [menberName rangeOfString:propertyName];
            
            if (range.location == NSNotFound) {
                continue;
            }else {
                id propertyValue = [dict objectForKey:propertyName];
                
                switch (rtype) {
                    case kQDJSONModelDataTypeBOOL:
                    {
                        BOOL temp = [[NSString stringWithFormat:@"%@", propertyValue] boolValue];
                        propertyValue = [NSNumber numberWithBool:temp];
                    }
                        break;
                    case kQDJSONModelDataTypeInteger:
                    {
                        int temp = [[NSString stringWithFormat:@"%@",propertyValue] intValue];
                        propertyValue = [NSNumber numberWithInt:temp];
                    }
                        break;
                    case kQDJSONModelDataTypeFloat:
                    {
                        float temp = [[NSString stringWithFormat:@"%@",propertyValue] floatValue];
                        propertyValue = [NSNumber numberWithFloat:temp];
                    }
                        break;
                    case kQDJSONModelDataTypeDouble:
                    {
                        double temp = [[NSString stringWithFormat:@"%@",propertyValue] doubleValue];
                        propertyValue = [NSNumber numberWithDouble:temp];
                    }
                        break;
                    case kQDJSONModelDataTypeLong:
                    {
                        long long temp = [[NSString stringWithFormat:@"%@",propertyValue] longLongValue];
                        propertyValue = [NSNumber numberWithLongLong:temp];
                    }
                        break;
                    default:
                        break;
                }
                
                [model setValue:propertyValue forKey:menberName];
            }
        }
    }
    return model;
}

#pragma mark - JSONString Handles
/**
 *  将字典转换为Json字符串
 *
 *  @param theData 字典
 *
 *  @return Json字符串
 */
+ (NSString*)dictionaryToJson:(id)theData
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&parseError];
    if (parseError != nil) {
        return nil;
    }
    else
    {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

/**
 *  json字符串转换为对象
 *
 *  @param jsonString json串
 *
 *  @return 对象（数组或者字典）
 */
+ (id)getObjectFromJsonString:(NSString *)jsonString
{
    NSError *error = nil;
    if (jsonString != nil) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error != nil) {
            return nil;
        }
        else
        {
            return jsonObject;
        }
    }
    else
        return nil;
}

@end
