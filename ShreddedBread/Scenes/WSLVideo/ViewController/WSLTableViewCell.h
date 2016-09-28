//
//  WSLTableViewCell.h
//  ShreddedBread
//
//  Created by lanou3g on 16/8/15.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSLVideoModel;

typedef void(^sendIndexCell)(NSInteger row);

@interface WSLTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;//头像

@property (weak, nonatomic) IBOutlet UILabel *userId;//昵称


@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *videosource;


@property (copy, nonatomic)sendIndexCell blockRow;

@property (weak, nonatomic) IBOutlet UIView *myBackView; //背景容器

@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage;  //占位图片

@property (weak, nonatomic) IBOutlet UIButton *playOrPause;  //播放按钮

- (void)bindDataWithModel:(WSLVideoModel *)model index:(NSInteger)indexRow;

@end
