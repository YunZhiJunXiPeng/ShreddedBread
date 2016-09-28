//
//  JJLineView.m
//  ShreddedBread
//
//  Created by BoonZ on 16/8/15.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "JJLineView.h"
#import "PublicHeader.pch"

#import "PPFMDBdataHandle.h"

#import "MoodMessageCell.h"
#import "GetHeightTool.h"

@interface JJLineView ()<PNChartDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIButton *barButton;
@property (strong, nonatomic) UIButton *lineButton;


@property (strong, nonatomic) PPFMDBdataHandle *dataHandle;
@property (strong, nonatomic) NSArray *data01Array;

@property (strong, nonatomic) UITableView *detailTableView;
@property (strong, nonatomic) NSArray *messageArray;

@end

@implementation JJLineView


- (void)setView{
    
    [self.barChart removeFromSuperview];
    [self.lineButton removeFromSuperview];
    [self.barButton removeFromSuperview];
    
    if (self.lineChart)
    {
        [self.lineChart removeFromSuperview];
    }
    //初始化折线视图
    self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, jjScreenWidth - 25, jjcreenHeight / 2 - 100)];
    self.lineChart.yLabelFormat = @"%1.1f"; // 格式化Y坐标
    self.lineChart.backgroundColor = [UIColor clearColor];
    
    // 设置X坐标的刻度
    [self.lineChart setXLabels:@[@"周六",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五"]];
    
    // 设置Y坐标刻度
    [self.lineChart setYLabels:@[@"未统计", @"不开心", @"一般", @"很开心"]];
    
    //设置Y轴最大值最小值
    self.lineChart.yFixedValueMax = 3.0; // y轴最大值
    self.lineChart.yFixedValueMin = 0.0; // y轴最小值
    
    //是否显示纵横坐标轴的线条
    self.lineChart.showCoordinateAxis = YES; // 是否显示坐标轴
    self.lineChart.xLabelFont = [UIFont systemFontOfSize:17];
    
    self.lineChart.delegate = self;
    
    
#pragma mark ------------ 数据库查询语句 ---------------
    //给定曲线每个点的初始值
    
    self.dataHandle = [PPFMDBdataHandle sharePPFMDBdataHandle];
    
    self.data01Array = [self.dataHandle allWeekMoodIncluEmpty];  // 统计图的数据
    self.messageArray = [self.dataHandle firstDayOneWeekToCurrentDay:[NSDate date]]; //table的数据
    
    
    NSLog(@"************ mood = %@, content = %@", self.data01Array, self.messageArray);
    
    //PNLineChartData是处理曲线内容的类
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Alpha";
    data01.color = [UIColor redColor];
    data01.alpha = 1.0f;
    data01.itemCount = self.data01Array.count;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle; //转折点样式
    
    data01.getData = ^(NSUInteger index) {
    
        
        CGFloat yValue = [self.data01Array[index] floatValue];
        
        return [PNLineChartDataItem dataItemWithY:yValue];
        
    };
    
    
    
    //曲线视图处理数组, 用于LineChart类处理数据
    self.lineChart.chartData = @[data01];
    //渲染上下文
    [self.lineChart strokeChart];

    [self addSubview:self.lineChart];
    

    //设置button按钮
    self.lineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lineButton setImage:[UIImage imageNamed:@"B"] forState:UIControlStateNormal];
    self.lineButton.frame = CGRectMake(self.frame.size.width - 25, CGRectGetMinY(self.lineChart.frame) + 30, 20, 20);
    [self addSubview:self.lineButton];
    
    
    self.barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.barButton setImage:[UIImage imageNamed:@"AA"] forState:UIControlStateNormal];
    self.barButton.frame = CGRectMake(CGRectGetMinX(self.lineButton.frame), CGRectGetMaxY(self.lineButton.frame)+ 30, 20, 20);
    [self.barButton addTarget:self action:@selector(changeViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.barButton];

    [self loadTableView];
    
    
}

- (void)changeViewAction{

    //给定曲线每个点的初始值
    self.data01Array = [self.dataHandle allWeekMoodIncluEmpty];
    NSLog(@"************ mood = %@", self.data01Array);

    [self.lineChart removeFromSuperview];
    [self.lineButton removeFromSuperview];
    [self.barButton removeFromSuperview];
    
    
    self.barChart = [[PNBarChart alloc] initWithFrame:self.lineChart.frame];
    self.barChart.backgroundColor = [UIColor clearColor];
    self.barChart.yMaxValue = 3;
    
    self.barChart.yChartLabelWidth = 20.0; // Y坐标label宽度
    self.barChart.chartMarginLeft = 30.0;
    self.barChart.chartMarginRight = 10.0;
    self.barChart.chartMarginTop = 5.0;
    self.barChart.chartMarginBottom = 10.0;
    
    [self.barChart setYLabels:@[@"很开心", @"一般", @"不开心", @"未统计"]];
    
    self.barChart.labelMarginTop = 5.0; // X坐标刻度的上边距
    self.barChart.showChartBorder = YES; // 坐标轴
    [self.barChart setXLabels:@[@"周六",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五"]];
    
    [self.barChart setYValues:self.data01Array];
    
    NSMutableArray *strokeArray = [NSMutableArray array];
    
    for (id num in self.barChart.yValues) {
        
        if ([num intValue] >= 3) {
            
            [strokeArray addObject:PNGreen];
            
        }else if([num intValue] >= 2) {
            
            [strokeArray addObject:PNYellow];
        }else{
            
            [strokeArray addObject:PNRed];
        }
        
    }
    
    [self.barChart setStrokeColors:strokeArray];

    
    self.barChart.isGradientShow = YES; // 立体效果
    self.barChart.isShowNumbers = NO; // 显示各条状图的数值
    
    [self.barChart strokeChart];
    
    self.barChart.delegate = self;
    
    [self addSubview:self.barChart];
    
    //设置button按钮
    self.lineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.lineButton setImage:[UIImage imageNamed:@"BB"] forState:UIControlStateNormal];
    self.lineButton.frame = CGRectMake(self.frame.size.width - 25, CGRectGetMinY(self.lineChart.frame) + 30, 20, 20);
    [self.lineButton addTarget:self action:@selector(setView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.lineButton];
    
    
    self.barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.barButton setImage:[UIImage imageNamed:@"A"] forState:UIControlStateNormal];
    self.barButton.frame = CGRectMake(CGRectGetMinX(self.lineButton.frame), CGRectGetMaxY(self.lineButton.frame)+ 30, 20, 20);
    [self addSubview:self.barButton];
    
    
    [self loadTableView];
    
    
    
}

/************************  加载TableView ******************************/
- (void)loadTableView{
    
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineChart.frame), jjScreenWidth,jjcreenHeight - _lineChart.y - _lineChart.jjHeight - 160) style:UITableViewStylePlain];
    
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    
    [self.detailTableView  registerClass:[MoodMessageCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:self.detailTableView];
    
    
    
}

//tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.messageArray.count;
}

//tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoodMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    dayModel *model = self.messageArray[indexPath.row];
    
    [cell setValueWithModel:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dayModel *model = self.messageArray[indexPath.row];
    CGFloat Height = [GetHeightTool getHeightForText:[NSString stringWithFormat:@"%@\n%@",model.dateDay,model.content]font:[UIFont systemFontOfSize:14] width:jjScreenWidth - 100];
    return Height + 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}
/************************ 统计图的代理方法 **********************/
- (void)userClickedOnBarAtIndex:(NSInteger)barIndex{
    
    NSLog(@"%ld", barIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    
    
    NSLog(@"aaa");
}


- (void)userClickedOnLineKeyPoint:(CGPoint)point
                        lineIndex:(NSInteger)lineIndex
                       pointIndex:(NSInteger)pointIndex{
    NSLog(@"bbbbb");
    
}

@end
