//
//  PP_MenuCell.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/26.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellBlock)();
@interface PP_MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *buttonCell;

@property (copy, nonatomic) CellBlock buttonBlock;
@end
