//
//  PPAlertSettingView.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/19.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "PPAlertSettingView.h"

#define SETTING_W 100
#define SETTING_H 130
#define SETTING_X  (self.jjWidth - SETTING_W + CENTER_ALIGNMENT + RIGHT_OFFSET_X)

// 到右边距离
#define RIGHT_OFFSET_X (-10)
// 到顶部距离
#define TOP_OFFSET_Y 80

// 居中导致的偏移
#define CENTER_ALIGNMENT (- 15)

// 三角尖儿 的高度 尖儿的偏移
#define POINT_OFFSET_X (-10)
#define POINT_HEIGHT (-20)

// 填充颜色
#define SETTING_COLOR [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]
// 线的颜色
#define SETTING_WEIGH_COLOR [UIColor clearColor]
// Cell选中的颜色
#define CELL_COLOR [UIColor colorWithRed:0.8904 green:0.9397 blue:0.9309 alpha:1.0];

#define P_H 200
#define P_W (2 * self.jjWidth / 3)


@interface PPAlertSettingView ()<UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic) CGRect settingFrame ;
@property (strong, nonatomic) UIDatePicker *datePicer;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic)  UIToolbar *toolBar;
@property (strong, nonatomic) NSSet *touchSet;
@property (assign, nonatomic) BOOL needClearColor;
@end

@implementation PPAlertSettingView



#pragma mark ------>> 画一个设置框 <<------
- (void)drawRect:(CGRect)rect
{
    // 获取上下文
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    // 路径
    CGMutablePathRef path = CGPathCreateMutable();
    // 起点  画圆弧
    CGPathMoveToPoint(path, NULL, self.jjWidth - SETTING_W + CENTER_ALIGNMENT + RIGHT_OFFSET_X + 10, TOP_OFFSET_Y);
    CGPathAddArcToPoint(path, NULL,self.jjWidth + CENTER_ALIGNMENT + RIGHT_OFFSET_X, TOP_OFFSET_Y, self.jjWidth + CENTER_ALIGNMENT + RIGHT_OFFSET_X, SETTING_H + TOP_OFFSET_Y, 10);
    CGPathAddArcToPoint(path, NULL,self.jjWidth + CENTER_ALIGNMENT + RIGHT_OFFSET_X, SETTING_H + TOP_OFFSET_Y,self.jjWidth - SETTING_W + CENTER_ALIGNMENT + RIGHT_OFFSET_X,  SETTING_H + TOP_OFFSET_Y, 10);
    CGPathAddArcToPoint(path, NULL,self.jjWidth - SETTING_W + CENTER_ALIGNMENT + RIGHT_OFFSET_X,  SETTING_H + TOP_OFFSET_Y,self.jjWidth - SETTING_W + CENTER_ALIGNMENT + RIGHT_OFFSET_X, TOP_OFFSET_Y, 10);
    CGPathAddArcToPoint(path, NULL,self.jjWidth - SETTING_W + CENTER_ALIGNMENT + RIGHT_OFFSET_X, TOP_OFFSET_Y,self.jjWidth + CENTER_ALIGNMENT + RIGHT_OFFSET_X, TOP_OFFSET_Y, 10);
    
    // 用上下文管理
    CGContextAddPath(cxt, path);
    // 设置属性
    CGContextSetLineWidth(cxt, 1.0f);
    if (self.needClearColor)
    {
        [[UIColor clearColor] setFill];
    }else
    {
        [SETTING_COLOR setFill];
    }
    [SETTING_WEIGH_COLOR setStroke];
    // 渲染
    CGContextDrawPath(cxt, kCGPathFill);
    
    // 路径2  画三角
    CGMutablePathRef path2 = CGPathCreateMutable();
    // 起点 三角的左下角
    CGPathMoveToPoint(path2, NULL, self.jjWidth + POINT_OFFSET_X * 2 + CENTER_ALIGNMENT + RIGHT_OFFSET_X - 10, TOP_OFFSET_Y);
    // 尖儿
    CGPathAddLineToPoint(path2, NULL, self.jjWidth + POINT_OFFSET_X + CENTER_ALIGNMENT + RIGHT_OFFSET_X - 10, TOP_OFFSET_Y + POINT_HEIGHT);
    // 右下角
    CGPathAddLineToPoint(path2, NULL, self.jjWidth + CENTER_ALIGNMENT + RIGHT_OFFSET_X - 10, TOP_OFFSET_Y);
    // 用上下文管理
    CGContextAddPath(cxt, path2);
    // 渲染
    CGContextDrawPath(cxt, kCGPathFill);

    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self  setUI];
    }
    return self;
}

// 创建  日期选择器  TableView ToolBar
- (void)setUI
{
    // 日期选择器
    self.backgroundColor = [UIColor clearColor];
    UIDatePicker *datePicer = [[UIDatePicker alloc] init];
    datePicer.backgroundColor = SETTING_COLOR;
    datePicer.datePickerMode = UIDatePickerModeDate; // 日期格式
    datePicer.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];//地区
    datePicer.frame = CGRectZero;
    _datePicer = datePicer;
   [self addSubview:datePicer];
    // 监听的按钮
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    _toolBar.barStyle = UIBarStyleBlackTranslucent;// 按钮菜单的风格 半透明
   
    UIBarButtonItem *itmeGo = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStyleDone) target:self action:@selector(goOneDate)];
    UIBarButtonItem * itmeBack = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(goBackDate)];
    // 分开两个按钮
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    _toolBar.items = @[btnSpace,itmeGo, btnSpace, itmeBack,btnSpace];
    
    // tableView
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = SETTING_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];
}

#pragma mark ------>> 布局子控件 <<------
- (void)layoutSubviews
{
//    _datePicer.frame = CGRectMake(self.center.x - P_W / 2, jjcreenHeight / 4 - P_H / 2 + SETTING_H, P_W, P_H);
    _tableView.frame = CGRectMake(SETTING_X + 5 , TOP_OFFSET_Y + 15, SETTING_W - 10 , SETTING_H - 20 );
   
}

#pragma mark ------>> 触摸屏幕选择 回到原始状态 <<------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   // 触摸收起
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        //缩小到指定的位置
        self.center = CGPointMake(jjScreenWidth,0);
        
    }
                     completion:^(BOOL finished)
     {
         [self removeFromSuperview];
     }];

}

#pragma mark ------>> TableView 的代理方法 <<------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
// Cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return (SETTING_H - 30)/2 ;
}

#pragma mark ------>> Cell 上显示的内容 <<------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Set_Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Set_Cell"];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"回到今天";
            break;
        case 1:
            cell.textLabel.text = @"选择日期";
            break;
        default:
            break;
    }
    cell.backgroundColor = SETTING_COLOR;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView  = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = CELL_COLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

#pragma mark ------>> 选中 Cell 的方法  选中第二个的话  去掉设置界面 <<------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            self.getDate([NSDate date]);
            [self goBackDate];
            break;
        case 1:
        {// 弹出 选择日期的 视图
            _datePicer.frame = CGRectMake(self.center.x - P_W / 2, jjcreenHeight / 4 - P_H / 2 + SETTING_H, P_W, P_H);
            _toolBar.frame = CGRectMake(_datePicer.x, _datePicer.y + P_H, P_W, 40);
            _toolBar.backgroundColor = [UIColor colorWithRed:0.5876 green:0.7023 blue:1.0 alpha:1.0];
            [self addSubview:_toolBar];
            
            // [UIView animateWithDuration:0.01 animations:^{
            //缩小到指定的位置
            // self.tableView.center = CGPointMake(jjScreenWidth,0);
            _needClearColor = YES;
            [self setNeedsDisplay];
            //}
            //                completion:^(BOOL finished)
            //{
            [self.tableView removeFromSuperview];
            // }];
        }
            break;
        default:
            break;
    }


}
// 监听日期  点击确定调到指定日期
- (void)goOneDate
{
    self.getDate(_datePicer.date);
    [self goBackDate];

}
// 直接返回 不操作
- (void)goBackDate
{
    [self touchesBegan:[NSSet new] withEvent:nil];
}

@end
