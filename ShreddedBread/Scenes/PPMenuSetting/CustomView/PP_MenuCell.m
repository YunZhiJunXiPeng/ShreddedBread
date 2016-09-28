//
//  PP_MenuCell.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/26.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "PP_MenuCell.h"

@implementation PP_MenuCell

- (void)awakeFromNib
{
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttton:)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)buttton:(UIButton *)sender
{
    _buttonBlock();
}












@end
