//
//  NSDate+getWeekDay.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/18.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (getWeekDay)



// 获取当前是星期几
+ (NSInteger)getNowWeekday;
+ (NSString *)getNowWeekDayString;

// 根据日期 得到 integer 的周几
+(NSInteger)getWeekDayIntegerFromDate:(NSDate *)featureDate;
// 某一天的礼拜几 NSInteger
+(NSInteger)getWeekDayIntegerFromDateString:(NSString *)featureDate;

/**
 *  获取某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
+ (NSString *)getWeekdayWithDateString:(NSString *)featureDate;
+ (NSString *)getWeekdayWithDate:(NSDate *)featureDate;

/**
 *  计算2个日期相差天数
 *  startDate   起始日期
 *  endDate     截至日期
 */
+(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

// 根据日期得到月份
+ (NSString *)getMonthStringFromDate:(NSDate *)date;
// 根据日期得到日
+ (NSString *)getYearStringFromDate:(NSDate *)date;


@end
