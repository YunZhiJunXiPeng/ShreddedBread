//
//  dayModel.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/17.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "dayModel.h"

@implementation dayModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"容错");

}

- (NSString *)description
{

    return  [NSString stringWithFormat:@"%@%ld",self.dateDay,self.dateDetail];
}

+(instancetype)dayModelWithDate:(NSDate *)date
                        moodDay:(NSInteger)moodDay
                         tagDay:(NSInteger)tagDay
                        content:(NSString *)content
{
    dayModel *oneDay = [dayModel new];
    oneDay.dateDetail = [NSString getDateIntegerFromDate:date];
    oneDay.week = [NSString stringWithFormat:@"%ld",[NSDate getWeekDayIntegerFromDate:date]];
    oneDay.month = [NSString stringWithFormat:@"%@",[NSDate getMonthStringFromDate:date]];
    oneDay.year = [NSString stringWithFormat:@"%@",[NSDate getYearStringFromDate:date]];
    oneDay.moodDay = moodDay;
    oneDay.tagDay = tagDay;
    oneDay.content  = content;
    oneDay.dateDay = date;
    return oneDay;
}
@end
