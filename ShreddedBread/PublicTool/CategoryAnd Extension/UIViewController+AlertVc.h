//
//  UIViewController+AlertVc.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/14.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/**
 *  UIViewViewController 类目  封装了弹窗的功能
 *
 *
 */

#import <UIKit/UIKit.h>


@interface UIViewController (AlertVc)


// 弹窗  两个按钮
- (void)showAlertViewControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                         alertActionName:(nullable NSString *)alertActionName
                          alertActionOne:(nullable void (^)())alertActionOne
                          alertBackAfter:(nullable void (^)())alertBackAction;


// 弹窗 多少秒之后消失

- (void)showAlertViewControllerWithStr:(nullable NSString *)str time:(float)time;




// 弹框 一个按钮
- (void)showAlertViewControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                         alertActionName:(nullable NSString *)alertActionName;



@end
