//
//  UIBarButtonItem+CreatItme.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/13.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/**
 *  UIBarButtonItem 的延展
 *
 *  在需要创建一个 navigation  的 BarButtonItme时候调用类方法即可
 */


#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CreatItme)

// 参数解释在 .m 中
+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                              image:(NSString *)image
                         hightImage:(NSString *)hightImage;


@end
