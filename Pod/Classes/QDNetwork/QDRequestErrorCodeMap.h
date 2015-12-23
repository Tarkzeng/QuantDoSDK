//
//  QDRequestErrorCodeMap.h
//  QuantDoSDK
//  错误码映射
//  Created by ZengTark on 15/9/7.
//  Copyright (c) 2015年 quantdo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDRequestErrorCodeMap : NSObject


/**
 *  根据返回的errorCode返回errorMessage
 *
 *  @param errorCode errorCode
 *
 *  @return errorMessage
 */
+ (NSString *)messageForErrorCode:(NSInteger)errorCode;

@end
