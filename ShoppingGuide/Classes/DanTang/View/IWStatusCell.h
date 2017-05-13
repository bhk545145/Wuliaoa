//
//  IWStatusCell.h
//  ItcastWeibo
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  展示微博的cell

#import <UIKit/UIKit.h>
#import "IWStatusTopView.h"
@class IWStatusFrame;
@class IWStatusToolbar;
@interface IWStatusCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) IWStatusFrame *statusFrame;
/** 微博的工具条 */
@property (nonatomic, weak) IWStatusToolbar *statusToolbar;
/** 顶部的view */
@property (nonatomic, weak) IWStatusTopView *topView;
@end
