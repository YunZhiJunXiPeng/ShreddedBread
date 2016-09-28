//
//  PPAlertSettingView.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/19.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DateBlock)(NSDate *getDate);

@interface PPAlertSettingView : UIView


@property (copy, nonatomic) DateBlock getDate;

@property (strong, nonatomic) NSDate *maxDate;
@property (strong, nonatomic) NSDate *minDate;

@end
