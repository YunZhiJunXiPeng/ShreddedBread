//
//  dayModel.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/17.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dayModel : NSObject


@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) NSInteger dateDetail;
@property (strong, nonatomic) NSString *week;
@property (strong, nonatomic) NSString *month;
@property (strong, nonatomic) NSString *year;
@property (assign, nonatomic) NSInteger moodDay;
@property (assign, nonatomic) NSInteger tagDay;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *dateDay;

+ (instancetype)dayModelWithDate:(NSDate *)date
                        moodDay:(NSInteger)moodDay
                         tagDay:(NSInteger)tagDay
                        content:(NSString *)content;

@end
