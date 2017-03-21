//
//  IWCommit.h
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/3/20.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWCommit : NSObject

/**
 *  评论id
 */
@property (nonatomic, copy) NSString *id;
/**
 *  用户头像
 */
@property (nonatomic, copy) NSString *userAvatar;
/**
 *  辣条id
 */
@property (nonatomic, copy) NSString *articleId;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *userId;
/**
 *  用户名称
 */
@property (nonatomic, copy) NSString *userName;
/**
 *  评论评论数
 */
@property (nonatomic, copy) NSString *commentCount;
/**
 *  评论内容
 */
@property (nonatomic, copy) NSString *content;
@end
