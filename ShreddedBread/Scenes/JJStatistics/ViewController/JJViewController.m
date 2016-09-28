//
//  JJViewController.m
//  ViewSelector
//
//  Created by BoonZ on 16/8/15.
//  Copyright © 2016年 leehyoley. All rights reserved.
//

#import "JJViewController.h"
#import "LXViewSelectorController.h"

#import "JJPieViewController.h"

@interface JJViewController ()

@end

@implementation JJViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(pushDetail) image:@"饼干" hightImage:@"饼干"];
    
    
    
}

- (void)pushDetail{
    
    JJPieViewController *pieVC = [JJPieViewController new];
                                  
    [self.navigationController pushViewController:pieVC animated:YES];
    
    
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
