//
//  IWToken.m
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/3/31.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import "IWToken.h"

@implementation IWToken
+ (instancetype)tokenWithDict:(NSDictionary *)dict
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

        self.id = [decoder decodeObjectForKey:@"id"];
        self.userId = [decoder decodeObjectForKey:@"userId"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{

    [encoder encodeObject:self.id forKey:@"id"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.token forKey:@"token"];
    [encoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    
}
@end
