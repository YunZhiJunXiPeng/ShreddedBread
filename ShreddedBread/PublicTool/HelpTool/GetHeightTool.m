//
//  GetHeightTool.m
//  GetHeightTool
//
//  Created by 小超人 on 16/6/15.
//  Copyright © 2016年 lanou3g. All rights reserved.
//
/**
 *  给定宽度得到返回自适应高度的方法
 *  另外的方法用来计算  文件夹的文件大小
 */

#import "GetHeightTool.h"

@implementation GetHeightTool



+ (CGFloat)getHeightForText:(NSString *)textShow
                       font:(UIFont *)fontShow
                      width:(CGFloat)widthShow
{
    return [textShow boundingRectWithSize:CGSizeMake(widthShow, 10000000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:fontShow} context:nil].size.height;
}
+ (CGFloat)getHeightForImage:(NSString *)iamgeName
                       width:(CGFloat)widthShow
{
    
    return widthShow / [UIImage imageNamed:iamgeName].size.width  * [UIImage imageNamed:iamgeName].size.height;
}

// 返回沙盒 缓存数据 的大小
+ (float)howBigCachesSizeFromApp
{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 子路径
    NSString *rootPath = [NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()] ;
    NSArray *array = [manager subpathsAtPath:rootPath];
    // 遍历子路径
    float fileSize = 0.0;
    for (NSString *subPath in array)
    {
        // 找到子路径的
        NSString *subPathStr = [rootPath stringByAppendingPathComponent:subPath];
        
        BOOL result = 0;
        [manager fileExistsAtPath:subPathStr isDirectory:&result];
        if (result == 0)
        {
            
            NSDictionary *attr = [manager attributesOfItemAtPath:subPathStr error:nil];
            fileSize += [attr[NSFileSize] floatValue];
        }
    }
    
    return fileSize / 1000.0 / 1000.0;
}


// 单个文件的大小
+ (float)oneFileSize:(NSString *)filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        // 字典的字节数
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 清除缓存
+ (void)clearAppFile
{
    
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 子路径
    NSError *error = nil;
    
    [manager removeItemAtPath:[NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()] error:&error];
    
    NSLog(@"clearAppFile------>NSHomeDirectory()-->%@",[NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()] );
    
}
// 清除缓存  缓存文件夹中的所有子文件
+ (void)clearCachesAppFile
{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 子路径
    NSString *rootPath = [NSString stringWithFormat:@"%@/Library/Caches",NSHomeDirectory()] ;
    NSArray *array = [manager subpathsAtPath:rootPath];
    // 遍历子路径
    for (NSString *subPath in array)
    {
        // 找到子路径的
        NSString *subPathStr = [rootPath stringByAppendingPathComponent:subPath];
        [manager removeItemAtPath:subPathStr error:nil];
  
    }
    
}




@end
