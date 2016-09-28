//
//  AppDelegate.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/13.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

/**
 *  开始只进行了根视图的设置  根视图是 HomeTabBarController 标签导航控制器
 *  位置在文件夹(MainHome中) 子视图在其类中设置
 *
 *
 */

#import "AppDelegate.h"
#import "HomeTabBarController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 电池栏不隐藏  启动时候勾选了隐藏 这里还原一下
    application.statusBarHidden = NO;
    
// 创建Window
  
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];

// 设置 Window 为主窗口
    [self.window makeKeyAndVisible];
    
// 创建根视图
    self.window.rootViewController = [[HomeTabBarController alloc] init];
    

    return YES;
}

// 支持横竖屏幕
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_allowRotate == 1) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }

}
// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate
{
    if (_allowRotate == 1) {
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    }

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
}

@end
