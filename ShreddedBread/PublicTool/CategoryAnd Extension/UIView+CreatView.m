//
//  UIView+CreatView.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/13.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/**
 * 这个类目 就是为了设置 UIView 的 frame
 * 当你只希望改变 View 的某一个 位置属性时候可以用这个类目
 *  
 * 当你需要修改某一个 UIView 的 frame 的 某一个属性 时候是需要 view.x 点出来修改即可  得到某一个属性点出来即可 .x
 */
#import "UIView+CreatView.h"

@implementation UIView (CreatView)

// 当你需要修改某一个 UIView 的 frame 的 x 时候是需要 view.x = 100 即 可以下类似
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
// 当你需要某一个 UIView 的 frame 的 x 时候是需要 view.x 即可以下类似
- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
    
}

- (void)setJjWidth:(CGFloat)jjWidth
{
    CGRect frame = self.frame;
    CGSize size = frame.size;
    size.width = jjWidth;
    self.frame = frame;
}

- (CGFloat)jjWidth
{
    return self.frame.size.width;
}

- (void)setJjHeight:(CGFloat)jjHeight
{
    CGRect frame = self.frame;
    CGSize size = frame.size;
    size.height = jjHeight;
    self.frame = frame;
}

- (CGFloat)jjHeight
{
    return self.frame.size.height;
}


#pragma mark ------>> 删除划线 <<------
+ (BOOL)clearSeparatorWithView:(UIView * )view
{
 
    if(view.subviews != 0  )
    {
        //NSLog(@"有无子类");
        if(view.bounds.size.height < 5)
        {
            NSLog(@"清除分割线---->隐藏");
            view.backgroundColor = [UIColor clearColor];
            return YES;
        }
        
        [view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self clearSeparatorWithView:obj];
        }];
    }
    return NO;
}




@end
