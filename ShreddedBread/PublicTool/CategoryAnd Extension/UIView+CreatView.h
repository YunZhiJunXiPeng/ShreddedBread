//
//  UIView+CreatView.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/13.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CreatView)


@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGSize  size;

@property (assign, nonatomic) CGFloat jjHeight;
@property (assign, nonatomic) CGFloat jjWidth;

+ (BOOL)clearSeparatorWithView:(UIView * )view;

@end
