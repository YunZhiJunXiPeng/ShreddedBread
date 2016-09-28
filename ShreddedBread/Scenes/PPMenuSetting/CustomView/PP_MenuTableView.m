//
//  PP_MenuTableView.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/22.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "PP_MenuTableView.h"
#import "GetHeightTool.h"
#import "PP_MenuCell.h"
#define Cell_OUR @"  这是一个记录您的心情,带给您快乐的 APP, 日历和统计可以绘制您专属的心情走势! 笑话视频愿能博君一笑! 不足之处还望多多包涵,给您表示诚挚的歉意!"
@interface PP_MenuTableView ()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation PP_MenuTableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled  = YES;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.dataArray = [@[@"   仅无线下播放视频",@"   关于我们",@"   版本号",@"   清除缓存"] mutableCopy];
        self.sectionRowNum = [@[@0,@0,@0,@0] mutableCopy];
        self.backgroundColor = [UIColor whiteColor];
        //self.tableHeaderView.frame = CGRectZero;
        self.tableFooterView.frame = CGRectZero;
          self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerNib:[UINib nibWithNibName:@"PP_MenuCell" bundle:nil] forCellReuseIdentifier:@"Menu_Cell"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled  = YES;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.dataArray = [@[@"   仅无线下播放视频",@"   关于我们",@"   版本号",@"   清除缓存"] mutableCopy];
        self.sectionRowNum = [@[@0,@0,@0,@0] mutableCopy];
        self.backgroundColor = [UIColor whiteColor];
        //self.tableHeaderView.frame = CGRectZero;
        self.allowsSelection = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView.frame = CGRectZero;
        [self registerNib:[UINib nibWithNibName:@"PP_MenuCell" bundle:nil] forCellReuseIdentifier:@"Menu_Cell"];
    }
    return self;
}

#pragma mark ------>> TableView 的代理方法 <<------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sectionRowNum[section] integerValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Menu_Cell_cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"Menu_Cell_cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.numberOfLines = 0;
  
    switch (indexPath.section)
    {
        case 1:
        {
            cell.textLabel.text = Cell_OUR;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case 2:
        {
             cell.textLabel.text = @"    当前版本  1-00-00-00 ";
           // cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PP_MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Menu_Cell"];
    cell.contentLabel.font = [UIFont systemFontOfSize:17];
   
    WEAK_SELF(weakSelf);
    switch (section)
    {
        case 0:
        {
            cell.contentLabel.text = self.dataArray[section];
            cell.headerImage.image = [UIImage imageNamed:@"setting_wifi_black"];
            NSInteger netWorkType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"NetWorkType"] integerValue];
            //NSLog(@"------>%ld",netWorkType);
            if (netWorkType == 1)
            {
                [cell.buttonCell setBackgroundImage:[UIImage imageNamed:@"setting_slider_on"] forState:(UIControlStateNormal)];
                cell.buttonBlock = ^()
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"NetWorkType"];
                    [weakSelf reloadData];
                };
                
            }else
            {
                [cell.buttonCell setBackgroundImage:[UIImage imageNamed:@"setting_slider_off"] forState:(UIControlStateNormal)];
                cell.buttonBlock = ^()
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"NetWorkType"];
                    [weakSelf reloadData];
                };
            }
        }
            break;
        case 1:
        {
            cell.headerImage.image = [UIImage imageNamed:@"setting_banben_black"];
        }
            break;
        case 2:
        {
            cell.headerImage.image = [UIImage imageNamed:@"setting_our_black"];
            
        }
            break;
        case 3:
        {
            cell.headerImage.image = [UIImage imageNamed:@"setting_delete_black"];
            cell.contentLabel.text = [NSString stringWithFormat:@"%@        %.2f M", self.dataArray[section],[GetHeightTool howBigCachesSizeFromApp]];
            [cell.buttonCell setBackgroundImage:[UIImage imageNamed:@"setting_clear_black"] forState:(UIControlStateNormal)];
            cell.buttonBlock = ^()
            {
                _selecRow(weakSelf,[NSString stringWithFormat:@"%.2f M",[GetHeightTool howBigCachesSizeFromApp]]);
            };

        }
            break;
        default:
            break;
    }
    if (section == 2 || section == 1)
    {
        cell.contentLabel.text = self.dataArray[section];
      
        if ([_sectionRowNum[section] integerValue] == 0)
        {
            [cell.buttonCell setBackgroundImage:[UIImage imageNamed:@"setting_bottm_gray"] forState:(UIControlStateNormal)];
        }else
        {
            [cell.buttonCell setBackgroundImage:[UIImage imageNamed:@"setting_right_gray"] forState:(UIControlStateNormal)];
        }
        cell.buttonBlock = ^()
        {
        if ([weakSelf.sectionRowNum[section] integerValue] == 0)
        {
            weakSelf.sectionRowNum[section] = @1;
        }else
        {
            weakSelf.sectionRowNum[section] = @0;
        }
            [weakSelf reloadData];
        };
    }
    
  
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}


//// 点击事件
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.selecRow(tableView,indexPath);
//}














@end
