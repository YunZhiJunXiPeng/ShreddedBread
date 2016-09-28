//
//  MoodMessageCell.h
//  ShreddedBread
//
//  Created by BoonZ on 16/8/19.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dayModel.h"

@interface MoodMessageCell : UITableViewCell

@property (strong, nonatomic) UIImageView *tagImageView;

@property (strong, nonatomic) UILabel *tagLabel;

@property (strong, nonatomic) UILabel *descriptionLabel;

@property (strong, nonatomic) UIImageView *timeThread;

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *emptyImageView;



- (void)setValueWithModel:(dayModel *)model;

@end
