//
//  ComplaintView.m
//  ShreddedBread
//
//  Created by BoonZ on 16/9/4.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "ComplaintView.h"

@implementation ComplaintView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)sendAction:(UIButton *)sender
{
    self.sendBlock();
[self goBack];

}

- (IBAction)backAction:(UIButton *)sender {
    
    [self goBack];
}



- (void)goBack
{
    // 触摸收起
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        //缩小到指定的位置
        self.center = CGPointMake(40,0);
        
    }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];
    
}


@end
