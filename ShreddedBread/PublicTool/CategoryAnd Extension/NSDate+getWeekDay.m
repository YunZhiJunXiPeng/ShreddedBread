//
//  NSDate+getWeekDay.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/18.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "NSDate+getWeekDay.h"

@implementation NSDate (getWeekDay)






// 获取当前是星期几
+ (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday]-1;
}
+ (NSString *)getNowWeekDayString
{
    switch ([self getNowWeekday])
    {
        case 0:
            return @"星期天";
            break;
        case 1:
            return @"星期一";
            break;
        case 2:
            return @"星期二";
            break;
        case 3:
            return @"星期三";
            break;
        case 4:
            return @"星期四";
            break;
        case 5:
            return @"星期五";
            break;
        case 6:
            return @"星期六";
            break;
            
        default:
            break;
    }
    return nil;
}

/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
+ (NSString *)getWeekdayWithDateString:(NSString *)featureDate
{
    NSLog(@"------------->%@",featureDate);
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    //long days = [NSDate daysFromDate:[NSDate date] toDate:endDate];
    NSDate *start = [formatter dateFromString:@"2000-08-07"];
    long days = [NSDate daysFromDate:start toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
   // long week = [NSDate getNowWeekday] + day;
    long week = 1 + day;
    switch (week) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
            
        default:
            break;
    }
    return nil;
}
+ (NSString *)getWeekdayWithDate:(NSDate *)featureDate
{

    return [self getWeekdayWithDateString:[NSString getDateStringFromDate:featureDate]];
}

// 某一天的礼拜几 NSInteger
+(NSInteger)getWeekDayIntegerFromDateString:(NSString *)featureDate
{

    NSLog(@"------------->%@",featureDate);
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    //long days = [NSDate daysFromDate:[NSDate date] toDate:endDate];
    NSDate *start = [formatter dateFromString:@"2000-08-07"];
    long days = [NSDate daysFromDate:start toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
   
    return day;
}
// 根据日期 得到 integer 的周几
+(NSInteger)getWeekDayIntegerFromDate:(NSDate *)featureDate
{
    return [self getWeekDayIntegerFromDateString:[NSString getDateStringFromDate:featureDate]];
}

// 根据日期得到月份
+ (NSString *)getMonthStringFromDate:(NSDate *)date
{

    NSInteger shi = [[date.description substringWithRange:NSMakeRange(5, 1)] integerValue];
    NSInteger ge = [[date.description substringWithRange:NSMakeRange(6, 1)] integerValue];
    
    return [NSString stringWithFormat:@"%ld", shi * 10 + ge];
}
// 根据日期得到日
+ (NSString *)getYearStringFromDate:(NSDate *)date
{
    return [NSString stringWithFormat:@"%@",[date.description substringWithRange:NSMakeRange(0, 4)]];
}

/**
 *  计算2个日期相差天数
 *  startDate   起始日期
 *  endDate     截至日期
 */
+(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
   
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0 && hours <= 0&&minute<= 0) {
        NSLog(@"0天0小时0分钟");
        return 0;
    }
    else {
       // NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}





@end
