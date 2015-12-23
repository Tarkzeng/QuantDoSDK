//
//  QDInfomationView.m
//  SDKTest
//
//  Created by ZengTark on 15/9/8.
//  Copyright (c) 2015年 quantdo. All rights reserved.
//

#import "QDInfomationView.h"

static QDClickAtIndexBlock _clickAtIndexBlock;

@interface QDInfomationView ()<UIAlertViewDelegate,UIActionSheetDelegate>

@end

@implementation QDInfomationView

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles clickAtIndex:(QDClickAtIndexBlock)clickAtIndex
{
    _clickAtIndexBlock = [clickAtIndex copy];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    for (NSString *buttonTitle in otherButtonTitles) {
        [alert addButtonWithTitle:buttonTitle];
    }
    [alert show];
    return alert;
}

+ (UIActionSheet *)showActionSheetInView:(UIView *)view withTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles clickAtIndex:(QDClickAtIndexBlock)clickAtIndex
{
    _clickAtIndexBlock = [clickAtIndex copy];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:[self self]
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:destructiveButtonTitle
                                              otherButtonTitles:nil];
    for (NSString *buttonTitle in otherButtonTitles) {
        [sheet addButtonWithTitle:buttonTitle];
    }
    [sheet showInView:view];
    return sheet;
}

#pragma mark - alertView代理
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _clickAtIndexBlock(buttonIndex);
}

+ (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    
    _clickAtIndexBlock = nil;
}

#pragma mark - actionSheetView代理
+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    _clickAtIndexBlock(buttonIndex);
}

+ (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    _clickAtIndexBlock = nil;
}

@end
