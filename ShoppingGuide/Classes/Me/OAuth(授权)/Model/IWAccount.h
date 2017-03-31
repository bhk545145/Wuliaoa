//
//  IWAccount.h
//  ItcastWeibo
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  帐号模型

#import <Foundation/Foundation.h>

@interface user : NSObject
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
@end

@interface token : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;
@end

@interface IWAccount : NSObject <NSCoding>
@property (nonatomic, strong) user *user;
@property (nonatomic, strong) token *token;

+ (instancetype)accountWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end


//token =     {
//    id = 847440622468988928;
//    refreshToken = "1cafa912-3467-49ea-afa1-622ef88fd03e";
//    token = "3be3617b-06c1-4add-bae7-2cace773b3db";
//    userId = 6;
//};
//user =     {
//    avatar = "http://wuliaoa.bj.bcebos.com/873787836443597959.jpg";
//    createTime = "2017-02-01 18:57:51";
//    email = "<null>";
//    id = 6;
//    nickname = "\U5c0f\U767d";
//    password = 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92;
//    phone = 13567165451;
//    sex = 0;
//    status = 1;
//    type = "<null>";
//    updateTime = "2017-03-24 11:37:29";
//};
