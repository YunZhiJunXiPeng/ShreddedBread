//
//  PPPickerView.m
//  ShreddedBread
//
//  Created by 小超人 on 16/8/16.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "PPPickerView.h"

@interface PPPickerView ()
//  传入一个参数
@property (strong, nonatomic) NSMutableArray *sourceDataArray;

@property (assign, nonatomic) BOOL clearSeparator;
@end

@implementation PPPickerView



- (instancetype)initWithFrame:(CGRect)frame
                        array:(NSMutableArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        self.backgroundColor =  [UIColor whiteColor];
        self.sourceDataArray = [NSMutableArray new];
        self.sourceDataArray = array;
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.sourceDataArray.count;
}


#pragma mark ------>> 返回内容 <<------
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (!_clearSeparator)
    {// 清除 pickerView 的线
        [UIView clearSeparatorWithView:pickerView];
        _clearSeparator = YES;
        NSLog(@"判断%d",_clearSeparator);
    }
    
    UILabel *label = [UILabel new];
    label.text = self.sourceDataArray[row];
    label.textAlignment = NSTextAlignmentCenter;
    
    return  label;
}

#pragma mark ------>> 选中传值 <<------
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *tempLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
    [UIView animateWithDuration:0.2 animations:^{
        tempLabel.textColor = [UIColor redColor];
        tempLabel.font = [UIFont systemFontOfSize:30];
    }];
    self.sendValueBlock(self.sourceDataArray[row]);
}




@end
