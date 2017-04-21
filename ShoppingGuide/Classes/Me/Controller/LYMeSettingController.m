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
    
    IWSettingItem *removeCache = [IWSettingItem itemWithIcon:@"removeCache" title:@"清除缓存"];
    removeCache.option = ^{
        [self removeSDImageCache];
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
    dispatch_async(queue, ^{
        [[SDImageCache sharedImageCache] clearDisk];
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"清除成功"];
    });
}
@end
