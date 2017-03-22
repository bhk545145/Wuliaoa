//
//  LYChannelController.m
//  ShoppingGuide
//
//  Created by coderLL on 16/9/3.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import "LYChannelController.h"
#import "IWHomeDetailTableViewController.h"
#import "LYNetworkTool.h"
#import "LYItem.h"
#import "MJExtension.h"
#import "LYItemCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "IWStatus.h"
#import "IWStatusFrame.h"
#import "IWStatusToolbar.h"
#import "MJExtension.h"
#import "IWStatusCell.h"
#import "IWPhoto.h"


static NSString * const HomeCell = @"HomeCell";

@interface LYChannelController ()<UITableViewDelegate, UITableViewDataSource>

/**
 * 下一页的请求地址
 */
@property (nonatomic, copy) NSString *next_url;

@property (nonatomic, strong) NSMutableArray *statusFrames;

@end

@implementation LYChannelController
- (NSMutableArray *)statusFrames
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化表格
    [self setupTable];
    
    // 刷新
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewInfo) name:PROBE_DEVICES_CHANGED object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  初始化表格
 */
- (void)setupTable {
    
    self.tableView.contentInset = UIEdgeInsetsMake(LYNavBarHeight + LYTitlesViewH, 0, self.tabBarController.tabBar.mr_height, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 给表格视图添加下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewInfo)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 给表格视图添加上拉加载
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreInfo)];
}

/**
 *  请求数据
 */
- (void)loadItemInfo:(NSString *)urlString withType:(NSInteger)type{
    
    __weak typeof(self) weakSelf = self;
    
    [[LYNetworkTool sharedNetworkTool] loadDataInfo:urlString parameters:nil success:^(id  _Nullable responseObject) {
        
        // Tell MJExtension what type model will be contained in IWPhoto.
        [IWStatus mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"images" : [IWPhoto class]};
        }];
        // 将字典数组转为模型数组(里面放的就是IWStatus模型)
        NSArray *statusArray = [IWStatus mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 创建frame模型对象
        NSMutableArray *statusFrameArray = [NSMutableArray array];
        for (IWStatus *status in statusArray) {
            IWStatusFrame *statusFrame = [[IWStatusFrame alloc] init];
            // 传递微博模型数据
            statusFrame.status = status;
            [statusFrameArray addObject:statusFrame];
        }

        if(type == 0) { // 下拉刷新
            // 将最新的数据追加到旧数据的最前面
            // 旧数据: self.statusFrames
            // 新数据: statusFrameArray
            NSMutableArray *tempArray = [NSMutableArray array];
            // 添加statusFrameArray的所有元素 添加到 tempArray中
            [tempArray addObjectsFromArray:statusFrameArray];
            // 添加self.statusFrames的所有元素 添加到 tempArray中
            [tempArray addObjectsFromArray:self.statusFrames];
            weakSelf.statusFrames = tempArray;
        } else if(type == 1)  {   // 上拉加载
            // 添加新数据到旧数据的后面
            [weakSelf.statusFrames addObjectsFromArray:statusFrameArray];
        }else{      //刷新旧数据
            int i;
            int x;
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.statusFrames];
            for (x=0; x<statusFrameArray.count; x++) {
                IWStatusFrame *info = [statusFrameArray objectAtIndex:x];
                for (i=0; i<array.count; i++)
                {
                    IWStatusFrame *tmp = [array objectAtIndex:i];
                    if ([tmp.status.id isEqualToString:info.status.id])
                    {
                        [array replaceObjectAtIndex:i withObject:info];
                        break;
                    }
                }
            }
            [self.statusFrames removeAllObjects];
            [self.statusFrames addObjectsFromArray:array];
        }

        // 刷新表格
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}

/**
 *  下拉刷新
 */
- (void)loadNewInfo {
    
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"count"] = @10;
    static NSString *URLString;
    static NSString *OldURLString;
    if (self.statusFrames.count) {
        IWStatusFrame *statusFrame = self.statusFrames[0];
        // 加载ID比since_id大的微博
        params[@"sinceid"] = statusFrame.status.id;
        if (self.channesID == 1) {
            URLString = [NSString stringWithFormat:@"%@/timeline/1/100?sinceId=%@",IWArticleURL,params[@"sinceid"]];
            OldURLString = [NSString stringWithFormat:@"%@/timeline/1/100",IWArticleURL];
        }else if(self.channesID == 2){
            URLString = [NSString stringWithFormat:@"%@/timeline/1/100?sinceId=%@&type=PICTURE",IWArticleURL,params[@"sinceid"]];
            OldURLString = [NSString stringWithFormat:@"%@/timeline/1/100?type=PICTURE",IWArticleURL];
        }else{
            URLString = [NSString stringWithFormat:@"%@/timeline/1/100?sinceId=%@&type=JOKE",IWArticleURL,params[@"sinceid"]];
            OldURLString = [NSString stringWithFormat:@"%@/timeline/1/100?type=JOKE",IWArticleURL];
        }
         [self loadItemInfo:OldURLString withType:2];
    }else{
        if (self.channesID == 1) {
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@",IWArticleURL,params[@"count"]];
        }else if(self.channesID == 2){
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?type=PICTURE",IWArticleURL,params[@"count"]];
        }else{
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?type=JOKE",IWArticleURL,params[@"count"]];
        }
    }
    [self loadItemInfo:URLString withType:0];
    
    
   
    
    
}

/**
 *  上拉加载
 */
- (void)loadMoreInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"count"] = @5;
    static NSString *URLString;
    if (self.statusFrames.count) {
        IWStatusFrame *statusFrame = [self.statusFrames lastObject];
        // 加载ID <= max_id的微博
        long long maxId = [statusFrame.status.id longLongValue];
        params[@"maxId"] = @(maxId);
        
        if (self.channesID == 1) {
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?maxId=%@",IWArticleURL,params[@"count"],params[@"maxId"]];
        }else if(self.channesID == 2){
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?maxId=%@&type=PICTURE",IWArticleURL,params[@"count"],params[@"maxId"]];
        }else{
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?maxId=%@&type=JOKE",IWArticleURL,params[@"count"],params[@"maxId"]];
        }
    }else{
        
    }
    [self loadItemInfo:URLString withType:1];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.statusFrames.count;
}

// 返回对应的单元格视图
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.创建cell
    IWStatusCell *cell = [IWStatusCell cellWithTableView:tableView];
    
    // 2.传递frame模型
    cell.statusFrame = self.statusFrames[indexPath.row];
    cell.statusToolbar.btnblock = ^(){
        [self loadNewInfo];
    };
    return cell;
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IWStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return statusFrame.cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    static UIAccelerationValue _oldOffset;
    if (_oldOffset > -64) {
        if (scrollView.contentOffset.y > _oldOffset) {//如果当前位移大于缓存位移，说明scrollView向上滑动
            [UIView animateWithDuration:1.5 animations:^{
                self.tabBarController.tabBar.hidden = YES;
            }];
            
        }else{
            [UIView animateWithDuration:1.5 animations:^{
                self.tabBarController.tabBar.hidden = NO;
            }];
        }
    }
    
    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IWHomeDetailTableViewController *detailView = [[IWHomeDetailTableViewController alloc]init];
    IWStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    detailView.statusFrame = statusFrame;
    [self.navigationController pushViewController:detailView animated:YES];
}


@end
