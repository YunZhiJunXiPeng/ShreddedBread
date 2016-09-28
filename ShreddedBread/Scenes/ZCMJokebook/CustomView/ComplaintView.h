//
//  ComplaintView.h
//  ShreddedBread
//
//  Created by BoonZ on 16/9/4.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SendBlock)();


@interface ComplaintView : UIView


@property (copy, nonatomic) SendBlock sendBlock;



@end
