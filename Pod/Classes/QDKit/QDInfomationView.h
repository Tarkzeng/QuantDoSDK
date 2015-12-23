//
//  QDInfomationView.h
//  SDKTest
//
//  Created by ZengTark on 15/9/8.
//  Copyright (c) 2015年 quantdo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^QDClickAtIndexBlock)(NSInteger buttonIndex);

@interface QDInfomationView : NSObject

/**
 *  弹出AlertView对话框
 *
 *  @param title             标题
 *  @param message           信息
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其他按钮标题
 *  @param clickAtIndex      获取点击信息的Block
 *
 *  @return AlertView对象
 */
+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)otherButtonTitles
                           clickAtIndex:(QDClickAtIndexBlock)clickAtIndex;

/**
 *  弹出ActionSheet对话框
 *
 *  @param view                   要显示的View
 *  @param title                  标题
 *  @param cancelButtonTitle      取消按钮标题
 *  @param destructiveButtonTitle destructive按钮标题
 *  @param otherButtonTitles      其他按钮标题
 *  @param clickAtIndex           获取点击信息的Block
 *
 *  @return ActionSheet对象
 */
+ (UIActionSheet *)showActionSheetInView:(UIView *)view
                               withTitle:(NSString *)title
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                  destructiveButtonTitle:(NSString *)destructiveButtonTitle
                       otherButtonTitles:(NSArray *)otherButtonTitles
                            clickAtIndex:(QDClickAtIndexBlock)clickAtIndex;
@end
