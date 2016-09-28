//
//  PPFMDBdataHandle.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/17.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.

/**
 *  数据库相关的类
 */

#import <Foundation/Foundation.h>

typedef void(^OneErrorBlock)(NSString *errorMesage, NSString *function);
@class dayModel;
@interface PPFMDBdataHandle : NSObject


@property (copy, nonatomic)OneErrorBlock oneErrorBlock;

+ (instancetype)sharePPFMDBdataHandle;

// 插入数据
- (void)insertOneObjectModelDay:(dayModel *)oneDay;
// 所有存到数据库的数据
- (NSArray *)serchAllFromSQL;
// NSInteger 区间  条件满足两个日期之间
- (NSArray *)serchAllDataFromIntegerDate:(NSInteger )smallDate
                                  toDate:(NSInteger )bigDate;
// NSDate 区间 条件满足两个日期之间
- (NSArray *)serchAllDataFromSmallDate:(NSDate *)aDate
                               bigDate:(NSDate *)otherDate;
// 某个日期之前的数据
- (NSArray *)serchAllDataBeforeIntegerDate:(NSInteger)date;
- (NSArray *)serchAllDataBeforeDate:(NSDate *)date;
// 某一天的数据
- (NSArray *)serchAllInformationForOneIntegerDay:(NSInteger)date;
- (NSArray *)serchAllInformationForOneDateDay:(NSDate *)date;
// 当前月第一天到这个月传入某一天的数据
- (NSArray *)firstDayOneMothToCurrentDay:(NSDate *)date;
// 当期周的第一天到 传入这天的数据
- (NSArray *)firstDayOneWeekToCurrentDay:(NSDate *)date;
// 查找某个月  某年某月
- (NSArray *)serchallDataForYear:(NSString *)year
                            moth:(NSString *)moth;
// 修改数据
- (void)upDataOnTheDate:(dayModel *)model;

//*************************************************************************************
// 返回 本周的心情 元素 @(NSINteger)
- (NSArray *)moodeFromFirstDayOneWeekToCurrentDay:(NSDate *)date;
// 返回当前的周 每一天是  星期几(下标)
- (NSArray *)weekDayFromFirstDayOneWeekToCurrentDay:(NSDate *)date;


// 返回 本周 七天的心情  包括漏掉的记为 0
- (NSArray *)allWeekMoodIncluEmpty;

//*************************************************************************************
// 返回 本月的心情 元素 @(NSINteger)
- (NSArray *)moodeFromFirstDayOneMonthToCurrentDay:(NSDate *)date;

// 返回当前的月 统计的 号
- (NSArray *)monthDayFromFirstDayOneMonthToCurrentDay:(NSDate *)date;

// 某年某月  心情
- (NSArray *)moodSerchallDataForYear:(NSString *)year
                                moth:(NSString *)moth;
// 某年某月 心情的统计结果
- (NSDictionary *)moodDicmoodSerchallDataForYear:(NSString *)year
                                            moth:(NSString *)moth;
// 得到所有的年份
- (NSArray <NSString *>*)getYearsKindFromSQL;
// 某年 心情的统计结果
- (NSDictionary *)moodDicmoodSerchallDataForOneYear:(NSString *)year;

@end
