//
//  LYMeController.m
//  ShoppingGuide
//
//  Created by coderLL on 16/9/1.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import "LYMeController.h"
#import "LYLikeCell.h"
#import "LYItem.h"
#import "IWStatus.h"
#import "LYNetworkTool.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "LYMineHeaderView.h"
#import "LYMineFooterView.h"
#import "LYMineChoiceBar.h"
#import "LYMeSettingController.h"
#import "LYMeMessageController.h"
#import "MRNavigationController.h"
#import "LYLoginViewController.h"
#import "LYEditInfoViewController.h"
#import "LYDetailController.h"
#import "LYProductDetailController.h"
#import "IWAccountTool.h"
#import "IWAccount.h"
#import "UIImageView+AFNetworking.h"
#import "LYChannelController.h"
#import "SVProgressHUD.h"


@interface LYMeController ()<UITableViewDataSource, UITableViewDelegate, LYMineHeaderDelegate, LYMineChoiceBarDelegate>{
    dispatch_queue_t queue;
}

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) LYMineHeaderView *headerView;

@property (nonatomic, strong) LYMineFooterView *footerView;

@property (nonatomic, strong) LYMineChoiceBar *choiceBar;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSArray *themes;

@property (nonatomic, strong) NSArray *products;

@property (nonatomic, assign) NSInteger type;

@end

static NSString * const likeThemeCellID = @"likeThemeCellID";

@implementation LYMeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.headerView changeStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("latiaoQueue", DISPATCH_QUEUE_CONCURRENT);
    self.tableView.backgroundColor = IWColor(220, 220, 220);
    [self setupTableView];
    // 注册登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LYLoginNotification" object:nil];
    // 注册点赞专题的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeTheme:) name:@"LYThemeLikeNotification" object:nil];
    // 注册点赞商品的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeProduct:) name:@"LYProductLikeNotification" object:nil];
}

// 初始化TableView
- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 检测登录状态
    [self inspectStatus];
}

// 懒加载用户喜欢商品
- (NSArray *)themes {
    
    if(!_themes) {
        NSArray *themes = [NSArray array];
        _themes = themes;
    }
    
    return _themes;
}

// 懒加载用户喜欢专题
- (NSArray *)products {
    
    if(!_products) {
        NSArray *products = [NSArray array];
        _products = products;
    }
    
    return _products;
}

- (LYMineHeaderView *)headerView {
    
    if(!_headerView) {
        LYMineHeaderView *view = [[LYMineHeaderView alloc] init];
        view.delegate = self;
        view.frame = CGRectMake(0, 0, MRScreenW, 200);
        _headerView = view;
    }
    
    return _headerView;
}

- (LYMineFooterView *)footerView {
    
    if(!_footerView) {
        LYMineFooterView *view = [[LYMineFooterView alloc] init];
        view.frame = CGRectMake(0, 0, MRScreenW, 240);
        _footerView = view;
    }
    
    return _footerView;
}

- (LYMineChoiceBar *)choiceBar {
    
    if(!_choiceBar) {
        
        LYMineChoiceBar *bar = [[LYMineChoiceBar alloc] init];
        bar.frame = CGRectMake(0, 0, MRScreenW, 42);
        bar.delegate = self;
        _choiceBar = bar;
    }
    
    return _choiceBar;
}

- (UITableView *)tableView {
    
    if(!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.frame = self.view.bounds;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LYLikeCell class]) bundle:nil] forCellReuseIdentifier:likeThemeCellID];
        tableView.tableHeaderView = self.headerView;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    
    return _tableView;
}

// 请求用户喜欢的专题和商品
- (void)loadLikeLoad {
    __weak typeof(self) weakSelf = self;
    weakSelf.products = [NSArray arrayWithObjects:@"我的辣条",@"清除缓存", nil];
//    IWAccount *account = [IWAccountTool account];
//    // 喜欢的商品
//    NSString *tailURL = [NSString stringWithFormat:@"/timeline/1/100?authorId=%@",account.id];
//    NSString *productURL = [IWArticleURL stringByAppendingString:tailURL];
//    [[LYNetworkTool sharedNetworkTool] loadDataInfo:productURL parameters:nil success:^(id  _Nullable responseObject) {
//        NSArray *products = [IWStatus mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
//        weakSelf.products = products;
//        // 刷新表格数据
//        [weakSelf.tableView reloadData];
//    } failure:^(NSError * _Nullable error) {
//        
//    }];
    
    // 喜欢的专题
//    NSString *themeURL = @"http://api.dantangapp.com/v1/users/me/post_likes?limit=20&offset=0";
//    [[LYNetworkTool sharedNetworkTool] loadDataInfo:themeURL parameters:nil success:^(id  _Nullable responseObject) {
//        NSArray *themes = [LYItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"posts"]];
//        weakSelf.themes = themes;
//        // 刷新表格数据
//        [weakSelf.tableView reloadData];
//    } failure:^(NSError * _Nullable error) {
//        
//    }];
}

- (void)headerMessageClick:(UIButton *)btn {
    // 创建消息中心的控制器
    LYMeMessageController *messageVc = [[LYMeMessageController alloc] init];
    messageVc.title = @"消息中心";
    [self.navigationController pushViewController:messageVc animated:YES];
}

- (void)headerIconClick:(UIButton *)btn {
    
     __weak typeof(self) weakSelf = self;
    
    // 判断是否登录
    IWAccount *account = [IWAccountTool account];
    if(account) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *editAc = [UIAlertAction actionWithTitle:@"编辑资料" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf editInfo];
        }];
        UIAlertAction *loginOut = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // 清空数据
            [IWAccountTool deleteFiel];
            weakSelf.products = nil;
            weakSelf.themes = nil;
            weakSelf.type = 0;
            [weakSelf.headerView changeStatus];
            [weakSelf inspectStatus];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertVc dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertVc addAction:editAc];
        [alertVc addAction:loginOut];
        [alertVc addAction:cancel];
        [self.navigationController presentViewController:alertVc animated:YES completion:nil];
    }else {
        LYLoginViewController *loginVc = [[LYLoginViewController alloc] init];
        loginVc.block = ^(LYUser *user) {


            // 登录成功重新请求数据以及刷新视图
            [weakSelf loadLikeLoad];
            [weakSelf inspectStatus];
        };
        
        MRNavigationController *loginNav = [[MRNavigationController alloc] initWithRootViewController:loginVc];
        [self.navigationController presentViewController:loginNav animated:YES completion:nil];
    }
}

// 编辑资料
- (void)editInfo {
    LYEditInfoViewController *editVc = [[LYEditInfoViewController alloc] init];
    IWAccount *account = [IWAccountTool account];
    editVc.imageURL = account.avatar;
    NSString *name = account.nickname;
    editVc.name = name;
    MRNavigationController *nav = [[MRNavigationController alloc] initWithRootViewController:editVc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

// 根据登录状态判断是否显示footerView
- (void)inspectStatus {
    dispatch_async(queue, ^{
        IWAccount *account = [IWAccountTool account];
        if(account) {
            // 刷新收藏
            [self loadLikeLoad];
            self.tableView.tableFooterView = nil;
        }else {
            self.tableView.tableFooterView = self.footerView;
        }
        [self.tableView reloadData];
    });
    
}

// 拖动监听
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentSetY = scrollView.contentOffset.y;
    if(contentSetY < 0) {
        CGRect tempFrame = self.headerView.bgImageView.frame;
        tempFrame.origin.y = contentSetY;
        tempFrame.size.height = 200 - contentSetY;
        self.headerView.bgImageView.frame = tempFrame;
        CGFloat scale = 1 - ((contentSetY + 20) / 240.0);
        self.headerView.iconButton.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

// 登录成功回调刷新用户信息
- (void)loginSuccess {
    // 刷新列表数据
    [self.headerView changeStatus];
    [self loadLikeLoad];
    [self inspectStatus];
}

// 专题点赞通知回调
- (void)likeTheme:(NSNotification *)notif {
    
    // 重新请求数据
    [self loadLikeLoad];
}

// 商品点赞通知回调
- (void)likeProduct:(NSNotification *)notif {
    // 重新请求数据
    [self loadLikeLoad];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.choiceBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.type == 0) {
        return 41;
    }else {
        return 60;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.type == 0) {
        return self.products.count;
    }else {
        return self.themes.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LYLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:likeThemeCellID];
    
     if(self.type == 0) {
        cell.status = self.products[indexPath.row];
         
     }else {
        cell.item = self.themes[indexPath.row];
     }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(self.type == 0) {
        if (indexPath.row == 0) {
            LYChannelController *vc = [[LYChannelController alloc] init];
            vc.channesID = 4;
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1){
            [self removeSDImageCache];
        }
        
    }else {
//        LYDetailController *vc = [[LYDetailController alloc] init];
//        vc.item = self.themes[indexPath.row];
//        [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark - <LYMineChoiceBarDelegate>

- (void)choiceBarClick:(NSInteger)index {
    self.type = index;
    [self.tableView reloadData];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}


- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LYLoginNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LYThemeLikeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LYProductLikeNotification" object:nil];
}

@end
