//
//  NSString+formatterout.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/17.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "NSString+formatterout.h"

@implementation NSString (formatterout)


// 字符串转成 NSInteger 类型
+ (NSInteger)getDateIntegerFromDate:(NSDate *)date
{
    NSArray *array = [[date.description substringToIndex:10] componentsSeparatedByString:@"-"];

    return [[NSString stringWithFormat:@"%@%@%@",array[0],array[1],array[2]] integerValue]
;
}

// 存数据库的形式
+ (NSString *)getDateStringFromDate:(NSDate *)date
{

    return [date.description substringToIndex:10];

}

// 把 Date 转成年
+ (NSString *)getYearStringFromDate:(NSDate *)date
{

    return [date.description substringToIndex:4];
}
// 转成月
+ (NSString *)getMonthStringFromDate:(NSDate *)date
{
    NSString *moth = [NSString new];
    
    NSInteger temp1 = [[date.description substringWithRange:NSMakeRange(5, 1)] integerValue];
    NSInteger temp2 = [[date.description substringWithRange:NSMakeRange(6, 1)] integerValue];
    
    NSInteger temp = temp1 * 10 +temp2;
    switch (temp)
    {
        case 1:
            moth = @"一月";
            break;
        case 2:
            moth = @"二月";
            break;
        case 3:
            moth = @"三月";
            break;
        case 4:
            moth = @"四月";
            break;
        case 5:
            moth = @"五月";
            break;
        case 6:
            moth = @"六月";
            break;
        case 7:
            moth = @"七月";
            break;
        case 8:
            moth = @"八月";
            break;
        case 9:
            moth = @"九月";
            break;
        case 10:
            moth = @"十月";
            break;
        case 11:
            moth = @"十一月";
        case 12:
            moth = @"十二月";
            break;
        default:
            NSLog(@"月份处理失败");
            break;
}
    return moth;
}

//// 转成月份  01 02
//// 转成月
//+ (NSString *)getMonthStringFromMonthString:(NSString *)str
//{
//    if ([str isEqualToString:@"一月"])
//    {
//        <#statements#>
//    }
//   
//}




+ (NSString *)getMoodStringMood:(NSInteger)mood
{
    switch (mood) {
        case 0:
            return MOOD_Null;
            break;
        case 1:
            return MOOD_Sad;
            break;
        case 2:
            return MOOD_Normal;
            break;
        case 3:
            return MOOD_Happy;
            break;
        default:
            return @"未记录";
            break;
    }
    
}
+ (NSString *)getTagStringTag:(NSInteger)tag
{
    switch (tag) {
        case 0:
            return TAG_Important;
            break;
        case 1:
            return TAG_Star;
            break;
        case 2:
            return TAG_Heihei;
            break;
        case 3:
            return TAG_Dayima;
            break;
        default:
            return @"未记录";
            break;
    }
    
}
// 字符串得到 NSInteger
+ (NSInteger)getMoodIntegerByString:(NSString *)mood
{
    if ([mood isEqualToString:MOOD_Happy])
    {
        return 3;
    }
    if ([mood isEqualToString:MOOD_Normal])
    {
        return 2;
    }
    if ([mood isEqualToString:MOOD_Sad])
    {
        return 1;
    }
    if ([mood isEqualToString:MOOD_Null])
    {
        return 0;
    }
    return 0;
}
// 字符串得到  Tag NSInteger
+ (NSInteger)getTagIntegerByString:(NSString *)tag
{
    if ([tag isEqualToString:TAG_Important])
    {
        return 0;
    }
    if ([tag isEqualToString:TAG_Star])
    {
        return 1;
    } if ([tag isEqualToString:TAG_Heihei])
    {
        return 2;
    }
    if ([tag isEqualToString:TAG_Dayima])
    {
        return 3;
    }

    return 4;

}


@end
