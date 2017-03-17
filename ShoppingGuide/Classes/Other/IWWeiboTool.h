//
//  IWWeiboTool.h
//  ItcastWeibo
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  微博项目的工具类

#import <Foundation/Foundation.h>

@interface IWWeiboTool : NSObject
/**
 *  选择根控制器
 */
+ (void)chooseRootController;

+ (void)chooseTabBarController;

/**
 *  判断手机类型
 */
+ (NSString *)iphoneType;
@end
