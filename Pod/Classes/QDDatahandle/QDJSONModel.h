//
//  QDJSONModel.h
//  SDKTest
//  Json操作
//  Created by ZengTark on 15/9/10.
//  Copyright (c) 2015年 quantdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDJSONModel : NSObject

/**
 *  把对象转换成字典
 *
 *  @param model 模型对象
 *
 *  @return 返回字典
 */
+ (NSDictionary *)dictionaryWithModel:(id)model;

/**
 *  获取Model的所有属性名称
 *
 *  @param model 模型对象
 *
 *  @return 返回模型中的所有属性值
 */
+ (NSArray *)propertiesInModel:(id)model;

/**
 *  把字典转换成名称为className的模型
 *
 *  @param dict      字典对象
 *  @param className 类名
 *
 *  @return 返回数据模型对象
 */
+ (id)modelWithDictionary:(NSDictionary *)dict className:(NSString *)className;


/**
 *  将字典转换为Json字符串
 *
 *  @param theData 字典
 *
 *  @return Json字符串
 */
+ (NSString*)dictionaryToJson:(id)theData;
/**
 *  json字符串转换为对象
 *
 *  @param jsonString json串
 *
 *  @return 对象（数组或者字典）
 */
+ (id)getObjectFromJsonString:(NSString *)jsonString;

@end
