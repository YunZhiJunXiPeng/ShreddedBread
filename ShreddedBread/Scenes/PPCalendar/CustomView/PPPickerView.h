//
//  PPPickerView.h
//  ShreddedBread
//
//  Created by 小超人 on 16/8/16.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendValueBlock)(NSString *sendValue);

@interface PPPickerView : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (copy, nonatomic)SendValueBlock sendValueBlock;

- (instancetype)initWithFrame:(CGRect)frame
                        array:(NSMutableArray *)array;



@end
