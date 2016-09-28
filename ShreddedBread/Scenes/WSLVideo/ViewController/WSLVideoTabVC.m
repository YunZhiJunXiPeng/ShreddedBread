//
//  WSLVideoTabVC.m
//  ShreddedBread
//
//  Created by lanou3g on 16/8/15.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

/*
 视频url : http://qiubai-video.qiushibaike.com/WLJE4YIGEII00UVP.mp4
 */


#import "WSLVideoTabVC.h"
#import "WSLTableViewCell.h"
#import "Url_marco.h"
#import <UIImageView+WebCache.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MJRefresh.h>
#import "ComplaintView.h"
#import "WMPlayer.h"
#import "WSLVideoModel.h"

typedef enum : NSUInteger {
    NetWorkWIFI,
    NetWorkWWAN,
    NetWorkELSE,
} NetWorKingStytle;



@interface WSLVideoTabVC ()<WMPlayerDelegate>{
    
    NSIndexPath *_currentIndexPath;
    
}//遵循代理

@property (strong, nonatomic) WSLVideoModel *model;
@property (strong, nonatomic) NSMutableArray *modelArray;

@property (strong, nonatomic) WMPlayer *wmPlayer;
@property (assign, nonatomic) BOOL isSmallScreen;


@property (strong, nonatomic) WSLTableViewCell *currentCell;

//记录当前请求数据页码
@property (assign, nonatomic) NSInteger currentPageNumber;
//记录总的页码
@property (assign, nonatomic) NSInteger sumPageCount;

@property (assign, nonatomic) NetWorKingStytle netWorkType;


@end

@implementation WSLVideoTabVC

//懒加载model对象的数组
- (NSMutableArray *)modelArray{
    
    if (_modelArray == nil) {
        
        _modelArray = [NSMutableArray array];
    }
    
    return _modelArray;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.isSmallScreen = NO;
    }
    return self;
}

//隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    if (self.wmPlayer) {
        if (self.wmPlayer.isFullscreen) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
    
    NSNumber *Joke = [[NSUserDefaults standardUserDefaults] objectForKey:@"Video"];
    
    if (![Joke isEqual:@1])
    {
        [self showAlertViewControllerWithTitle:@"敬告！" message:@"播放视频过程可能出现另您不适画面！点击确认继续观看并不在提醒！观看过程中如需投诉建议请点击左上角投诉按钮！" preferredStyle:(UIAlertControllerStyleAlert) alertActionName:@"确定" alertActionOne:^{
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"Video"];
        } alertBackAfter:^{
           
        }];
    }
    
    
    
    
    
    
    
    
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

/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    
    if (self.wmPlayer==nil||self.wmPlayer.superview==nil){
        return;
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (self.wmPlayer.isFullscreen) {
            
                    [self toCell];
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            self.wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            self.wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:interfaceOrientation];
        }
            break;
        default:
            break;
    }
}


-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    
    
    [self.wmPlayer removeFromSuperview];
    self.wmPlayer.transform = CGAffineTransformIdentity;
    
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        
        self.wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        
        self.wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    
    self.wmPlayer.frame = CGRectMake(0, 0, jjScreenWidth, jjcreenHeight);
    self.wmPlayer.playerLayer.frame =  CGRectMake(0,0, jjScreenWidth,jjcreenHeight);
    
    [self.wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(jjScreenWidth-40);
        make.width.mas_equalTo(jjcreenHeight);
    }];
    
    [self.wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(jjcreenHeight);
        make.center.mas_equalTo(CGPointMake(jjScreenWidth/2-36, -(jjScreenWidth/2)));
        make.height.equalTo(@30);
    }];
    
    [self.wmPlayer.loadingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(jjScreenWidth/2-37, -(jjScreenWidth/2-37)));
    }];
    [self.wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(jjcreenHeight);
        make.center.mas_equalTo(CGPointMake(jjScreenWidth/2-36, -(jjScreenWidth/2)+36));
        make.height.equalTo(@30);
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self.wmPlayer];
    
    self.wmPlayer.fullScreenBtn.selected = YES;
    [self.wmPlayer bringSubviewToFront:self.wmPlayer.bottomView];
    
}

-(void)toSmallScreen{
    //放widow上
    [self.wmPlayer removeFromSuperview];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.wmPlayer.transform = CGAffineTransformIdentity;
        self.wmPlayer.frame = CGRectMake(jjScreenWidth/2,jjcreenHeight-jjcreenHeight-(jjScreenWidth/2)*0.75, jjScreenWidth/2, (jjScreenWidth/2)*0.75);
        self.wmPlayer.playerLayer.frame =  self.wmPlayer.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:self.wmPlayer];
        [self.wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wmPlayer).with.offset(0);
            make.right.equalTo(self.wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self.wmPlayer).with.offset(0);
        }];
        [self.wmPlayer.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wmPlayer).with.offset(0);
            make.right.equalTo(self.wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.wmPlayer).with.offset(0);
        }];
        [self.wmPlayer.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wmPlayer.topView).with.offset(45);
            make.right.equalTo(self.wmPlayer.topView).with.offset(-45);
            make.center.equalTo(self.wmPlayer.topView);
            make.top.equalTo(self.wmPlayer.topView).with.offset(0);
        }];
        [self.wmPlayer.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wmPlayer).with.offset(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
            make.top.equalTo(self.wmPlayer).with.offset(5);
            
        }];
        [self.wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.wmPlayer);
            make.width.equalTo(self.wmPlayer);
            make.height.equalTo(@30);
        }];
        
    }completion:^(BOOL finished) {
        self.wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        self.wmPlayer.fullScreenBtn.selected = NO;
        self.isSmallScreen = YES;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.wmPlayer];
    }];
    
}


-(void)toCell{
    
    WSLTableViewCell *currentCell = (WSLTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndexPath.row inSection:0]];
    
    [self.wmPlayer removeFromSuperview];
    
    NSLog(@"row = %ld",_currentIndexPath.row);
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.wmPlayer.transform = CGAffineTransformIdentity;
        
        self.wmPlayer.frame = currentCell.myBackView.bounds;
        
        self.wmPlayer.playerLayer.frame =  self.wmPlayer.bounds;
        
        [currentCell.myBackView addSubview:self.wmPlayer];
        [currentCell.myBackView bringSubviewToFront:self.wmPlayer];
        
        [self.wmPlayer.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wmPlayer).with.offset(0);
            make.right.equalTo(self.wmPlayer).with.offset(0);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(self.wmPlayer).with.offset(0);
        }];
        
        [self.wmPlayer.loadFailedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.wmPlayer);
            make.width.equalTo(self.wmPlayer);
            make.height.equalTo(@30);
        }];
        
    }completion:^(BOOL finished) {
        
        self.wmPlayer.isFullscreen = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        self.isSmallScreen = NO;
        self.wmPlayer.fullScreenBtn.selected = NO;
        
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(complaintAction) image:@"button_complaint_gray" hightImage:@"button_complaint_red"];
    // 网络监控
    [self reachbility];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(goBackTopAction) image:@"button_top_gray" hightImage:@"button_top_red"];
    
#pragma mark ------>> 注册cell <<------
    [self.tableView registerNib:[UINib nibWithNibName:@"WSLTableViewCell" bundle:nil] forCellReuseIdentifier:@"WSLTableViewCell"];
    
    
#pragma mark ------> 刷新 <----------
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(newData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(oldData)];
}

// 回到顶部
- (void)goBackTopAction
{
    if (self.modelArray.count > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    }
}

#pragma mark ------> 刷新 <----------
//下拉更新数据
- (void)newData{
    _currentPageNumber = -9;
    [self userDefailNetWorkYesOrNo];
    
}

//上拉刷新数据
- (void)oldData{
    [self userDefailNetWorkYesOrNo];
}

#pragma mark ------>> 判断用户的设置是否是仅 WiFi 播放视频 <<------
- (void)userDefailNetWorkYesOrNo
{
//    NSInteger netWorkTypeNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NetWorkType"] integerValue];
//    switch (netWorkTypeNum)
//    {
//        case 1:
//        {
//            if (_netWorkType == NetWorkWIFI)
//            {
//                [self loadData];
//            }else
//            {
//                if (self.tableView.mj_header.isRefreshing) {
//                    
//                    [self.tableView.mj_header endRefreshing];
//                }
//                if (self.tableView.mj_footer.isRefreshing)
//                {
//                    [self.tableView.mj_footer endRefreshing];
//                }
//                [self showAlertViewControllerWithStr:@"无可用WiFi" time:0.5];
//            }
//        
//        }
//            break;
//            
//        default:
//        {
    
            if (_netWorkType != NetWorkELSE)
            {
                [self loadData];
            }else
            {
                if (self.tableView.mj_header.isRefreshing) {
                    
                    [self.tableView.mj_header endRefreshing];
                }
                if (self.tableView.mj_footer.isRefreshing)
                {
                    [self.tableView.mj_footer endRefreshing];
                }
                [self showAlertViewControllerWithStr:@"网络连接异常" time:0.5];
            }
//        
//        }
//            break;
//            
//    }
    
}

#pragma mark ------>> 数据解析 <<------
- (void)loadData{
    
    _currentPageNumber += 10;
    
    [JJNetWorkRequst requestWithUrl:GJ_VIDEO_URLStr_JINPING((long)_currentPageNumber) parameters:nil successResponse:^(NSDictionary *dic) {
        
        //判断如果是下拉刷新最新的数据, 就需要清空数组
        if (_currentPageNumber ==1 )
        {
            [self.modelArray removeAllObjects];
        }
        NSArray *array = [dic objectForKey:@"VAP4BFE3U"];
        
        for (NSDictionary *dic in array){
            
            WSLVideoModel *  model = [WSLVideoModel new];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [self.modelArray addObject:model];
            
        }
        [self.tableView reloadData];
        
        if (self.tableView.mj_header.isRefreshing) {
            
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.isRefreshing)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    } failureResponse:^(NSError *error) {
        NSLog(@"%@",error);
        if (self.tableView.mj_header.isRefreshing) {
            
            [self.tableView.mj_header endRefreshing];
        }
        if (self.tableView.mj_footer.isRefreshing)
        {
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self showAlertViewControllerWithStr:@"加载失败!" time:0.5];
        
        
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
    
    
    return self.modelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WSLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WSLTableViewCell" forIndexPath:indexPath];
    
    WSLVideoModel *model = self.modelArray[indexPath.row];
    
    //cell布局绑定数据
    [cell bindDataWithModel:model index:indexPath.row];
    
    //给cell的button添加点击事件(初始化播放器, 传递url)
    [cell.playOrPause addTarget:self action:@selector(startPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.playOrPause.tag = indexPath.row;
    
    //如果播放器存在
    if (self.wmPlayer && self.wmPlayer.superview) {
        
        if (indexPath.row == _currentIndexPath.row) {
            
            [cell.playOrPause.superview sendSubviewToBack:cell.playOrPause];
            
        }else{
            
            [cell.playOrPause.superview bringSubviewToFront:cell.playOrPause];
        }
        
        NSArray *indexpaths = [tableView indexPathsForVisibleRows];
        
        if (![indexpaths containsObject:_currentIndexPath]&&_currentIndexPath!=nil) {//复用
            
            if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self.wmPlayer]) {
                
                self.wmPlayer.hidden = NO;
                
            }else{
                
                self.wmPlayer.hidden = YES;
                [cell.playOrPause.superview bringSubviewToFront:cell.playOrPause];
                
            }
        }else{
            
            if ([cell.myBackView.subviews containsObject:self.wmPlayer]) {
               
                [cell.myBackView addSubview:self.wmPlayer];
                
                [self.wmPlayer play];
                self.wmPlayer.hidden = NO;
            }
        }
    }
    
    return cell;
}

#pragma mark ------>> 播放视频 是否仅 WiFi 下 <<------
- (void)startPlay:(UIButton *)button
{
    
    NSInteger netWorkTypeNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NetWorkType"] integerValue];
    switch (netWorkTypeNum)
    {
        case 1:
        {
            if (_netWorkType == NetWorkWIFI)
            {
                [self startPlayAfterNetWork:button];
            }else
            {
                [self showAlertViewControllerWithStr:@"无可用WiFi" time:0.5];
            }
            
        }
            break;
            
        default:
        {
            
            if (_netWorkType != NetWorkELSE)
            {
                [self startPlayAfterNetWork:button];
            }else
            {
               
                [self showAlertViewControllerWithStr:@"网络连接异常" time:0.5];
            }

        }
            break;
    }
    
    
}

 
- (void)startPlayAfterNetWork:(UIButton *)button
{
    //获取点击的button需要哪个cell
    _currentIndexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    self.currentCell = [self.tableView cellForRowAtIndexPath:_currentIndexPath];
    
    //判断播放器如果已经存在
    if (self.wmPlayer) {
        
        //释放之前的播放器
        [self releaseWMPlayer];
        
    }
    //初始化新的播放器
    self.wmPlayer = [[WMPlayer alloc]initWithFrame:self.currentCell.myBackView.bounds];
    self.wmPlayer.delegate = self;
    
    //从数据源数组中找到对应视频url, 并传递到请求视频的类中
    WSLVideoModel *model = [self.modelArray objectAtIndex:button.tag];
    self.wmPlayer.URLString = model.mp4_url;
    
    //不需要, 所以需要移除封装好的view中的某个控件
    [self.wmPlayer.topView removeFromSuperview];
    
    //在指定的cell上添加播放器
    [self.currentCell.myBackView addSubview:self.wmPlayer];
    [self.currentCell.myBackView bringSubviewToFront:self.wmPlayer];
    [self.currentCell.playOrPause.superview sendSubviewToBack:self.currentCell.playOrPause];
    
    //重新加载tableView
    [self.tableView reloadData];

}


//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    //从Xib中找到对应的cell
    WSLTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"WSLTableViewCell" owner:self options:nil].firstObject;
    [cell setNeedsUpdateConstraints];
    
    [cell updateConstraintsIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    return height;
}


// 释放WMPlayer
-(void)releaseWMPlayer{
    [self.wmPlayer.player.currentItem cancelPendingSeeks];
    [self.wmPlayer.player.currentItem.asset cancelLoading];
    [self.wmPlayer pause];
    
    
    [self.wmPlayer removeFromSuperview];
    [self.wmPlayer.playerLayer removeFromSuperlayer];
    [self.wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    self.wmPlayer.player = nil;
    self.wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [self.wmPlayer.autoDismissTimer invalidate];
    self.wmPlayer.autoDismissTimer = nil;
    
    
    self.wmPlayer.playOrPauseBtn = nil;
    self.wmPlayer.playerLayer = nil;
    self.wmPlayer = nil;
}


//点击全屏按钮,实现全屏播放
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (fullScreenBtn.isSelected) {//全屏显示
        self.wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        if (self.isSmallScreen) {
            //放widow上,小屏显示
            [self toSmallScreen];
        }else{
            [self toCell];
        }
    }
}


//播放完成时, 停止播放
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay");
    WSLTableViewCell *currentCell = (WSLTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndexPath.row inSection:0]];
    [currentCell.playOrPause.superview bringSubviewToFront:currentCell.playOrPause];
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark ------>> 网络监控 <<------
- (void)reachbility
{
    // 创建网络监听管理者对象
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 设置监听
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
                
            case AFNetworkReachabilityStatusUnknown:
                _netWorkType  = NetWorkELSE;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _netWorkType = NetWorkWWAN;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _netWorkType = NetWorkWIFI;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                _netWorkType  = NetWorkELSE;
                break;
                
            default:
                _netWorkType  = NetWorkELSE;
                break;
        }
    }];
    // 开启监听
    [mgr startMonitoring];
}





@end
