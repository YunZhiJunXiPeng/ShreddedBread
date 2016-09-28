//
//  PPCalendarVC.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/13.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/**
 *  日历主页    代云鹏
 *
 *  @param void
 *
 *  @return
 */

#import "PPCalendarVC.h"
#import <JTCalendar/JTCalendar.h>
#import "PPPickerView.h"
#import "PPFMDBdataHandle.h"
#import "dayModel.h"
#import "PPAlertSettingView.h"
#import "AppDelegate.h"

// 按周显示的时候  日历高度
#define WEEK_HEIGHT 70
// 用来表示 心情类型的枚举 空 悲伤 一般 高兴
typedef enum : NSUInteger {
    
    DayViewTagStytleNull = 0,
    DayViewTagStytleSad,
    DayViewTagStytleNormal,
    DayViewTagStytleHappy,
    
} DayViewTagStytle;


@interface PPCalendarVC ()<JTCalendarDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate> // xib 中指定了后面两个代理
{
    NSDate *_todayDate; // 记录当天日期
    NSDate *_minDate;   // 日历范围中的最小值
    NSDate *_maxDate;   // 日历范围中的最大值
    NSDate *_dateSelected;  // 点击选中值
}
// 最上面的月份 视图
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
// 日历内容视图
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
// 管理工具
@property (strong, nonatomic) JTCalendarManager *calendarManager;

// 自定义清扫手势 上下滑动日历会显示月份或者周模式
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeDown;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeUp;

// 约束相关的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendar_H_W_Ratio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomScrollViewLayout;

// 承载内容的 bottmScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *bottomScrollView;

// 自定义的输入视图
@property (weak, nonatomic) IBOutlet UITextView *inputViewForMood;
@property (weak, nonatomic) IBOutlet UITextField *chooseMoodTF;
@property (weak, nonatomic) IBOutlet UITextField *chooseTagTF;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UITextField *dateTitleTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

// 数据库
@property (strong, nonatomic) PPFMDBdataHandle *jjpp;
// 存储标记的字典
@property (strong, nonatomic) NSMutableDictionary *tagDic;
@end

@implementation PPCalendarVC


#pragma mark ------>> 基本设置 <<------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    // 支持横竖屏
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.allowRotate = 1;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    delegate.allowRotate = 0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inputViewForMood.layer.borderColor = [UIColor grayColor].CGColor;
    self.inputViewForMood.layer.borderWidth = 0;
    self.inputViewForMood.layer.masksToBounds  = YES;
    self.inputViewForMood.layer.cornerRadius = 10;
    // 数据库错误信息回调
    self.jjpp = [PPFMDBdataHandle sharePPFMDBdataHandle];
    _jjpp.oneErrorBlock = ^(NSString *errorMessage, NSString *function)
    {
        NSLog(@"错误信息回调--->%@---->%@",errorMessage,function);
        
    };
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置代理  管理日历
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    // 设置日历范围
    [self creatMinMaxDate];
    // 设置视图
    [_calendarManager setMenuView:_calendarMenuView];// 顶部菜单 月份
    [_calendarManager setContentView:_calendarContentView]; // 日历
    //self.calendarContentView.backgroundColor = [UIColor redColor];
    // 默认来的日期
    [_calendarManager setDate:_todayDate];
    [self setDateTitleTFtextFromDate:_todayDate];
    // 用手势控制日历的显示格式  周 还是 月
    [self addGesturesForChangeModel];
    // 键盘相关的操作
    [self kbCreatAction];
    
}

//******************************************************************

#pragma mark ------>> 设置日历范围的方法 <<------
- (void)creatMinMaxDate
{
    _todayDate = [NSDate date];// 当前日期
    
    // 显示的最小日子 当前日期的前两个月
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    // 显示的最大日子  当前日子后两个月
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
    
    self.tagDic = [NSMutableDictionary new];
    NSArray *array = [_jjpp serchAllDataFromSmallDate:_minDate bigDate:_maxDate];
    for (dayModel *model in array)
    {
        if (model.tagDay != 4 )
        {
            //NSLog(@"需要标记的日期----->%@ (%ld)",model,model.tagDay);
            [_tagDic setObject:@(model.tagDay) forKey:[NSString getDateStringFromDate:model.dateDay]];
        }
    }
}
#pragma mark ------>> 自定义日期的显示格式 <<------
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

//******************************************************************

#pragma mark ------>> 给日历视图添加清扫手势 上滑按周显示 下滑按月份显示 <<------
- (void)addGesturesForChangeModel
{
    _swipeDown =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.calendarContentView addGestureRecognizer:_swipeDown];
    
    _swipeUp =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.calendarContentView addGestureRecognizer:_swipeUp];
    
}
- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    //NSLog(@"------>%ld",swipe.direction);
    // 上滑 按周显示
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        _calendarManager.settings.weekModeEnabled = YES;
        // 算滑上去后的  日历高度
        self.calendar_H_W_Ratio.constant = _calendarContentView.jjWidth - WEEK_HEIGHT * _calendar_H_W_Ratio.multiplier ;
        
    }else
    {
        // 下滑按照 月显示
        _calendarManager.settings.weekModeEnabled = NO;
        self.calendar_H_W_Ratio.constant = 0;
        // 收起键盘
        [self dismissKeyBoard];
    }
    // 重新加载日历
    [_calendarManager reload];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.view layoutIfNeeded];
    }];
}

//******************************************************************

#pragma mark ------>> 日历显示 管理的代理方法 <<------
// 在这里设置每一个 dayView(就是每一天的视图)
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.dotView.hidden = YES;
    // 今天
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:0.6414 green:1.0 blue:0.6729 alpha:1.0];
        // dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        
    }
    // 选中的天
    else if(_dateSelected && [_calendarManager.dateHelper date:[NSDate dateWithTimeInterval:- DAY_S sinceDate:_dateSelected] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:1.0 green:0.715 blue:0.8038 alpha:1.0];
        // dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        
    }
    // 其他月  数字的颜色调成暗色
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        //dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // 选中的这个月的  其他天数
    else{
        dayView.circleView.hidden = YES;
        // dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    NSString *key = [NSString getDateStringFromDate:[NSDate dateWithTimeInterval:DAY_S sinceDate:dayView.date]];
    
    if ([[_tagDic allKeys] containsObject:key])
    {
       // NSLog(@"-------------->%@",dayView.date);
        
        dayView.dotView.hidden = NO;
        
        dayView.dotView.backgroundColor = [self whatColorForDayViewDate:[NSDate dateWithTimeInterval:DAY_S sinceDate:dayView.date] tagItegerStyle:[_tagDic[key] integerValue]];
        
    }
    
    
}
//******************************************************************
#pragma mark ------>> 返回心情 这个方法可以去数据库查出每一天的  心情状态返回给日历的构建方法中 <<------
// 先写一个零时方法 判断需要是否做标记
- (DayViewTagStytle)isNeedTagStyle:(NSDate *)date
{
    dayModel *model = [[_jjpp serchAllInformationForOneDateDay:[NSDate dateWithTimeInterval:DAY_S sinceDate:date]] firstObject];
   // NSLog(@"-----%@-----******------>%ld",date,model.moodDay);
    return model.moodDay;
}

- (UIColor *)whatColorForDayViewDate:(NSDate *)date
                      tagItegerStyle:(NSInteger)tagStyle
{
    switch (tagStyle)
    {
        case 0:
            return [UIColor redColor];
            break;
        case 1:
            return [UIColor greenColor];
            break;
        case 2:
            return [UIColor blueColor];
            break;
        case 3:
            return [UIColor yellowColor];
            break;
        default:
            return [UIColor clearColor];
            break;
    }
    
}


//******************************************************************

#pragma mark ------>> 选中日期的操作 <<------
- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = [NSDate dateWithTimeInterval:DAY_S sinceDate:dayView.date];
   // NSLog(@"选中的是  %@",[NSDate getWeekdayWithDate:_dateSelected]);
    [_calendarManager setDate:_dateSelected];
// 数据有数据就展示出来  没有就展示空的
    [self setDateTitleTFtextFromDate:_calendarManager.date];
    // 动画展示圆圈的效果
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    // 要是显示模式是  按周显示 就不用管了
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // 要是点击 的是前一个月 或者 后一个月的 某天 就跳到那个月
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

//******************************************************************

#pragma mark ------>> 日历管理 监听显示和翻页 <<------

// 是否可以显示界面的信息
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    //NSLog(@"这里是日期在最大值和最小值之间可以显示 这里一共加载几个月走几次");
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}
// 翻到下一页  会走的方法
- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //NSLog(@"翻到下一页了  预留下来是我们可以最后添加动画");
    
}
// 翻到上一页  会走的方法
- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //NSLog(@"翻到上一页了  预留下来是我们可以最后添加动画");
}

//*******************************************************************

#pragma mark ------>> 和键盘相关的操作我们都放到这里在ViewDidload里面调用 <<------
- (void)kbCreatAction
{
    // 监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbHideShow:) name:UIKeyboardWillHideNotification object:nil];
#pragma mark ------>> 自定义键盘回收 按钮 <<------
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
    
    [topView setBarStyle:UIBarStyleBlackOpaque];
    
    UIBarButtonItem * backButton = [UIBarButtonItem itemWithTarget:self action:@selector(dismissKeyBoard) image:@"button_back_gray" hightImage:@"button_back_red"];
    // 留出两个按钮的空间
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    // 保存或者修改按钮
    UIBarButtonItem *saveButton = [UIBarButtonItem itemWithTarget:self action:@selector(saveActionToSQL:) image:@"button_save_gray" hightImage:@"button_save_red"];
    UIBarButtonItem * clearButton = [UIBarButtonItem itemWithTarget:self action:@selector(clearInput) image:@"button_clear_gray" hightImage:@"button_clear_red"];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:backButton,btnSpace,saveButton,btnSpace,clearButton,nil];
    
    [topView setItems:buttonsArray];
    // 日记键盘
    [self.inputViewForMood setInputAccessoryView:topView];
    // 设置输入键盘的
    [self creatPPPickerViewForTextFile];
    
    [self.chooseMoodTF setInputAccessoryView:topView];
    [self.chooseTagTF setInputAccessoryView:topView];
}

#pragma mark ------>> 设置 心情和标记 的输入框 <<------
- (void)creatPPPickerViewForTextFile
{
    PPPickerView *kbChooseMood = [[PPPickerView alloc] initWithFrame:CGRectZero array:[@[MOOD_Happy, MOOD_Normal, MOOD_Sad, MOOD_Null]mutableCopy]];
    PPPickerView *kbChooseTag = [[PPPickerView alloc] initWithFrame:CGRectZero array:[@[TAG_Important, TAG_Star, TAG_Heihei,TAG_Dayima]mutableCopy]];
    
    self.chooseMoodTF.inputView =kbChooseMood;
    self.chooseTagTF.inputView = kbChooseTag;
    
    WEAK_SELF(weakSelf);
    // 让键盘的内容显示到  输入框
    kbChooseMood.sendValueBlock = ^(NSString *sendValue)
    {
        weakSelf.chooseMoodTF.text = sendValue;
        
    };
    kbChooseTag.sendValueBlock = ^(NSString *sendValue)
    {
        weakSelf.chooseTagTF.text = sendValue;
        
    };
    
    
    
}

// 清除输入
- (void)clearInput
{
    if (_chooseTagTF.editing)
    {
        _chooseTagTF.text = @"";
    }else if(_chooseMoodTF.editing)
    {
        self.chooseMoodTF.text = @"";
    }else
    {
        self.inputViewForMood.text = @"";
        self.placeholderLabel.text = self.inputViewForMood.text;
    }
}

// 收回键盘
- (void)dismissKeyBoard
{
    if (_chooseTagTF.editing)
    {
        [self.chooseTagTF resignFirstResponder];
        
    }else if(_chooseMoodTF.editing)
    {
        [self.chooseMoodTF resignFirstResponder];
        
    }else
    {
        [self.inputViewForMood resignFirstResponder];
    }
}
#pragma mark ------>> 监听键盘 <<------
- (void)kbWillShow:(NSNotification *)noti
{
    //NSLog(@"键盘将要出来");
    [self swipe:_swipeUp];
    CGRect kbFram = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbFram.size.height;
    // 键盘弹起  底部距离调整 增高键盘高度
    self.bottomScrollViewLayout.constant = kbHeight ;
    //  日记键盘弹出来的 时候 判断如果需要的话 滑到最下面
    if(!_chooseTagTF.editing && !_chooseMoodTF.editing)
    {
        // Y 的偏移量
        CGFloat offSet = _bottomScrollView.contentSize.height - _bottomScrollView.jjHeight;
        if (offSet > 0)
        {
            [UIView animateWithDuration:0.01 animations:^{
                
                [_bottomScrollView setContentOffset:CGPointMake(0, offSet)];
            }];
            
        }
    }
    
    
}
- (void)kbHideShow:(NSNotification *)noti
{
   // NSLog(@"键盘将要消失");
    // 下滑日历
    [self swipe:_swipeDown];
    self.bottomScrollViewLayout.constant = 25;
    [UIView animateWithDuration:0.2 animations:^{
        
        [_bottomScrollView setContentOffset:CGPointMake(0, 0)];
    }];
    
    
}

//******************************************************************

#pragma mark ------>> 监听输入 inputTextView 的动态 输入的 text 赋值给 lable 就是为了自适应<<------
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.text = textView.text;
    
    if(!_chooseTagTF.editing && !_chooseMoodTF.editing)
    {
        //  判断是否需要滑动到最小面
        CGFloat offSet = _bottomScrollView.contentSize.height - _bottomScrollView.jjHeight;
        if (offSet > 0)
        {
            [UIView animateWithDuration:0.02 animations:^{
                
                [_bottomScrollView setContentOffset:CGPointMake(0, offSet)];
            }];
            
        }
    }
    
    
}

//******************************************************************

#pragma mark ------>> 设置每天详情 <<------
- (void)setDateTitleTFtextFromDate:(NSDate *)date
{

    self.dateTitleTF.text = [NSString getDateStringFromDate:date];
    self.titleLable.text = self.dateTitleTF.text;
    NSArray *array = [_jjpp serchAllInformationForOneDateDay:date];
    // 数据库有的话  执行
    if (array.count > 0)
    {
        dayModel *model = (dayModel *)array.firstObject;
        
        self.chooseMoodTF.text = [NSString getMoodStringMood:model.moodDay];
        self.chooseTagTF.text = [NSString getTagStringTag:model.tagDay];
        self.inputViewForMood.text = model.content;
        self.placeholderLabel.text = self.inputViewForMood.text;
        
    } else
    {
        self.chooseMoodTF.text = @"";
        self.chooseTagTF.text = @"";
        self.inputViewForMood.text = @"";
        self.placeholderLabel.text = self.inputViewForMood.text;
    }
    
}

//******************************************************************


#pragma mark ------>> 数据库处理  插入数据 保存 <<------
- (IBAction)saveActionToSQL:(UIButton *)sender
{
    if ([_inputViewForMood.text isEqualToString:@""] && [_chooseTagTF.text isEqualToString:@""] &&[_chooseMoodTF.text isEqualToString:@""])
    {
        [self showAlertViewControllerWithStr:@"还没有输入内容啊!" time:1.0];
    }else
    {
        if (!_dateSelected) {
            _dateSelected = _todayDate;
        }
        
        NSArray *array = [_jjpp serchAllInformationForOneDateDay:_dateSelected];
        dayModel *model = [dayModel dayModelWithDate:_dateSelected moodDay:[NSString getMoodIntegerByString:_chooseMoodTF.text] tagDay:[NSString getTagIntegerByString:_chooseTagTF.text] content:_inputViewForMood.text];
        // 数据库中有 走修改方法
        if (array.count >0 )
        {
            [_jjpp upDataOnTheDate:model];
            [self showAlertViewControllerWithStr:@"修改成功!" time:0.3];
        } else
        {
            // 数据库中无 走插入方法
            [_jjpp insertOneObjectModelDay:model];
            [self showAlertViewControllerWithStr:@"存入成功!" time:0.3];
        }
        [_tagDic setObject:@([NSString getTagIntegerByString:_chooseTagTF.text]) forKey:[NSString getDateStringFromDate:_dateSelected]];
        // NSLog(@"----有值得地方-->%@",_tagDic);
        [_calendarManager reload];
    }
    if (_chooseTagTF.editing)
    {
        [self.chooseTagTF endEditing:YES];
        
    }else if(_chooseMoodTF.editing)
    {
        [self.chooseMoodTF endEditing:YES];
        
    }else
    {
        [self.inputViewForMood endEditing:YES];
    }
    
}

//******************************************************************

#pragma mark ------>>回到今天 <<------
- (IBAction)goBackToday:(UIButton *)sender
{
    //    NSLog(@"------回今天----");
    //    [_calendarManager setDate:_todayDate];
    //    _dateSelected = [NSDate dateWithTimeInterval:DAY_S sinceDate:_todayDate];
    //    [_calendarManager reload];
    //    [self setDateTitleTFtextFromDate:_calendarManager.date];
    
    // 点击 Button 弹出 或者回收  设置界面
    PPAlertSettingView *setting = [[PPAlertSettingView alloc] initWithFrame:CGRectMake(0, 0, jjScreenWidth, jjcreenHeight - 60)];
    
    WEAK_SELF(weakSelf);
    setting.getDate = ^(NSDate *date)
    {
        [weakSelf.calendarManager setDate:date];
        _dateSelected = [NSDate dateWithTimeInterval:DAY_S sinceDate:date];
        [weakSelf.calendarManager reload];
        [self setDateTitleTFtextFromDate:weakSelf.calendarManager.date];
    };
    //NSLog(@"-------->添加设置视图");
    [UIView animateWithDuration:0.01 animations:^{
        [self.view addSubview:setting];
    }];
    
}



















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
