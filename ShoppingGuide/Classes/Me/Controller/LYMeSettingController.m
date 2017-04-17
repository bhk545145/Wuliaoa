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

@interface LYMeSettingController ()<UITableViewDataSource, UITableViewDelegate>{
    dispatch_queue_t queue;
}
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation LYMeSettingController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("latiaoQueue", DISPATCH_QUEUE_CONCURRENT);
    [self setupTableView];
    
}
// 初始化TableView
- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UITableView *)tableView {
    
    if(!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.frame = self.view.bounds;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"shezhi";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = @"清除缓存";
    cell.imageView.image = [UIImage imageNamed:@"latiao"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self removeSDImageCache];
    }else if(indexPath.row == 1){
        
    }
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
