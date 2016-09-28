//
//  JJNetWorkRequst.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/16.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/**
 *  这是自定义的网络请求类  关于网络的问题方法尽量写在这里
 *
 *  @return 数据通过 Block 的方式返回使用
 */

#import "JJNetWorkRequst.h"


@implementation JJNetWorkRequst



// GET 方法
#pragma mark ------>> 数据请求的方法直接使用就可以 <<------

+ (void)requestWithUrl:(NSString *)url
            parameters:(NSDictionary *)parameterDic
       successResponse:(void(^)(NSDictionary *dic))success
       failureResponse:(void(^)(NSError *error))failure
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
// 开始请求
    [manager GET:url parameters:parameterDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject); // 注册成功的 Block 携带参数回去使用
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error); // 注册失败的 Block 携带错误信息
    }];


}




@end
