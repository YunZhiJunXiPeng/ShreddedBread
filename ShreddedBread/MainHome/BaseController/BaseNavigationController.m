//
//  BaseNavigationController.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/13.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/**
 *  自定义的导航控制器  
 *  标签控制器的四个子视图 都是这个导航控制的实例对象
 *  四个rootViewController 分别是我们的四个 分类界面

 *  在这里主要是设置  push 时候隐藏(上 ,下 的 navigationBar和 tabBar)
 *  需要把相同的地方统一设置  比如统一设置左上角的返回按钮 为 <- (二级页面中 具体看下面的设置方法)
 *
 *  在很多地方用到的方法 为了代码分离会抽取出来  
 *  其他文件也用到的方法 可以写成一个类的方法 或者通过的 类的 延展和类目 进行
 *  这里创建 导航栏上的 itme 方法我们写到了 类目中 通过一个值设置 UIview 的 frame 的方法在延展中
 */

#import "BaseNavigationController.h"
#import "Color_marco.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
#pragma mark ------>> 设置 item主题的 的字体和颜色 <<------
// 当这个类第一次使用的时候会走这个方法
+ (void)initialize
{
// 设置整体的 itme 的主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
 
// 设置普通状态 主题颜色
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13], NSForegroundColorAttributeName:JJ_THEME_COLOR} forState:(UIControlStateNormal)];

// 设置不可用状态 按钮的有色和 Tabbar 的未点击颜色一致
// (注意要想 按钮状态为不可用时候显示生效 需要在按钮加载之前设置属性 item.enabled = NO)
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:(13)], NSForegroundColorAttributeName:JJ_TABBAR_COLOR} forState:(UIControlStateDisabled)];
}




#pragma mark ------>> 重写 BaseNavigationController 的 Push 方法 <<------

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 执行以下原来的的 push 方法不然没法跳转
    [super pushViewController:viewController animated:animated];
    // 判断是不是根视图 等于 1 说明是第一个 根视图  不需要返回按钮 也不应该隐藏上下的 navigationBar 和 tabBar
   
    if (self.viewControllers.count > 1)
    {
       // NSLog(@"---push 方法--->%ld",self.viewControllers.count );
        // 隐藏 底部 tabBar 暂时不隐藏 navigationBar
        //viewController.hidesBottomBarWhenPushed = YES;
        // 设置左上角的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"bar_back_gray" hightImage:@"bar_back_red"];
        
    }
   

}
// pop 返回上一个页面的方法
- (void)backAction
{
    [self popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
