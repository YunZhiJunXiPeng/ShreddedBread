//
//  UIViewController+AlertVc.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/14.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/**
 *  这里是一些弹窗的视图
 *
 *
 *
 
 */

#import "UIViewController+AlertVc.h"

@implementation UIViewController (AlertVc)



- (void)showAlertViewControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                         alertActionName:(nullable NSString *)alertActionName
                          alertActionOne:(void (^)())alertActionOne
                         alertBackAfter:(void (^)())alertBackAction

{
   dispatch_async(dispatch_get_main_queue(), ^{
       UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
       
     
       [alert addAction:[UIAlertAction actionWithTitle:alertActionName style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
           alertActionOne();
       }]];
       [alert addAction:[UIAlertAction actionWithTitle:@"返回" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
           alertBackAction();
           
       }]];
       
       [self presentViewController:alert animated:YES completion:nil];
   });
    
}

- (void)showAlertViewControllerWithStr:(NSString *)str time:(float)time
{

    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message:nil preferredStyle:UIAlertControllerStyleAlert];
   
        [self presentViewController:alert animated:YES completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
        
    });


}

- (void)showAlertViewControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(UIAlertControllerStyle)preferredStyle
                         alertActionName:(nullable NSString *)alertActionName{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
        
        
        [alert addAction:[UIAlertAction actionWithTitle:alertActionName style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {

        }]];
        [self presentViewController:alert animated:YES completion:nil];
    });

}

@end
