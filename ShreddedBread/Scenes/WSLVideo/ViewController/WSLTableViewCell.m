//
//  WSLTableViewCell.m
//  ShreddedBread
//
//  Created by lanou3g on 16/8/15.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "WSLTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

#import <SDWebImage/UIImageView+WebCache.h>
#import "GetHeightTool.h"
#import "Url_marco.h"


#import "UserModel.h"
#import "WSLVideoModel.h"

@interface WSLTableViewCell ()

@property (nonatomic, strong) WSLVideoModel *model;
@property (assign, nonatomic) NSInteger currentTag;

@end

@implementation WSLTableViewCell

- (void)bindDataWithModel:(WSLVideoModel *)model index:(NSInteger)indexRow{
    
    //用户头像
   // NSString *str = [NSString stringWithFormat:@"%@",model.topicImg];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.topicImg] placeholderImage:[UIImage imageNamed:@"iTunesArtwork"]];
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = self.icon.frame.size.width / 2;
    
    
    //用户名
    self.userId.text = model.topicName;
    
    
    //时间
    self.date.text = [model.ptime substringToIndex:10];
    
    //占位图片
    [self.placeholderImage sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    

    //视频描述
    self.title.text = [NSString stringWithFormat:@"#%@#", model.title];
    self.title.adjustsFontSizeToFitWidth = YES;
    
    //视频来自
    self.videosource.text = [NSString stringWithFormat:@"来自: %@", model.videosource];
   
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
