//
//  JJLineView.h
//  ShreddedBread
//
//  Created by BoonZ on 16/8/15.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PNChart.h>

@interface JJLineView : UIView

@property (strong, nonatomic) PNLineChart *lineChart;
@property (strong, nonatomic) PNBarChart *barChart;

- (void)setView;


@end
