//
//  IWSettingLabelItem.h
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWSettingValueItem.h"

@interface IWSettingLabelItem : IWSettingValueItem
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *defaultText;
@end
