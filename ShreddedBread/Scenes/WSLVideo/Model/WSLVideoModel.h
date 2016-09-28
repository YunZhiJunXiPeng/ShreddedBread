//
//  WSLVideoModel.h
//  ShreddedBread
//
//  Created by lanou3g on 16/8/15.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface WSLVideoModel : NSObject

@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *high_url;
@property (strong, nonatomic) NSString *pic_url; //占位图片

@property (strong, nonatomic) NSDictionary *votes;

@property (strong, nonatomic) UserModel *userJ;


@property (strong, nonatomic) NSString *mp4_url;  //视频
@property (strong, nonatomic) NSString *cover;  //占位图片
@property (strong, nonatomic) NSString *ptime;  //时间
@property (strong, nonatomic) NSString *title;  //标题
@property (strong, nonatomic) NSString *topicDesc;  //作者描述
@property (strong, nonatomic) NSString *topicImg;  //作者头像
@property (strong, nonatomic) NSString *topicName;  //作者姓名
@property (strong, nonatomic) NSString *videosource; // 视频来自








@end
