//
//  LYMeSettingController.m
//  ShoppingGuide
//
//  Created by coderLL on 16/9/18.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import "LYMeSettingController.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "IWSettingArrowItem.h"
#import "IWSettingLabelItem.h"
#import "IWSettingGroup.h"
#import "IWAboutMeViewController.h"

@interface LYMeSettingController ()<UITableViewDataSource, UITableViewDelegate>{
    dispatch_queue_t queue;
}

@end

@implementation LYMeSettingController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("latiaoQueue", DISPATCH_QUEUE_CONCURRENT);
    [self setupGroup0];
    [self setupGroup1];
    
}

- (void)setupGroup0
{
    IWSettingGroup *group = [self addGroup];
    
    IWSettingLabelItem *removeCache = [IWSettingLabelItem itemWithIcon:@"removeCache" title:@"清除缓存"];
    removeCache.defaultText = [self getSDImageCacheSize];
    removeCache.option = ^{
        [self removeSDImageCache];
        IWSettingLabelItem *removeCache = group.items[0];
        removeCache.defaultText = [self getSDImageCacheSize];
        group.items = @[removeCache];
        
    };
    group.items = @[removeCache];
}

- (void)setupGroup1
{
    IWSettingGroup *group = [self addGroup];
    
    IWSettingArrowItem *aboutMe = [IWSettingArrowItem itemWithIcon:@"album" title:@"关于辣条" destVcClass:[IWAboutMeViewController class]];
    group.items = @[aboutMe];
}



//清除缓存
- (void)removeSDImageCache{
    [SVProgressHUD showSuccessWithStatus:@"正在清除缓存"];
    [[SDImageCache sharedImageCache] clearDisk];
    [SVProgressHUD dismiss];
    [SVProgressHUD showSuccessWithStatus:@"清除成功"];
    IWLog(@"%@",[self getSDImageCacheSize]);
}

//获取缓存
- (NSString *)getSDImageCacheSize{
    NSUInteger sizeint = [[SDImageCache sharedImageCache] getSize];
    NSString *SDImageCacheSize = [NSString stringWithFormat:@"%0.2fM",sizeint/1024.0/1024.0];
    return SDImageCacheSize;
}
@end
