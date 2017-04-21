//
//  IWSettingCell.h
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWBgCell.h"

@class IWSettingItem;

@interface IWSettingCell : IWBgCell
@property (strong, nonatomic) IWSettingItem *item;
@property (strong, nonatomic) NSIndexPath *indexPath;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
