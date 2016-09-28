//
//  PPFMDBdataHandle.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/17.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "PPFMDBdataHandle.h"
#import <FMDB.h>
#import "dayModel.h"
#import <JTCalendar/JTCalendar.h>
@interface PPFMDBdataHandle ()

@property (strong, nonatomic) NSString *dbPath;

@property (strong, nonatomic) FMDatabase *dataBase;
// 管理工具
@property (strong, nonatomic) JTCalendarManager *calendarManager;

@end

@implementation PPFMDBdataHandle

#pragma mark ------>> 单例创建方法 <<------
+ (instancetype)sharePPFMDBdataHandle
{
    static PPFMDBdataHandle *dbPP = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dbPP = [[PPFMDBdataHandle alloc] init];
        dbPP.calendarManager = [JTCalendarManager new];
        [dbPP creatTableForDB];
    });
    
    return dbPP;
}


#pragma mark ------>> 路径的懒加载 <<------
- (NSString *)dbPath
{
    if (!_dbPath)
    {
        _dbPath = [NSString stringWithFormat:@"%@/jjppDay.sqlite",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    }

    return _dbPath;
}

//*******************************************************************************

#pragma mark ------>> 建 表 数据库的创建 <<------
- (void)creatTableForDB
{
    NSString *creatStr = @"create table if not exists jjpp (uid integer primary key  autoincrement not null, dateDetail integer unique, week text,month text,year text, moodDay integer, tagDay integer, content text,dateDay date unique)";
    //NSLog(@"数据库位置----->%@",self.dbPath);
    self.dataBase = [FMDatabase databaseWithPath:self.dbPath];
    //判断数据库是否打开
    if ([self.dataBase open]) {
        BOOL result = [self.dataBase executeUpdate:creatStr];
        
        if (result) {
            NSLog(@"建表成功");
        }else {
            NSLog(@"建表失败");
            
        }
    }
    [self.dataBase close];
    NSLog(@"数据库位置----->%@",self.dbPath);
    
}
//*******************************************************************************

#pragma mark ------>> 插入一条数据  传入dayModel 类型 <<------
- (void)insertOneObjectModelDay:(dayModel *)oneDay
{
 
 if ([self.dataBase open]) {

     BOOL request = [self.dataBase executeUpdateWithFormat:@"insert into jjpp (dateDetail,week,month,year,moodDay,tagDay,content,dateDay) values (%ld, %@, %@, %@, %ld, %ld, %@, %@)",[NSString getDateIntegerFromDate:oneDay.dateDay],oneDay.week,oneDay.month,oneDay.year,oneDay.moodDay,oneDay.tagDay,oneDay.content,[NSString getDateStringFromDate:oneDay.dateDay]];
     
     if (request)
        {
            NSLog(@"插入成功");
        }else
        {
            NSLog(@"插入失败--->%@", self.dataBase.lastErrorMessage);
            //self.oneErrorBlock(self.dataBase.lastErrorMessage, @"插入");
        }
    }
    [self.dataBase close];
}

//***************************  下面是查找的方法 ********************************************

#pragma mark ------>> 查找全部  <<------

-(NSArray *)serchAllFromSQL
{
    NSString *searchStr = @"select * from jjpp";
    return [self serchAllDaysBySQLStr:searchStr];
}
- (NSArray *)serchAllDaysBySQLStr:(NSString *)aSQLstr
{
    NSMutableArray *array = [NSMutableArray new];
    
    if ([self.dataBase open])
    {
        FMResultSet *result = [self.dataBase executeQuery:aSQLstr];
       
        while ([result next])
        {
            dayModel *oneDay = [dayModel new];
            oneDay.dateDetail = [result intForColumn:@"dateDetail"];
            oneDay.week = [result objectForColumnName:@"week"];
            oneDay.month = [result objectForColumnName:@"month"];
            oneDay.year =[result objectForColumnName:@"year"];
            oneDay.moodDay = [result intForColumn:@"moodDay"];
            oneDay.tagDay = [result intForColumn:@"tagDay"];
            oneDay.content  = [result objectForColumnName:@"content"];
            oneDay.dateDay = [result objectForColumnName:@"dateDay"];
            [array addObject:oneDay];
            
        }
             NSLog(@"查找成功");
        //NSLog(@"数据库位置----->%@",self.dbPath);
    }
    
    [self.dataBase close];
    
    return [array sortedArrayUsingDescriptors:
            @[[NSSortDescriptor sortDescriptorWithKey:@"dateDay" ascending:YES]]];
}

#pragma mark ------>> 查找某一年的数据 <<------
- (NSArray *)searchAllInformationByOneYear:(NSString *)year
{
    NSString *searchStr =[NSString stringWithFormat:@"select * from jjpp where year = %@", year];
    
    NSMutableArray *array = [NSMutableArray new];
    for (dayModel *model in [self serchAllDaysBySQLStr:searchStr])
    {
        [array addObject:@(model.moodDay)];
    }
    
    return array;
}

#pragma mark ------>> 查找根据 两个时间范围 <<------
// NSInteger 时间
- (NSArray *)serchAllDataFromIntegerDate:(NSInteger )smallDate
                                  toDate:(NSInteger )bigDate
{
    
    NSString *searchStr =[NSString stringWithFormat:@"select * from jjpp where dateDetail >= %ld and dateDetail <= %ld",smallDate,bigDate] ;
    return [self serchAllDaysBySQLStr:searchStr];
}
// NSDate 区间
- (NSArray *)serchAllDataFromSmallDate:(NSDate *)aDate
                               bigDate:(NSDate *)otherDate
{
    return [self serchAllDataFromIntegerDate:[NSString getDateIntegerFromDate:aDate] toDate:[NSString getDateIntegerFromDate:otherDate]];
}
#pragma mark ------>> 查找某一个日期之前的所有结果 <<------
- (NSArray *)serchAllDataBeforeIntegerDate:(NSInteger)date
{
    NSString *searchStr =[NSString stringWithFormat:@"select * from jjpp where dateDetail <= %ld",date] ;
  return  [self serchAllDaysBySQLStr:searchStr];
}
- (NSArray *)serchAllDataBeforeDate:(NSDate *)date
{
    return [self serchAllDataBeforeIntegerDate:[NSString getDateIntegerFromDate:date]];
}

#pragma mark ------>> 查找某一天的数据 <<------
- (NSArray *)serchAllInformationForOneIntegerDay:(NSInteger)date
{
    NSString *searchStr =[NSString stringWithFormat:@"select * from jjpp where dateDetail = %ld",date] ;
    return  [self serchAllDaysBySQLStr:searchStr];
}
- (NSArray *)serchAllInformationForOneDateDay:(NSDate *)date
{

    return [self serchAllInformationForOneIntegerDay:[NSString getDateIntegerFromDate:date]];

}
#pragma mark ------>> 当前月第一天到这个月某一天的数据 <<------
- (NSArray *)firstDayOneMothToCurrentDay:(NSDate *)date
{
    NSDate *fisrstDay = [_calendarManager.dateHelper firstDayOfMonth:date];
    
    return [self serchAllDataFromSmallDate:fisrstDay bigDate:date];
}

// 返回 本月的心情 元素 @(NSINteger)
- (NSArray *)moodeFromFirstDayOneMonthToCurrentDay:(NSDate *)date
{
    NSMutableArray *array = [NSMutableArray new];
    for (dayModel *model in [self firstDayOneMothToCurrentDay:date])
    {
        [array addObject:@(model.moodDay)];
    }
    return array;
}
// 返回当前的月 统计的 号
- (NSArray *)monthDayFromFirstDayOneMonthToCurrentDay:(NSDate *)date
{

    NSMutableArray *array = [NSMutableArray new];
    for (dayModel *model in [self firstDayOneMothToCurrentDay:date])
    {
        NSString *temp = [model.description substringWithRange:NSMakeRange(8, 2)];
        [array addObject:[NSString stringWithFormat:@"%@日",temp]];
    }
    return array;

}

#pragma mark ------>> 当前这天所在周的第一天到这天的数据 <<------
- (NSArray *)firstDayOneWeekToCurrentDay:(NSDate *)date
{
    NSDate *fisrstDay = [_calendarManager.dateHelper firstWeekDayOfWeek:date];
    
    NSLog(@"--********---按周--------->%@",fisrstDay);
    return [self serchAllDataFromSmallDate:fisrstDay bigDate:date];
}

- (NSArray *)moodeFromFirstDayOneWeekToCurrentDay:(NSDate *)date
{
    NSMutableArray *array = [NSMutableArray new];
    for (dayModel *model in [self firstDayOneWeekToCurrentDay:date])
    {
        [array addObject:@(model.moodDay)];
    }
    return array;
}
- (NSArray *)weekDayFromFirstDayOneWeekToCurrentDay:(NSDate *)date
{
    NSMutableArray *array = [NSMutableArray new];
    for (dayModel *model in [self firstDayOneWeekToCurrentDay:date])
    {
        [array addObject:model.week];
    }
  //  NSLog(@"-周几----%@",array);
    return array;
}


#pragma mark ------>> 查找某年某个月 的数据 <<------

- (NSArray *)serchallDataForYear:(NSString *)year
                            moth:(NSString *)moth
{
    NSString *searchStr =[NSString stringWithFormat:@"select * from jjpp where month = %@ and year = %@",moth, year] ;

    return  [self serchAllDaysBySQLStr:searchStr];
    
}

- (NSArray *)moodSerchallDataForYear:(NSString *)year
                            moth:(NSString *)moth
{
  
    NSMutableArray *arry = [NSMutableArray new];
    for (dayModel *model in [self serchallDataForYear:year moth:moth])
    {
        [arry addObject:@(model.moodDay)];
    }
    return arry;
}
// 某年某月 心情的统计结果
- (NSDictionary *)moodDicmoodSerchallDataForYear:(NSString *)year
                                            moth:(NSString *)moth
{
    NSInteger a = 0;NSInteger b = 0;NSInteger c = 0;NSInteger d = 0; NSInteger e = 0;
    for (NSNumber *temp in [self moodSerchallDataForYear:year moth:moth])
    {
        switch ([temp integerValue])
        {
            case 0:
                a++;
                break;
            case 1:
                b++;
                break;
            case 2:
                c++;
                break;
            case 3:
                d++;
                break;
            default:
                e++;
                break;
        }
    }

    NSDictionary *dic = @{@"0":@(a),@"1":@(b),@"2":@(c),@"3":@(d),@"error":@(e)};
    return dic;
}

//*******************************************************************************

#pragma mark ------>> 某年的心情统计结果 <<------
- (NSDictionary *)moodDicmoodSerchallDataForOneYear:(NSString *)year
{
    NSInteger a = 0;NSInteger b = 0;NSInteger c = 0;NSInteger d = 0; NSInteger e = 0;
    for (NSNumber *temp in [self searchAllInformationByOneYear:year])
    {
        switch ([temp integerValue])
        {
            case 0:
                a++;
                break;
            case 1:
                b++;
                break;
            case 2:
                c++;
                break;
            case 3:
                d++;
                break;
            default:
                e++;
                break;
        }
    }
    
    NSDictionary *dic = @{@"0":@(a),@"1":@(b),@"2":@(c),@"3":@(d),@"error":@(e)};
    return dic;
}

//*******************************************************************************

#pragma mark ------>> 修改数据的方法 根据传入的 DayModel <<------
- (void)upDataOnTheDate:(dayModel *)model
{
    if ([self.dataBase open])
    {
        BOOL request = [self.dataBase executeUpdateWithFormat:@"update jjpp set moodDay = %ld,tagDay = %ld, content = %@ where dateDetail = %ld",model.moodDay,model.tagDay, model.content,model.dateDetail];
        
                    
        if (request)
        {
           // NSLog(@"--->%ld-->%ld-->%@--->条件%ld",model.moodDay,model.tagDay,model.content, model.dateDetail);
            NSLog(@"修改成功");
            NSLog(@"数据库位置----->%@",self.dbPath);
        }else
        {
            NSLog(@"修改失败--->%@", self.dataBase.lastErrorMessage);
            //self.oneErrorBlock(self.dataBase.lastErrorMessage, @"修改");
        }
    }
    [self.dataBase close];
}
//*******************************************************************************
- (NSArray *)allWeekMoodIncluEmpty
{
    NSArray *mood = [self moodeFromFirstDayOneWeekToCurrentDay:[NSDate date]];
    NSArray *week = [self weekDayFromFirstDayOneWeekToCurrentDay:[NSDate date]];
    NSMutableArray *array = [@[@0,@0,@0,@0,@0,@0,@0] mutableCopy];
    int i = 0;
    for (NSNumber *index in week)
    {
        array[[index integerValue]] = mood[i];
        i++;
    }
    [array insertObject:array[6] atIndex:0];
    [array removeObjectAtIndex:7];
    
    return array;
}
//*******************************************************************************
- (NSArray <NSString *>*)getYearsKindFromSQL
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (dayModel *model in [self serchAllFromSQL])
    {
        if (![array containsObject:model.year])
        {
            [array addObject:model.year];
        }
    }
    return array;
}






@end
