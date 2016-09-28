//
//  NSString+formatterout.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/17.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/**
 *  把 date 数据 转化成我们需要的存入数据库的形式  和 NSInteger 类型
 
 */
#import <Foundation/Foundation.h>

@interface NSString (formatterout)


+ (NSInteger)getDateIntegerFromDate:(NSDate *)date;


+ (NSString *)getDateStringFromDate:(NSDate *)date;


// 把 Date 转成年
+ (NSString *)getYearStringFromDate:(NSDate *)date;
// 把 Date 转成月
+ (NSString *)getMonthStringFromDate:(NSDate *)date;


// 传入 心情和标记 返回字符串
+ (NSString *)getMoodStringMood:(NSInteger)mood;
+ (NSString *)getTagStringTag:(NSInteger)tag;

// 字符串得到  Mood NSInteger
+ (NSInteger)getMoodIntegerByString:(NSString *)mood;
// 字符串得到  Tag NSInteger
+ (NSInteger)getTagIntegerByString:(NSString *)tag;

@end
