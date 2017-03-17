//
//  IWAccount.h
//  ItcastWeibo
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  帐号模型

#import <Foundation/Foundation.h>



@interface IWAccount : NSObject <NSCoding>
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *status;





+ (instancetype)accountWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
