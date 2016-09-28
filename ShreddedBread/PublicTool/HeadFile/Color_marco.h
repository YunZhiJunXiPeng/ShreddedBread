
// 设置颜色的宏定义文件

#ifndef Color_marco_h
#define Color_marco_h
// 设置颜色
// r g b  的取值 1 ~ 255  a取值  0 ~ 1
#define  JJ_COLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机颜色
#define  JJ_RANDOM_COLOR JJ_COLOR(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255),1.0)

// 主题颜色  0 0 0 表示黑色 (TabBar 选中颜色  NavigationBar 未选中的颜色)
#define JJ_THEME_COLOR JJ_COLOR(255, 0, 0,1.0)

// tabBar 未选中时候的颜色
#define JJ_TABBAR_COLOR JJ_COLOR(0.5*255,0.5*255,0.5*255,1)

// 键盘颜色
#define KB_COLOR ([UIColor colorWithRed:0.7663 green:1.0 blue:0.9747 alpha:1.0]);

#define BACKGROUND_COLOR JJ_COLOR(207,223,229,1)
#endif /* Color_marco_h */
