//
//  PP_MenuTableView.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/22.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SelectBlock)(UITableView *tableView,NSString *index);

@interface PP_MenuTableView : UITableView


@property (strong, nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) SelectBlock selecRow;

@property (strong, nonatomic) NSMutableArray *sectionRowNum;

@end
