//
//  GetHeightTool.h
//  GetHeightTool
//
//  Created by 小超人 on 16/6/15.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> //这个框架要引入因为我们要用这些类


@interface GetHeightTool : NSObject

+ (CGFloat)getHeightForText:(NSString *)textShow
                       font:(UIFont *)fontShow
                      width:(CGFloat)widthShow;
+ (CGFloat)getHeightForImage:(NSString *)iamgeName
                       width:(CGFloat)widthShow;

// 返回沙盒 缓存数据 的大小
+ (float)howBigCachesSizeFromApp;
// 清除缓存  缓存文件夹中的所有子文件
+ (void)clearCachesAppFile;
// 清除缓存
+ (void)clearAppFile;
@end
