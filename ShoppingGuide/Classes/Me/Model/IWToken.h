//
//  IWToken.h
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/3/31.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWToken : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;

+ (instancetype)tokenWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
