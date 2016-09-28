//
//  JJPieViewController.m
//  ShreddedBread
//
//  Created by BoonZ on 16/8/16.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "JJPieViewController.h"
#import <PNChart.h>
#import "JSDropDownMenu.h"

#import "PPFMDBdataHandle.h"

@interface JJPieViewController ()<JSDropDownMenuDataSource, JSDropDownMenuDelegate>

@property (weak, nonatomic) IBOutlet UIView *showView; //圆饼图背景

@property (weak, nonatomic) IBOutlet PNPieChart *pieChart;  // 圆饼图

@property (strong, nonatomic) JSDropDownMenu *menu;  // 时间选择器

@property (weak, nonatomic) IBOutlet UIView *selectBackView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) UILabel *yearLabel;

//月份
@property (assign, nonatomic) NSInteger arrIndex;
@property (strong, nonatomic) NSMutableArray *monthArray;

//年份
@property (assign, nonatomic) NSUInteger currentYearIndex;
@property (strong, nonatomic) NSArray *yearArray;

@property (strong, nonatomic) PPFMDBdataHandle *dateHandle;
@property (strong, nonatomic) NSDictionary *moodDic;

@end

@implementation JJPieViewController

- (NSMutableArray *)monthArray{
    
    if (_monthArray == nil) {
        
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self loadData];
    [self loadPieView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"心情大饼图";

}


/***************************  数据库加载数据  ************************/
- (void)loadData{
    
    //数据库单例
    self.dateHandle = [PPFMDBdataHandle sharePPFMDBdataHandle];
    
    /*****************************  选择器数据 + 视图 ****************************/
    //数据: 月份数组
    self.monthArray = [@[@"一月", @"二月", @"三月", @"四月", @"五月",@"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月", @"本年"] mutableCopy];
    self.arrIndex = 0;
    
    //数据: 年份数组(获取当前数据库中有记录的年份)
    self.yearArray = [NSArray array];
    self.yearArray = [self.dateHandle getYearsKindFromSQL];
    
    NSLog(@"allyear = %@", self.yearArray);
    
    //定位到当前年份的下标
    NSString *currentYear = [NSString getYearStringFromDate:[NSDate date]];
    if (self.yearArray.count >= 1) {
        
        self.currentYearIndex = self.yearArray.count - 1;
        
        for (int i = 0; i < self.yearArray.count - 1; i++) {
            
            if ([self.yearArray[i] isEqualToString:currentYear]) {  // 比较数组中的年份, 与当前年份字符串进行比较
                
                self.currentYearIndex = i;
            }
        }
        
    }else{
        
        [self showAlertViewControllerWithTitle:@"提示" message:@"当前还没有记录, 开始记录您的心情吧!" preferredStyle:(UIAlertControllerStyleAlert) alertActionName:@"确定"];
    }
    
    
    NSLog(@"currentYear = %@", currentYear);
    
    //定位到当前月份的下标
    NSString *currentMonth = [NSString getMonthStringFromDate:[NSDate date]];
    for (int i = 0; i < self.monthArray.count - 1; i++) {
        
        if ([self.monthArray[i] isEqualToString:currentMonth]) {
            
            self.arrIndex = i;
        }
    }
    
    NSLog(@"currentMonth = %@, arrIndex = %ld", currentMonth, (long)self.arrIndex);
    
    
    //视图
    CGFloat myWidth = jjScreenWidth - self.backButton.frame.size.width * 2 - 20;
    self.menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(self.selectBackView.x , self.nextButton.y) andHeight:CGRectGetHeight(self.backButton.frame) andWidth:myWidth];
    self.menu.indicatorColor = [UIColor redColor];
    self.menu.textColor = [UIColor blackColor];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    
    [self.view addSubview:self.menu];  //必须添加到view上
    
    
    
    //年份显示
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1.3, self.menu.frame.size.width / 2 -20, 44)];
    self.yearLabel.backgroundColor = [UIColor clearColor];
    self.yearLabel.font = [UIFont systemFontOfSize:15];
    self.yearLabel.textAlignment = NSTextAlignmentRight;
    
    if (self.yearArray.count >= 1) {
        
        self.yearLabel.text = self.yearArray[self.currentYearIndex];
        
    }else{
        
        self.yearLabel.text = @"1997";
    }
    
    [self.menu addSubview:self.yearLabel];
    
    
    
    //圆饼图实现
    [self loadPieView];
    
    //menu自动定位到当前的月份
    [self.menu selectIndex:self.arrIndex];
    
}


/****************************  圆饼图实现  **************************/
-(void)loadPieView{
    
// 查询数据库指定年份 + 月份的数据
    NSString *indexStr = [NSString stringWithFormat:@"%ld", self.arrIndex + 1];
    
    //NSLog(@"**************%@***%@",self.yearArray[self.currentYearIndex],indexStr);
    
    if (self.yearArray.count >= 1) {
        
        if (self.arrIndex == 12) {
            NSLog(@"-------------->%@",self.yearArray[self.currentYearIndex]);
            self.moodDic = [self.dateHandle moodDicmoodSerchallDataForOneYear:self.yearArray[self.currentYearIndex]];
            
        }else{
            
            self.moodDic = [self.dateHandle moodDicmoodSerchallDataForYear:self.yearArray[self.currentYearIndex] moth:indexStr];
        }

    }
    
    NSLog(@"dic = %@", self.moodDic);
    
    // 统计不同心情的数量(默认为: 未统计)
    float unhappy = [[self.moodDic objectForKey:@"1"] floatValue];
    float normal = [[self.moodDic objectForKey:@"2"] floatValue];
    float happy = [[self.moodDic objectForKey:@"3"] floatValue];

    NSInteger allDays = 30;
    
    if (self.arrIndex == 12){
        
        allDays = 365;
       
    }
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:unhappy color:[UIColor colorWithRed:1.000 green:0.424 blue:0.472 alpha:1.000] description:@"不开心"],
                       [PNPieChartDataItem dataItemWithValue:happy color:[UIColor colorWithRed:0.816 green:1.000 blue:0.675 alpha:1.000] description:@"高兴"],
                       [PNPieChartDataItem dataItemWithValue:normal color:[UIColor colorWithRed:0.984 green:1.000 blue:0.615 alpha:1.000] description:@"一般"],
                       [PNPieChartDataItem dataItemWithValue:(allDays - unhappy - happy - normal) color:[UIColor colorWithRed:0.630 green:0.777 blue:0.819 alpha:1.000] description:@"未统计"]
                       ];
    
    
// 初始化
    self.pieChart.items = items;
    self.pieChart.backgroundColor = [UIColor clearColor];
    
    
//数据百分比, 分布描述信息
    self.pieChart.descriptionTextColor = [UIColor colorWithRed:0.531 green:0.019 blue:0.088 alpha:1.000];
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
    self.pieChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
    self.pieChart.showOnlyValues = NO; // 只显示数值不显示内容描述
    
    self.pieChart.innerCircleRadius = 0;
    self.pieChart.outerCircleRadius = 0;
    
    [self.pieChart strokeChart];
    
    
//注释排列(横向 / 纵向)
    self.pieChart.legendStyle = PNLegendItemStyleStacked; // 标注排放样式
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(20, 20, legend.frame.size.width, legend.frame.size.height)];
    [self.showView addSubview:legend];
    
    [self.showView addSubview:self.pieChart];
    
}

- (void)aa
{
    
}
/**********************  改变年份的button事件  **************************/
- (IBAction)backAction:(UIButton *)sender {

    if (self.yearArray.count >= 1) {
        
        if (self.currentYearIndex == 0) {
            
            [self showAlertViewControllerWithTitle:@"提示" message:@"当前年份为记录最早日期!" preferredStyle:(UIAlertControllerStyleAlert) alertActionName:@"确定"];
            
        }else{
            
            self.currentYearIndex --;
            
            [self loadPieView];  //重写加载数据 + 图
            
        }
        
        //改变yearLabel显示内容
    self.yearLabel.text = self.yearArray[self.currentYearIndex];
        
    }else{
        
        [self showAlertViewControllerWithTitle:@"提示" message:@"❤! , 主人还没开始记录心情喔~ 现在开始记录吧 !" preferredStyle:(UIAlertControllerStyleAlert) alertActionName:@"确定"];
        
    }
    
}

- (IBAction)nextAction:(UIButton *)sender {
    
    if (self.yearArray.count >= 1) {
        
        if (self.currentYearIndex == self.yearArray.count - 1) {
            
            [self showAlertViewControllerWithTitle:@"提示" message:@"指定年份无记录, 请确定正确年份!" preferredStyle:(UIAlertControllerStyleAlert) alertActionName:@"确定"];
            
        }else{
            
            self.currentYearIndex ++;
            [self loadPieView];  //重写加载数据 + 图
            
        }

        
        //改变yearLabel显示内容
        self.yearLabel.text = self.yearArray[self.currentYearIndex];
        

    }else{
        
        
        [self showAlertViewControllerWithTitle:@"提示" message:@"❤! , 主人还没开始记录心情喔~ 现在开始记录吧 !" preferredStyle:(UIAlertControllerStyleAlert) alertActionName:@"确定"];
        
        
    }
    
    
    
    
}


/********************** 选择器 代理方法  **************************/
#pragma  mark --------- 返回列数 + 行数 -------------
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu{
    
    return  1;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
  
        
    return self.monthArray.count;
 
}

#pragma mark  ------------ 加载数据
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{

    NSString *str = self.monthArray[0];
    
    return str;
}

#pragma mark  ------------ 返回某一列中 , 每一个行的内容
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath{
    
    return self.monthArray[indexPath.row];
        
}

#pragma mark ------------- 点击方法
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath{
    
    self.arrIndex = indexPath.row;
    


    [self loadPieView];  //重写加载数据 + 图
    
    
}


#pragma mark  ------------- 判断是否有二级菜单
- (BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
        
    return 0;

}


@end
