//
//  JokeBookCellTableViewCell.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/24.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "JokeBookCellTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Url_marco.h"
#import "WSLVideoModel.h"
#import "UserModel.h"
@interface JokeBookCellTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *loginLable;

@property (weak, nonatomic) IBOutlet UILabel *upCount;
@property (weak, nonatomic) IBOutlet UILabel *downCount;
@property (weak, nonatomic) IBOutlet UILabel *contentlable;
@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIImageView *myBackView;


@end


@implementation JokeBookCellTableViewCell

- (void)awakeFromNib
{
    
    self.myBackView.layer.shadowOffset = CGSizeMake(3, 3);
    self.myBackView.layer.shadowColor = [UIColor colorWithRed:0.745 green:0.735 blue:0.773 alpha:1.000].CGColor;
    self.myBackView.layer.shadowOpacity = 1;
    
}




- (void)bindContentModel:(WSLVideoModel *)model
{

    [self.iconImage sd_setImageWithURL:ICON_USER_URL(([NSString stringWithFormat:@"%@",model.userJ.uid]),model.userJ.icon) placeholderImage:[UIImage imageNamed:@"iTunesArtwork"]];
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = self.iconImage.frame.size.width / 2;
    self.loginLable.text = model.userJ.login;
    self.upCount.text = [NSString stringWithFormat:@"%@",[model.votes valueForKey:@"up"]];
    self.downCount.text = [NSString stringWithFormat:@"%@",model.votes[@"down"]];
    self.contentlable.text = model.content;

    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.leftView.hidden = !selected;

}

@end
