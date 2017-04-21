//
//  IWBgCell.h
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  有背景的cell

#import <UIKit/UIKit.h>

@interface IWBgCell : UITableViewCell
@property (weak, nonatomic) UIImageView *bg;
@property (weak, nonatomic) UIImageView *selectedBg;
@end
