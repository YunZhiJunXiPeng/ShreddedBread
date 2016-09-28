//
//  PPSettingVC.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/22.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "PPSettingVC.h"
#import "PP_MenuTableView.h"
#import "GetHeightTool.h"
@interface PPSettingVC ()
@property (weak, nonatomic) IBOutlet PP_MenuTableView *tableView;

@end

@implementation PPSettingVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
// 点击 Cell 的触发方法
    [self selectCellAction];

}

- (void)selectCellAction
{
    WEAK_SELF(weakSelf);
    self.tableView.selecRow = ^(UITableView *tableView, NSString *index)
    {
        [weakSelf showAlertViewControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确认清除当前缓存! 共 %@ !",index] preferredStyle:(UIAlertControllerStyleAlert) alertActionName:@"确认" alertActionOne:^{
                
                [GetHeightTool clearCachesAppFile];
                [tableView reloadData];
                
            } alertBackAfter:^{
                
            }];
        
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
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
