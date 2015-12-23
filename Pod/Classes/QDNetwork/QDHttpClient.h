//
//  QDHttpClient.h
//  QuantDoSDK
//  HTTP网络请求
//  Created by ZengTark on 15/9/7.
//  Copyright (c) 2015年 quantdo. All rights reserved.
//

#import <Foundation/Foundation.h>


//HTTP REQUEST METHOD TYPE
typedef NS_ENUM(NSInteger, QDHttpRequestType) {
    QDHttpRequestGet = 1,
    QDHttpRequestPost,
    QDHttpRequestDelete,
    QDHttpRequestPut,
};

/**
 *  请求之前预处理Block
 */
typedef void(^ PrepareExecuteBlock)(void);

typedef void(^ SuccessBlock)(id result);

typedef void(^ LogonResultBlock)(BOOL isLogon);

typedef void(^ FailureBlock)(NSError *error);

@interface QDHttpClient : NSObject

/**
 *  单例模式方法
 */
+ (instancetype)defaltClient;

/**
 *  HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param path
 *  @param method     RESTFul请求类型
 *  @param parameters 请求参数
 *  @param prepare    请求前预处理块
 *  @param success    请求成功处理块
 *  @param failure    请求失败处理块
 */
- (void)requestWithPath:(NSString *)url
                 method:(QDHttpRequestType)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock) prepare
                success:(SuccessBlock)success
                failure:(FailureBlock)failure;

/**
 *  HTTP请求（GET、POST、DELETE、PUT）
 *
 *  @param moduleName  模块名
 *  @param serviceName 服务名
 *  @param funcName    方法名
 *  @param method      请求类型
 *  @param parameters  请求参数
 *  @param prepare     请求前预处理块
 *  @param success     请求成功处理块
 *  @param failure     请求失败处理块
 */
- (void)requestServiceWithModuleName:(NSString *)moduleName
                         serviceName:(NSString *)serviceName
                            funcName:(NSString *)funcName
                              method:(QDHttpRequestType)method
                          parameters:(NSDictionary *)parameters
                      prepareExecute:(PrepareExecuteBlock)prepareExecute
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure;


/**
 *  用户登录
 *
 *  @param userName       用户名
 *  @param password       密码
 *  @param prepareExecute 前预处理
 *  @param success        是否成功登录
 */
- (void)logonWithUserName:(NSString *)userName password:(NSString *)password prepareExecute:(PrepareExecuteBlock)prepareExecute success:(LogonResultBlock)success;

@end
