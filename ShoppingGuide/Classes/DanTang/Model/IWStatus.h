//
//  IWStatus.h
//  ItcastWeibo
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  微博模型(一个IWStatus对象就代表一条微博)

#import <Foundation/Foundation.h>
@class IWUser;

@interface IWStatus : NSObject

/**
 *  作者名称
 */
@property (nonatomic, copy) NSString *authorName;
/**
 *  作者头像
 */
@property (nonatomic, copy) NSString *authorAvatar;
/**
 *  段子的内容
 */
@property (nonatomic, copy) NSString *content;

/**
 *  段子的时间
 */
@property (nonatomic, copy) NSString *createTime;
/**
 *  段子的ID
 */
@property (nonatomic, copy) NSString *id;
/**
 *  无聊图的配图(数组中装模型:IWPhoto)
 */
@property (nonatomic, strong) NSArray *images;
/**
 *  无聊图的评论数
 */
@property (nonatomic, assign) int commentCount;
/**
 *  无聊图的表态数(被赞数)
 */
@property (nonatomic, assign) int likeCount;
/**
 *  无聊图的被踩数
 */
@property (nonatomic, assign) int hateCount;
/**
 *  发无聊图的设备
 */
@property (nonatomic, copy) NSString *device;





/**
 *  微博的内容(文字)
 */
//@property (nonatomic, copy) NSString *text;
/**
 *  微博的来源
 */
//@property (nonatomic, copy) NSString *source;
/**
 *  微博的时间
 */
//@property (nonatomic, copy) NSString *created_at;
/**
 *  微博的ID
 */
//@property (nonatomic, copy) NSString *idstr;
/**
 *  微博的配图(数组中装模型:IWPhoto)
 */
//@property (nonatomic, strong) NSArray *pic_urls;
//@property (nonatomic, copy) NSString *thumbnail_pic;

/**
 *  微博的转发数
 */
@property (nonatomic, assign) int reposts_count;
/**
 *  微博的评论数
 */
//@property (nonatomic, assign) int comments_count;
/**
 *  微博的表态数(被赞数)
 */
//@property (nonatomic, assign) int attitudes_count;

/**
 *  微博的作者
 */
//@property (nonatomic, strong) IWUser *user;
/**
 *  被转发的微博
 */
@property (nonatomic, strong) IWStatus *retweeted_status;

+ (NSDictionary *)objectClassInArray;
@end
