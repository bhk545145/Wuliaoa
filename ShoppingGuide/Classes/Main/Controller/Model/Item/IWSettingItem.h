//
//  IWSettingItem.h
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^IWSettingItemOption)();

@interface IWSettingItem : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) IWSettingItemOption option;
@property (copy, nonatomic) NSString *badgeValue;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;
+ (instancetype)item;
@end
