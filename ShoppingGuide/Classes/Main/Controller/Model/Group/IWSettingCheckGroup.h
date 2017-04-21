//
//  IWSettingCheckGroup.h
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWSettingGroup.h"
@class IWSettingCheckItem, IWSettingLabelItem;

@interface IWSettingCheckGroup : IWSettingGroup
/**
 *  选中的索引
 */
@property (assign, nonatomic) int checkedIndex;

/**
 *  选中的item
 */
@property (strong, nonatomic) IWSettingCheckItem *checkedItem;

/**
 *  来源于哪个item
 */
@property (strong, nonatomic) IWSettingLabelItem *sourceItem;
@end
