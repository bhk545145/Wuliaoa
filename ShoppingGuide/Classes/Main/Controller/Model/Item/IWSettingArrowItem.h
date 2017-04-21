//
//  IWSettingArrowItem.h
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWSettingItem.h"

@class IWSettingArrowItem;

typedef void (^IWSettingArrowItemReadyForDestVc)(id item, id destVc);

@interface IWSettingArrowItem : IWSettingItem
@property (assign, nonatomic) Class destVcClass;
@property (copy, nonatomic) IWSettingArrowItemReadyForDestVc readyForDestVc;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title destVcClass:(Class)destVcClass;
@end
