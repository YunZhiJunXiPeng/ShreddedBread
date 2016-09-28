//
//  JJNetWorkRequst.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/16.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJNetWorkRequst : NSObject



/* 请求数据
 * @url ：请求数据的url
 * @parameterDic ：成功回调的block
 * @success ：成功的回调
 * @failure ：失败的回调
 */
+ (void)requestWithUrl:(NSString *)url
            parameters:(NSDictionary *)parameterDic
       successResponse:(void(^)(NSDictionary *dic))success
       failureResponse:(void(^)(NSError *error))failure;




@end
