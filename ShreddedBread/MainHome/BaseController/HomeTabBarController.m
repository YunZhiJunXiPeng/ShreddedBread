//
//  HomeTabBarController.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/13.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

/**
 *  这是标签控制器  Window 的根视图
 *
 *  在这里设置子视图的相关属性  数量 标题  图标 选中图标
 *
 *
 */


#import "HomeTabBarController.h"
// 设置颜色的头文件
#import "BaseNavigationController.h" // 引入导航控制器
// 引入自控制器
#import "PPCalendarVC.h"
#import "JJViewController.h"
#import "ZCMJokeBookTabVC.h"
#import "WSLVideoTabVC.h"
#import "PPSettingVC.h"

@interface HomeTabBarController ()<UITabBarControllerDelegate>


@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

// 创建四个itme  

    PPCalendarVC *ppVc = [PPCalendarVC new];
    [self addOneSubVc:ppVc title:@"日历" imageName:@"tabbar_calendar_gray" selectedImageName:@"tabbar_calendar_red"];
    
    JJViewController *jjVc = [JJViewController new];
    [self addOneSubVc:jjVc title:@"统计" imageName:@"tabbar_statistic_gray" selectedImageName:@"tabbar_statistic_red"];
    
   ZCMJokeBookTabVC *zcmVc = [ZCMJokeBookTabVC new];
  [self addOneSubVc:zcmVc title:@"笑话" imageName:@"tabbar_smile_gray" selectedImageName:@"tabbar_smile_red"];
    
    WSLVideoTabVC *wslVc = [[WSLVideoTabVC alloc] initWithNibName:nil bundle:nil];
    [self addOneSubVc:wslVc title:@"视频" imageName:@"tabbar_video_gray" selectedImageName:@"tabbar_video_red"];
    
    PPSettingVC *settingVv = [[PPSettingVC alloc] init];
    [self addOneSubVc:settingVv title:@"个人中心" imageName:@"tabbar_setting_gray" selectedImageName:@"tabbar_setting_red"];
    
// 设置自身代理
    self.delegate = self;
}


/**
 *  添加子视图方法
 *   @param title 标题
 *   @param imageName 图标
 *   @param selectedImageName 选中图标
 */
#pragma mark ------>> 添加 子控制器 <<------
- (void)addOneSubVc:(UIViewController *)subVc
              title:(NSString *)title
          imageName:(NSString *)imageName
  selectedImageName:(NSString *)selectedImageName
{
    // 子视图的背景色  不要在这里设置背景颜色  否则的话已进入 App 就会加载四个界面的数据
    //subVc.view.backgroundColor = [UIColor whiteColor];

    // 同时设置 tabbar 和 navigationBar 的文字
    subVc.title = title;


    // 设置子控制器的图片 (tabbar 的 itme)
    subVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置点击时候的照片 要设置不被渲染 iOS7 之后
    subVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    // 设置文字样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    [textAttrs setValue:JJ_TABBAR_COLOR forKey:NSForegroundColorAttributeName];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    [selectTextAttrs setValue:JJ_THEME_COLOR forKey:NSForegroundColorAttributeName];
    // TabBar 选中的时候是 主题颜色 未选中的时候是 Tabbar 默认颜色  在 HeadFile中的头文件设置
    [subVc.tabBarItem setTitleTextAttributes:textAttrs forState:(UIControlStateNormal)];
    [subVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:(UIControlStateSelected)];
    
    // 添加相应的导航控制器
    BaseNavigationController *baseNC = [[BaseNavigationController alloc] initWithRootViewController:subVc];
    // 添加到标签控制器
    [self addChildViewController:baseNC];
}

#pragma mark ------>> 点击 item 时候 让其他的回到 pop  栈顶<<------
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%s-----%@",__func__,viewController);
    for (UIViewController *vc in self.viewControllers)
    {
        if (vc != viewController)
        {
            [(UINavigationController *)vc popViewControllerAnimated:YES];
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
