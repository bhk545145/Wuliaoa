//
//  IWSettingValueItem.m
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWSettingValueItem.h"

@implementation IWSettingValueItem
- (NSString *)key
{
    return _key ? _key : self.title;
}
@end