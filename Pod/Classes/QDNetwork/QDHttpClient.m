//
//  QDHttpClient.m
//  QuantDoSDK
//
//  Created by ZengTark on 15/9/7.
//  Copyright (c) 2015年 quantdo. All rights reserved.
//

#import "QDHttpClient.h"
#import "QDAPIConfig.h"
#import "QDInfomationView.h"
#import "AFNetworking.h"
#import "QDRequestErrorCodeMap.h"
#import "QDJSONModel.h"

#define QDRequestSuccessErrorCode 200

@interface QDHttpClient()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation QDHttpClient

- (instancetype)init
{
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        //        self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain", nil];
        
        [self.manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    [QDInfomationView showAlertViewWithTitle:@""
                                                     message:@"网络不给力啊"
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil
                                                clickAtIndex:^(NSInteger buttonIndex) {
                                                    
                                                }];
                }
                    break;
                case AFNetworkReachabilityStatusUnknown:
                {
                    [QDInfomationView showAlertViewWithTitle:@""
                                                     message:@"网络又调皮了"
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil
                                                clickAtIndex:^(NSInteger buttonIndex) {
                                                    
                                                }];
                }
                    break;
                default:
                    break;
            }
        }];
        
    }
    return self;
}

+ (instancetype)defaltClient
{
    static QDHttpClient *_client = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _client = [[QDHttpClient alloc] init];
    });
    return _client;
}

- (NSString *)returnPathString:(NSString *)path
{
    NSString *returnString = @"";
    if (path != nil && path != NULL && path.length > 0) {
        returnString = [NSString stringWithFormat:@"%@/",path];
    }
    return returnString;
}


- (void)logonWithUserName:(NSString *)userName password:(NSString *)password prepareExecute:(PrepareExecuteBlock)prepareExecute success:(LogonResultBlock)success
{
    NSString *url = [NSString stringWithFormat:@"%@%@logon",QD_SERVER_HOST,QD_PROJECT_NAME];
    NSDictionary *params = @{@"userName":userName, @"password":password};
    NSDictionary *jsonParams = @{@"params":[QDJSONModel dictionaryToJson:params]};
    
    if (prepareExecute) {
        prepareExecute();
    }
    [self.manager POST:url parameters:jsonParams success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        BOOL isLogon = [self verifyTheReqeustTask:task];
        if (isLogon) {
            NSInteger responseErrorCode = [[responseObject objectForKey:@"errorCode"] integerValue];
            if (responseErrorCode != 0) {
                isLogon = NO;
                [self getErrorMessageFromErrorCode:responseErrorCode];
            }
            success(isLogon);
        }
    } failure:^(NSURLSessionDataTask * __unused task, NSError * error) {
        NSLog(@"LogonError:%@",error);
    }];
}

- (void)requestServiceWithModuleName:(NSString *)moduleName
                         serviceName:(NSString *)serviceName
                            funcName:(NSString *)funcName
                              method:(QDHttpRequestType)method
                          parameters:(NSDictionary *)parameters
                      prepareExecute:(PrepareExecuteBlock)prepareExecute
                             success:(SuccessBlock)success
                             failure:(FailureBlock)failure
{
    NSString *url = [NSString stringWithFormat:@"%@%@",QD_SERVER_HOST,QD_PROJECT_NAME];
    
    url = [url stringByAppendingString:[self returnPathString:moduleName]];
    url = [url stringByAppendingString:[self returnPathString:serviceName]];
    url = [url stringByAppendingString:[self returnPathString:funcName]];
    
    NSLog(@"url:%@",url);
    
    NSDictionary *jsonParams = nil;
    if (parameters) {
        jsonParams = @{@"params":[QDJSONModel dictionaryToJson:parameters]};
    }
    
    //预处理（显示加载信息啥的）
    if (prepareExecute) {
        prepareExecute();
    }
    switch (method) {
        case QDHttpRequestGet:
        {
            [self.manager GET:url parameters:jsonParams success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                
                if ([self verifyTheReqeustTask:task]) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * __unused task, NSError * error) {
                failure(error);
            }];
            //[self.manager GET:url parameters:jsonParams success:success failure:failure];
        }
            break;
        case QDHttpRequestPost:
        {
            [self.manager POST:url parameters:jsonParams success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                if ([self verifyTheReqeustTask:task]) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * __unused task, NSError * error) {
                failure(error);
            }];
        }
            break;
        case QDHttpRequestDelete:
        {
            [self.manager DELETE:url parameters:jsonParams success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                if ([self verifyTheReqeustTask:task]) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * __unused task, NSError * error) {
                failure(error);
            }];
        }
            break;
        case QDHttpRequestPut:
        {
            [self.manager PUT:url parameters:jsonParams success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                if ([self verifyTheReqeustTask:task]) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * __unused task, NSError * error) {
                failure(error);
            }];
        }
            break;
        default:
            break;
    }
}

- (NSInteger)verifyTheReqeustTask:(NSURLSessionDataTask *)task
{
    BOOL veryfyResutl = NO;
    NSInteger errorCode = 0;
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    if (response) {
        errorCode = [[response.allHeaderFields objectForKey:@"error_code"] integerValue];
    }
    if (errorCode == QDRequestSuccessErrorCode) {
        //成功
        veryfyResutl = YES;
    }
    else
    {
        [self getErrorMessageFromErrorCode:errorCode];
    }
    return errorCode;
}

- (void)getErrorMessageFromErrorCode:(NSInteger)errorCode
{
    NSString *errorMessage = [QDRequestErrorCodeMap messageForErrorCode:errorCode];
    if (errorMessage.length > 0) {
        [QDInfomationView showAlertViewWithTitle:@"" message:errorMessage cancelButtonTitle:@"确定" otherButtonTitles:nil clickAtIndex:^(NSInteger buttonIndex) {
            
        }];
    }
    
}


- (void)requestWithPath:(NSString *)url
                 method:(QDHttpRequestType)method
             parameters:(id)parameters
         prepareExecute:(PrepareExecuteBlock)prepareExecute
                success:(SuccessBlock)success
                failure:(FailureBlock)failure
{
    //请求的URL
    NSLog(@"Request path:%@",url);
    
    NSLog(@"url:%@",url);
    
    NSDictionary *jsonParams = nil;
    if (parameters) {
        if ([parameters isKindOfClass:[NSString class]]) {
            jsonParams = @{@"params":parameters};
        }
        else
        {
            jsonParams = @{@"params":[QDJSONModel dictionaryToJson:parameters]};
        }
    }
    
    //预处理（显示加载信息啥的）
    if (prepareExecute) {
        prepareExecute();
    }
    switch (method) {
        case QDHttpRequestGet:
        {
            [self.manager GET:url parameters:jsonParams success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                if ([self verifyTheReqeustTask:task]) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * __unused task, NSError * error) {
                failure(error);
            }];
        }
            break;
        case QDHttpRequestPost:
        {
            [self.manager POST:url parameters:jsonParams success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                if ([self verifyTheReqeustTask:task]) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * __unused task, NSError * error) {
                failure(error);
            }];
        }
            break;
        case QDHttpRequestDelete:
        {
            [self.manager DELETE:url parameters:jsonParams success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                if ([self verifyTheReqeustTask:task]) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * __unused task, NSError * error) {
                failure(error);
            }];
        }
            break;
        case QDHttpRequestPut:
        {
            [self.manager PUT:url parameters:jsonParams success:^(NSURLSessionDataTask * __unused task, id responseObject) {
                if ([self verifyTheReqeustTask:task]) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * __unused task, NSError * error) {
                failure(error);
            }];
        }
            break;
        default:
            break;
    }
}



@end
