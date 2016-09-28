//
//  MoodMessageCell.m
//  ShreddedBread
//
//  Created by BoonZ on 16/8/19.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "MoodMessageCell.h"
#import "dayModel.h"

#import "GetHeightTool.h"


@implementation MoodMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.tagImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //self.tagImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.tagImageView];
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.backImageView];
        
        self.emptyImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.emptyImageView];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.tagLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.tagLabel];
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.textColor = [UIColor colorWithWhite:0.510 alpha:1.000];
        [self.contentView addSubview:self.descriptionLabel];
        
        
        self.timeThread = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.timeThread.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.timeThread];
        
        
        
    }
    
    return self;
}

- (void)setValueWithModel:(dayModel *)model{
    
    //标记图片
    self.tagImageView.frame = CGRectMake(15, 2, 20, 20);
    self.tagImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", model.moodDay]];

    //标记背景
    self.backImageView.frame = CGRectMake(CGRectGetMaxX(self.tagImageView.frame), self.tagImageView.frame.origin.y, jjScreenWidth - 70, 100);
    //背景图片处理
    UIImage *backImage = [UIImage imageNamed:@"background"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5, 15, 0, 5);
    // 拉伸图片
    UIImage *newImage = [backImage resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    self.backImageView.image = newImage;

    //标记内容
    self.tagLabel.frame = CGRectMake(self.backImageView.frame.origin.x+15, self.backImageView.frame.origin.y + 8, self.backImageView.frame.size.width - 5, 30);
    self.tagLabel.font = [UIFont systemFontOfSize:17 weight:10];
    self.tagLabel.text = [NSString getTagStringTag:model.tagDay];
 
    
    //记录内容
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@\n%@",[NSString getDateStringFromDate:model.dateDay],model.content];
    self.descriptionLabel.font = [UIFont systemFontOfSize:14];
    
    CGFloat labelHeight = [GetHeightTool getHeightForText:self.descriptionLabel.text font:[UIFont systemFontOfSize:14] width:jjScreenWidth - 100];
    self.descriptionLabel.frame = CGRectMake(CGRectGetMinX(self.backImageView.frame) + 15, CGRectGetMaxY(self.tagLabel.frame)+ 5, self.backImageView.frame.size.width - 20, labelHeight);
    self.emptyImageView.frame = CGRectMake(self.backImageView.frame.origin.x + 7, CGRectGetMaxY(self.tagLabel.frame), self.backImageView.frame.size.width - 8, self.descriptionLabel.frame.size.height + 10);
    
    //背景图片处理
    UIImage *image = [UIImage imageNamed:@"empty"];
    //上, 左, 下, 右部分不可拉伸的区域
    UIEdgeInsets edgeInsets1 = UIEdgeInsetsMake(0, 10, 10, 10);
    UIImage *newimage = [image resizableImageWithCapInsets:edgeInsets1 resizingMode:UIImageResizingModeStretch];
    self.emptyImageView.image = newimage;
    
    
    //时间轴
    self.timeThread.frame = CGRectMake(self.tagImageView.center.x - 1, CGRectGetMaxY(self.tagImageView.frame)+1, 2, self.descriptionLabel.frame.size.height + 33);

    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
