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

        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.id = [decoder decodeObjectForKey:@"id"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.password = [decoder decodeObjectForKey:@"password"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.avatar = [decoder decodeObjectForKey:@"avatar"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.status = [decoder decodeObjectForKey:@"status"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.status forKey:@"status"];

}
@end
