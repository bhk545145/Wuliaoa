//
//  IWAccount.m
//  ItcastWeibo
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWAccount.h"

@implementation IWAccount
+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

/**
 *  从文件中解析对象的时候调
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.user = [decoder decodeObjectForKey:@"user"];
        self.token = [decoder decodeObjectForKey:@"token"];
//        self.user.nickname = [decoder decodeObjectForKey:@"nickname"];
//        self.user.id = [decoder decodeObjectForKey:@"id"];
//        self.user.phone = [decoder decodeObjectForKey:@"phone"];
//        self.user.email = [decoder decodeObjectForKey:@"email"];
//        self.user.password = [decoder decodeObjectForKey:@"password"];
//        self.user.sex = [decoder decodeObjectForKey:@"sex"];
//        self.user.avatar = [decoder decodeObjectForKey:@"avatar"];
//        self.user.type = [decoder decodeObjectForKey:@"type"];
//        self.user.status = [decoder decodeObjectForKey:@"status"];
//        
//        self.token.id = [decoder decodeObjectForKey:@"id"];
//        self.token.userId = [decoder decodeObjectForKey:@"userId"];
//        self.token.token = [decoder decodeObjectForKey:@"token"];
//        self.token.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.user forKey:@"user"];
    [encoder encodeObject:self.token forKey:@"token"];
//    [encoder encodeObject:self.user.id forKey:@"id"];
//    [encoder encodeObject:self.user.phone forKey:@"phone"];
//    [encoder encodeObject:self.user.email forKey:@"email"];
//    [encoder encodeObject:self.user.password forKey:@"password"];
//    [encoder encodeObject:self.user.sex forKey:@"sex"];
//    [encoder encodeObject:self.user.avatar forKey:@"avatar"];
//    [encoder encodeObject:self.user.type forKey:@"type"];
//    [encoder encodeObject:self.user.status forKey:@"status"];
//    
//    [encoder encodeObject:self.token.id forKey:@"id"];
//    [encoder encodeObject:self.token.userId forKey:@"userId"];
//    [encoder encodeObject:self.token.token forKey:@"token"];
//    [encoder encodeObject:self.token.refreshToken forKey:@"refreshToken"];

}
@end
