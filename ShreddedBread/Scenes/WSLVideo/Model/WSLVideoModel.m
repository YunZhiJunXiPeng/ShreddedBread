//
//  WSLVideoModel.m
//  ShreddedBread
//
//  Created by lanou3g on 16/8/15.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "WSLVideoModel.h"
#import "UserModel.h"

@implementation WSLVideoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
   
    
    if ([key isEqualToString:@"user"]) {
        

       // NSLog(@"--WSLVideoModel key---user-%@--value->%@",key,value);

        self.userJ = [UserModel new];
        
        [self.userJ setValuesForKeysWithDictionary:(NSDictionary *)value];
    

       // NSLog(@"---------userJ-->%@",self.userJ.icon);

        
    }
   
}


- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@", self.content];
    
}

@end
