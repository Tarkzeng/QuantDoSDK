//
//  QDRequestErrorCodeMap.m
//  QuantDoSDK
//
//  Created by ZengTark on 15/9/7.
//  Copyright (c) 2015年 quantdo. All rights reserved.
//

#import "QDRequestErrorCodeMap.h"

@implementation QDRequestErrorCodeMap

+ (NSString *)messageForErrorCode:(NSInteger)errorCode
{
    NSString *message = @"";
    switch (errorCode) {
        case 1:
            message = @"用户名或密码错误";
            break;
        case 2:
            message = @"账户锁定";
            break;
        case 3:
            message = @"用户已在别处登录";
            break;
        case 4:
            message = @"输入错误次数超过系统允许最大次数";
            break;
        case 5:
            message = @"密码已过期";
            break;
        case 6:
            message = @"其他错误";
            break;
        case 100:
            message = @"未登录";
        case 101:
            message = @"无权限访问";
            break;
        case 102:
            message = @"访问版本不支持";
            break;
        case 103:
            message = @"会话失败";
            break;
        case 104:
            message = @"请求无对应服务";
            break;
        case 105:
            message = @"请求接口错误";
            break;
        case 106:
            message = @"返回对象无法做Json对象转换";
            break;
        case 107:
            message = @"请求参数个数错误";
            break;
        case 108:
            message = @"请求参数类型错误";
            break;
        case 109:
            message = @"请求参数无法转换java对象";
            break;
        case 110:
            message = @"后台业务处理遇到未知错误";
            break;
        case 111:
            message = @"entity定义错误";
            break;
        case 112:
            message = @"数据库无法获得连接";
            break;
        case 113:
            message = @"参数验证错误";
            break;
        case 114:
            message = @"当前服务不可用";
            break;
        case 200:
            message = @"";
            break;
        default:
            break;
    }
    return message;
}

@end
