//
//  IWSettingSwitchItem.m
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWSettingSwitchItem.h"

@implementation IWSettingSwitchItem

- (id)init
{
    if (self = [super init]) {
        self.defaultOn = YES;
    }
    return self;
}

- (BOOL)isOn
{
    id value = [IWUserDefaults objectForKey:self.key];
    if (value == nil) {
        return self.isDefaultOn;
    } else {
        return [value boolValue];
    }
}

- (void)setOn:(BOOL)on
{
    [IWUserDefaults setBool:on forKey:self.key];
    [IWUserDefaults synchronize];
}
@end
