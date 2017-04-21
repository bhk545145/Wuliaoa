//
//  IWSettingCheckItem.h
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWSettingItem.h"

@interface IWSettingCheckItem : IWSettingItem
@property (assign, nonatomic, getter = isChecked) BOOL checked;
@end
