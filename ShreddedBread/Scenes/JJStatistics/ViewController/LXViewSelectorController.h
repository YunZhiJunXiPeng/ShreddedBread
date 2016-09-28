//
//  LXViewSelectorController.h
//  ViewSelector
//
//  Created by XiaoleiLi on 16/8/8.
//  Copyright © 2016年 leehyoley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXViewSelectorController : UIViewController


//标题字体大小（默认14）
@property (nonatomic,assign)CGFloat fontSize;
//提示条大小(默认为40，2)
@property (nonatomic,assign)CGSize tipSize;
//选中颜色(默认为红色)
@property (nonatomic,strong)UIColor *selectedColor;
//未选中颜色(默认为黑色)
@property (nonatomic,assign)UIColor *normalColor;

@end
