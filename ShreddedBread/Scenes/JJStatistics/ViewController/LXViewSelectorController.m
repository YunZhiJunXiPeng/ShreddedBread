//
//  LXViewSelectorController.m
//  ViewSelector
//
//  Created by XiaoleiLi on 16/8/8.
//  Copyright © 2016年 leehyoley. All rights reserved.
//

#import "LXViewSelectorController.h"

#import "JJLineView.h"
#import "JJCircleView.h"


#import "PPFMDBdataHandle.h"


@interface LXViewSelectorController ()

@property (nonatomic,strong)NSMutableArray *views;  //子视图数组
@property (nonatomic,strong)NSMutableArray *titles; //子视图标题数组

@property (nonatomic,strong)UIView *selectorView;   //子视图选择容器
@property (nonatomic,strong)UIView *showView;  //子视图内容显示容器

@property (nonatomic,strong)NSArray<UIButton*> *titleButtons;//标题按钮

@property (nonatomic,strong)UIView *tipView;//位置提示条(下面的线条)


@property (strong,nonatomic) NSArray *originArray;

//自定义的统计视图
@property (strong, nonatomic) JJLineView *lineView;
@property (strong, nonatomic) JJCircleView *circleView;

@end

@implementation LXViewSelectorController

//视图数据源数组懒加载
- (NSMutableArray *)views{
    
    if (_views == nil) {
        
        _views = [NSMutableArray array];
    }
    return _views;
}

//标题数据源数组懒加载
- (NSMutableArray *)titles{
    
    if (_titles == nil) {
        
        _titles = [NSMutableArray array];
    }
    return _titles;
}


//初始化滑动的子视图
- (void)loadCustomView{

    self.lineView = [[JJLineView alloc] initWithFrame:[UIScreen mainScreen].bounds];//  一周记录
    
    self.circleView = [[JJCircleView alloc] initWithFrame:[UIScreen mainScreen].bounds];//  一月记录

    [self.views addObject:self.lineView];
    [self.views addObject:self.circleView];
    
    [self.titles addObject:@"本周记录"];
    [self.titles addObject:@"本月记录"];
    
    
    //默认
    self.fontSize = 16;
    self.tipSize = CGSizeMake(60, 2);
    self.normalColor = [UIColor blackColor];
    self.selectedColor = [UIColor redColor];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

//重点注意(页面数据更新)
    [self.lineView setView];
    [self.circleView setView];
    
 
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //调用加载子视图方法
    [self loadCustomView];
    
    
    //添加平移手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    [self.view addGestureRecognizer:pan];
    
    //导航条
    self.selectorView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, jjScreenWidth,jjcreenHeight / 15)];
    self.selectorView.backgroundColor = [UIColor colorWithRed:0.605 green:0.896 blue:0.885 alpha:1.000];
  
    //子视图内容显示容器
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectorView.frame), jjScreenWidth, jjcreenHeight - self.selectorView.frame.size.height)];

    self.showView.backgroundColor = [UIColor colorWithWhite:0.946 alpha:1.000];
    
    //标题数组(button)
    NSMutableArray<UIButton*> *buttons = [NSMutableArray array];
    
    for (int i=0; i<self.views.count; i++) { //根据子视图数组个数, 加载视图
        
        //将子视图添加到展示视图上
        UIView *view = self.views[i];
        
        //根据宽度偏移位置
        view.frame = CGRectMake(i*self.showView.bounds.size.width, 0, self.showView.bounds.size.width, self.showView.bounds.size.height);
        [self.showView addSubview:view];
        
        //根据标题个数, 处理button的frame
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*(self.selectorView.bounds.size.width/self.views.count), 0, self.selectorView.bounds.size.width/self.views.count, 44)];
        button.tag = i;
        [button.titleLabel setFont:[UIFont systemFontOfSize:self.fontSize]];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        [button setTitleColor:i==0?self.selectedColor:self.normalColor forState:UIControlStateNormal]; //默认选中第一个
        [button addTarget:self action:@selector(didClickItem:) forControlEvents:UIControlEventTouchUpInside];  //给标题button添加方法
        [buttons addObject:button];
        [self.selectorView addSubview:button];
        
    }

    
    self.titleButtons = [NSArray arrayWithArray:buttons];
    
    //title下面的横条
    self.tipView = [[UIView alloc] initWithFrame:CGRectMake(0, self.selectorView.bounds.size.height-2, 60, 2)];
    self.tipView.center = CGPointMake(self.titleButtons[0].center.x, self.tipView.center.y);
    self.tipView.backgroundColor = [UIColor redColor];
    [self.selectorView addSubview:self.tipView];
    
    
//该实体由两部分组成
    [self.view addSubview:self.selectorView];
    [self.view addSubview:self.showView];
   
}


- (void)handlePan:(UIPanGestureRecognizer *)sender {
    
    //计算平移的偏移量
    CGPoint point = [sender translationInView:self.showView];
    
    //计算移动的速度
    CGPoint poi = [sender velocityInView:self.showView];
    
    CGFloat x = self.showView.bounds.origin.x; // 2倍的宽度
    
    if (fabs(point.x)>fabs(point.y)) {
        
        x-=point.x;  // 总的宽度 - 滑动的距离
        
        if (x>=0&&x<=self.showView.bounds.size.width*(self.views.count-1)) {
            
            [self setAnimationWithOrigin:x];
        }
    }
    
    
    if (sender.state==UIGestureRecognizerStateEnded) {  //手指已离开屏幕，手势结束
        
        //poi为速度，point是位移
        //位移超过一半或者滑动结束时速度大于300就翻页，否则还原
        if (poi.x>300) {
            
            int count = (int)x/(int)self.showView.bounds.size.width;
            if (count>0) {
                x = self.showView.bounds.size.width*count;
            }else{
                x = 0;
            }
        }else if(poi.x<-300){
            int count = (int)x/(int)self.showView.bounds.size.width;
            if (count<self.views.count-1) {
                x = self.showView.bounds.size.width*(count+1);
            }else{
                x = self.showView.bounds.size.width*(self.views.count-1);
            }
        }else{
            int count = (int)x/(int)self.showView.bounds.size.width;
            int deviation = (int)x%(int)self.showView.bounds.size.width;
            if (deviation<self.showView.bounds.size.width/2) {
                x = count*self.showView.bounds.size.width;
            }else if(count<self.views.count-1){
                x = count*self.showView.bounds.size.width;
            }else{
                x = (self.views.count-1)*self.showView.bounds.size.width;
            }
            
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setAnimationWithOrigin:x];
        }];
    }
    
    //清零(否则过度效果有瑕疵)
    [sender setTranslation:CGPointMake(0, 0) inView:self.showView];
    
}


-(void)didClickItem:(UIButton*)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setAnimationWithOrigin:self.showView.bounds.size.width*sender.tag];  //根据button的 tag值 + 宽度, 求偏移量
    }];
}
//根据bound偏移量，调整位置
-(void)setAnimationWithOrigin:(CGFloat)x{
    
    self.showView.bounds = CGRectMake(x, self.showView.bounds.origin.y,self.showView.bounds.size.width, self.showView.bounds.size.height);
    
    CGFloat tipX = self.selectorView.bounds.size.width/(self.views.count*2)+(x/(self.selectorView.bounds.size.width*(self.views.count-1)))*self.selectorView.bounds.size.width/(self.views.count)*(self.views.count-1);
    
    self.tipView.center=CGPointMake(tipX, self.tipView.center.y);
    
    [self.originArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      
        if ((int)tipX==[obj intValue]) {
            
            [self selectTitleAt:idx];
        }
        
    }];
    
}

//改变位置时, 更新button字体的颜色
-(void)selectTitleAt:(NSInteger)index{
    
    for (int i =0; i<self.titleButtons.count; i++) {
        
        UIButton *button = self.titleButtons[i];
        
        [button setTitleColor:i==index?self.selectedColor:self.normalColor forState:UIControlStateNormal];
    }
}

-(NSArray *)originArray{
    
    if (!_originArray) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        
        for (int i=0; i<self.views.count; i++) {
            
            [tempArr addObject:@(self.selectorView.bounds.size.width/(self.views.count*2)+self.selectorView.bounds.size.width*i/self.views.count)];
        }
        _originArray = [NSArray arrayWithArray:tempArr];
        
    }
    
    return _originArray;
}






@end
