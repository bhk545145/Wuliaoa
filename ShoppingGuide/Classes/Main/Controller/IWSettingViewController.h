//
//  IWSettingViewController.h
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IWSettingGroup;

@interface IWSettingViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *groups;

- (IWSettingGroup *)addGroup;
@end
