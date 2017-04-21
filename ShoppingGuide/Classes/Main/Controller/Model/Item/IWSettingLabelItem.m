//
//  IWSettingLabelItem.m
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWSettingLabelItem.h"

@implementation IWSettingLabelItem
- (NSString *)text
{
    id value = [IWUserDefaults objectForKey:self.key];
    if (value == nil) {
        return self.defaultText;
    } else {
        return value;
    }
}

- (void)setText:(NSString *)text
{
    [IWUserDefaults setObject:text forKey:self.key];
    [IWUserDefaults synchronize];
}
@end
