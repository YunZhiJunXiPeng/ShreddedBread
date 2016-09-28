//
//  JSDropDownMenu.h
//  JSDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface JSIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger leftOrRight;
@property (nonatomic, assign) NSInteger leftRow;
@property (nonatomic, assign) NSInteger row;

//两种初始化方法
- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

@end


#pragma mark - data source protocol
@class JSDropDownMenu;

@protocol JSDropDownMenuDataSource <NSObject>

@required
//numberOfRows
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;

//titleForRow
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath;
//titleForColumn
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column;

/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;
/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;



@optional
//numberOfColumn---> default value is 1
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol JSDropDownMenuDelegate <NSObject>

@optional
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath;
@end

#pragma mark - interface
@interface JSDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <JSDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <JSDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UITableView *leftTableView;
@property (strong, nonatomic) NSString *currentYear;
/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)hetigh andWidth:(CGFloat)width;

- (NSString *)titleForRowAtIndexPath:(JSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


//定位到指定的cell
- (void)selectIndex:(NSInteger)index;


@end
