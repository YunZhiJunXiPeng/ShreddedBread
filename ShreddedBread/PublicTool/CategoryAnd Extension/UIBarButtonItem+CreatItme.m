//
//  UIBarButtonItem+CreatItme.m
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
#import "UIBarButtonItem+CreatItme.h"


@implementation UIBarButtonItem (CreatItme)

/*
 *      target 目标
 *      action 点击 item 方法
 *      image  图片
 *      hightImage 高亮图片
 *
 */
+ (UIBarButtonItem *)itemWithTarget:(id)target
                             action:(SEL)action
                              image:(NSString *)image
                         hightImage:(NSString *)hightImage
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [btn setBackgroundImage:[UIImage imageNamed:hightImage] forState:(UIControlStateHighlighted)];
    // 设置尺寸 根据照片的尺寸
    btn.size = CGSizeMake(30, 30);
    return [[UIBarButtonItem alloc] initWithCustomView:btn];}




@end
