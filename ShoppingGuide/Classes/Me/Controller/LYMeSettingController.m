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
#import "LBClearCacheTool.h"

#define filePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
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
    [SVProgressHUD showWithStatus:@"正在清除缓存"];
    [[SDImageCache sharedImageCache] clearDisk];
    BOOL isSuccess = [LBClearCacheTool clearCacheWithFilePath:[NSString stringWithFormat:@"%@",filePath]];
    if(isSuccess){
        [SVProgressHUD showSuccessWithStatus:@"清除成功"];
    }else{
        [SVProgressHUD showErrorWithStatus:@"清除失败"];
    }
    
    IWLog(@"%@",[self getSDImageCacheSize]);
}

//获取缓存
- (NSString *)getSDImageCacheSize{
    NSString *SDImageCacheSize = [LBClearCacheTool getCacheSizeWithFilePath:[NSString stringWithFormat:@"%@",filePath]];
    return SDImageCacheSize;
}
@end
