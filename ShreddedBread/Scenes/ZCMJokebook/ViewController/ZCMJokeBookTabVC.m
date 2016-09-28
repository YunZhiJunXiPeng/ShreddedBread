//
//  ZCMJokeBookTabVC.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/13.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/**
 *  视频笑话主页  张传明
 *
 *  @param void
 *
 *  @return
 */

#import "ZCMJokeBookTabVC.h"
#import "JokeBookCellTableViewCell.h"
#import "Url_marco.h"
#import "WSLVideoModel.h"
#import "GetHeightTool.h"
#import <MJRefresh.h>
#import "ComplaintView.h"
@interface ZCMJokeBookTabVC ()

@property (strong, nonatomic) NSMutableArray *dataArry;
@property (assign, nonatomic) NSInteger currenPage;
@property (assign, nonatomic) NSInteger maxPage;
@end

@implementation ZCMJokeBookTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complaintAction) image:@"button_complaint_gray" hightImage:@"button_complaint_red"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(goBackTopAction) image:@"button_top_gray" hightImage:@"button_top_red"];
    
    // 注册 Xib
    [self.tableView  registerNib:[UINib nibWithNibName:@"JokeBookCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"JokeBookCellTableViewCell"];

    // 添加刷新控件
    [self setUpRefresh];
    
    [self.tableView.mj_header beginRefreshing];
    // 解析数据
    [self getDataFromUrl];
    
   
}
// 投诉
- (void)complaintAction
{
    ComplaintView *setting = [[[NSBundle mainBundle] loadNibNamed:@"ComplaintView" owner:self options:nil] firstObject];
    setting.frame = self.view.bounds;
    
    WEAK_SELF(weakSelf);
    setting.sendBlock = ^()
    {
    
        [weakSelf showAlertViewControllerWithStr:@"谢谢您的反馈！我们将马不停蹄为您处理！" time:1.5];
    };
    //NSLog(@"-------->添加设置视图");
    [UIView animateWithDuration:0.01 animations:^{
        [self.view addSubview:setting];
    }];
    
}

// 回到顶部
- (void)goBackTopAction
{
    if (self.dataArry.count > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    }
}

// 刷新设置
- (void)setUpRefresh
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextPagedata)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(upDataAction)];
    
}

#pragma mark ------>> 加载下页数据  刷新数据 <<------
- (void)loadNextPagedata
{
    if (_currenPage < _maxPage)
    {
        [self getDataFromUrl];
    }else
    {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (void)upDataAction
{
    _currenPage = 0;
    [self getDataFromUrl];
}


- (NSMutableArray *)dataArry
{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}
// 解析数据
- (void)getDataFromUrl
{
    [JJNetWorkRequst requestWithUrl:ZCM_JOKEBOOK_URL_BAOZOU(++_currenPage) parameters:nil successResponse:^(NSDictionary *dic)
    {
        _maxPage = [dic[@"total"] integerValue];
        if (_currenPage == 1)
        {
            [self.dataArry  removeAllObjects];
        }
        for (NSDictionary *dicc in dic[@"items"])
        {
            WSLVideoModel *model = [WSLVideoModel new];
            [model setValuesForKeysWithDictionary:dicc];
            [self.dataArry addObject:model];
        }
       // PPLog(@"-dataArray----->%@",self.dataArry);
       
        [self.tableView reloadData];
        if (self.tableView.mj_header.isRefreshing)
        {
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.isRefreshing)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    } failureResponse:^(NSError *error)
    {
        if (self.tableView.mj_header.isRefreshing)
        {
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.isRefreshing)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        [self showAlertViewControllerWithStr:@"数据加载失败" time:0.5];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    self.tableView.mj_footer.hidden = (self.dataArry.count == 0);
    
    return self.dataArry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JokeBookCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JokeBookCellTableViewCell" forIndexPath:indexPath];
    [cell bindContentModel:self.dataArry[indexPath.row]];
    
    return cell;
}

// 返回 Cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WSLVideoModel *model = self.dataArry[indexPath.row];
    return [GetHeightTool getHeightForText:model.content font:[UIFont systemFontOfSize:14] width:jjScreenWidth - 40] + 110;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSNumber *Joke = [[NSUserDefaults standardUserDefaults] objectForKey:@"Joke"];
    
    if (![Joke isEqual:@1])
    {
        [self showAlertViewControllerWithTitle:@"敬告！" message:@"最新段子中可能出让您不愉快的描述！点击确认继续观看并不在提醒！观看过程中如需投诉建议请点击左上角投诉按钮！" preferredStyle:(UIAlertControllerStyleAlert) alertActionName:@"确定" alertActionOne:^{
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"Joke"];
        } alertBackAfter:^{
            
        }];
    }
    
    
    
    
}

@end
