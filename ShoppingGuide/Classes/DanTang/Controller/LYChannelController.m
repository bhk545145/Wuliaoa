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
#import "IWAccount.h"
#import "IWAccountTool.h"
#import "SVProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayer.h"
static NSString * const HomeCell = @"HomeCell";

@interface LYChannelController ()<UITableViewDelegate, UITableViewDataSource, ZFPlayerDelegate>{
    dispatch_queue_t queue;
    ZFPlayerView *_playerView;
}

/**
 * 下一页的请求地址
 */
@property (nonatomic, copy) NSString *next_url;

@property (nonatomic, strong) NSMutableArray *statusFrames;

@property (nonatomic, strong) MPMoviePlayerViewController *playerController;



@end

@implementation LYChannelController
- (void)dealloc {
    IWLog(@"%@释放了",self.class);
}

- (NSMutableArray *)statusFrames
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("latiaoQueue", DISPATCH_QUEUE_CONCURRENT);
    // 初始化表格
    [self setupTable];
    
    // 刷新
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewInfo) name:PROBE_DEVICES_CHANGED object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.channesID == channesIDTypeauthorId) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.navigationItem.title = @"我的辣条";
    }
    [self loadInfo];
}

/**
 *  初始化表格
 */
- (void)setupTable {
    if (self.channesID == channesIDTypeauthorId) {
        self.tableView.contentInset = UIEdgeInsetsMake(LYNavBarHeight, 0, self.tabBarController.tabBar.mr_height, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(LYNavBarHeight + LYTitlesViewH, 0, self.tabBarController.tabBar.mr_height, 0);
    }
    
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 给表格视图添加下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewInfo)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 给表格视图添加上拉加载
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreInfo)];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

/**
 *  请求数据
 */
- (void)loadItemInfo:(NSString *)urlString withType:(NSInteger)type{
    dispatch_async(queue, ^{
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
                // 传递辣条模型数据
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
                // 显示最新辣条的数量(给用户一些友善的提示)
                [self showNewStatusCount:statusFrameArray.count];
            } else if(type == 1)  {   // 上拉加载
                // 添加新数据到旧数据的后面
                [weakSelf.statusFrames addObjectsFromArray:statusFrameArray];
            }else{      //刷新旧数据
                int i;
                int x;
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:weakSelf.statusFrames];
                if (array.count == 0) {
                    [weakSelf.statusFrames addObjectsFromArray:statusFrameArray];
                }else{
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
                    [weakSelf.statusFrames removeAllObjects];
                    [weakSelf.statusFrames addObjectsFromArray:array];
                }

            }
//            [SVProgressHUD showSuccessWithStatus:@"加载完成!"];
            // 刷新表格
            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        } failure:^(NSError * _Nullable error) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];

    });
   }
/**
 *  刷新
 */
- (void)loadInfo {
    static NSString *OldURLString;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    IWAccount *account = [IWAccountTool account];
    if (self.statusFrames.count) {
        IWStatusFrame *statusFrame = [self.statusFrames lastObject];
        // 加载ID <= max_id的辣条
        long long maxId = [statusFrame.status.id longLongValue];
        // 加载ID比since_id大的辣条
        params[@"sinceid"] = @(maxId);
        if (self.channesID == channesIDTypeAll) {
            OldURLString = [NSString stringWithFormat:@"%@/timeline/1/100?sinceId=%@",IWArticleURL,params[@"sinceid"]];
        }else if(self.channesID == channesIDTypePICTURE){
            OldURLString = [NSString stringWithFormat:@"%@/timeline/1/100?type=PICTURE&sinceId=%@",IWArticleURL,params[@"sinceid"]];
        }else if(self.channesID == channesIDTypeJOKE){
            OldURLString = [NSString stringWithFormat:@"%@/timeline/1/100?type=JOKE&sinceId=%@",IWArticleURL,params[@"sinceid"]];
        }else{
            OldURLString = [NSString stringWithFormat:@"%@/timeline/1/100?authorId=%@",IWArticleURL,account.id];
        }
        [self loadItemInfo:OldURLString withType:2];
    }
    
}

/**
 *  下拉刷新
 */
- (void)loadNewInfo {
    
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"count"] = @10;
    static NSString *URLString;
    IWAccount *account = [IWAccountTool account];
    if (self.statusFrames.count) {
        IWStatusFrame *statusFrame = self.statusFrames[0];
        // 加载ID比since_id大的辣条
        params[@"sinceid"] = statusFrame.status.id;
        if (self.channesID == channesIDTypeAll) {
            URLString = [NSString stringWithFormat:@"%@/timeline/1/100?sinceId=%@",IWArticleURL,params[@"sinceid"]];
        }else if(self.channesID == channesIDTypePICTURE){
            URLString = [NSString stringWithFormat:@"%@/timeline/1/100?sinceId=%@&type=PICTURE",IWArticleURL,params[@"sinceid"]];
        }else if(self.channesID == channesIDTypeJOKE) {
            URLString = [NSString stringWithFormat:@"%@/timeline/1/100?sinceId=%@&type=JOKE",IWArticleURL,params[@"sinceid"]];
        }else{
            URLString = [NSString stringWithFormat:@"%@/timeline/1/100?sinceId=%@&authorId=%@",IWArticleURL,params[@"sinceid"],account.id];
        }
        [self loadInfo];
    }else{
        if (self.channesID == channesIDTypeAll) {
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@",IWArticleURL,params[@"count"]];
        }else if(self.channesID == channesIDTypePICTURE){
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?type=PICTURE",IWArticleURL,params[@"count"]];
        }else if(self.channesID == channesIDTypeJOKE){
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?type=JOKE",IWArticleURL,params[@"count"]];
        }else{
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?authorId=%@",IWArticleURL,params[@"count"],account.id];
        }
    }
    [self loadItemInfo:URLString withType:0];


}

/**
 *  上拉加载
 */
- (void)loadMoreInfo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"count"] = @20;
    static NSString *URLString;
    IWAccount *account = [IWAccountTool account];
    if (self.statusFrames.count) {
        IWStatusFrame *statusFrame = [self.statusFrames lastObject];
        // 加载ID <= max_id的辣条
        long long maxId = [statusFrame.status.id longLongValue];
        params[@"maxId"] = @(maxId);
        
        if (self.channesID == channesIDTypeAll) {
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?maxId=%@",IWArticleURL,params[@"count"],params[@"maxId"]];
        }else if(self.channesID == channesIDTypePICTURE){
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?maxId=%@&type=PICTURE",IWArticleURL,params[@"count"],params[@"maxId"]];
        }else if(self.channesID == channesIDTypeJOKE){
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?maxId=%@&type=JOKE",IWArticleURL,params[@"count"],params[@"maxId"]];
        }else{
            URLString = [NSString stringWithFormat:@"%@/timeline/1/%@?maxId=%@&authorId=%@",IWArticleURL,params[@"count"],params[@"maxId"],account.id];
        }
        [self loadItemInfo:URLString withType:1];
    }else{
        
    }
    
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
        __block int timeout=2;
        dispatch_queue_t timequeue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,timequeue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
            }else{
                [self loadInfo];
                int seconds = timeout % 59;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                IWLog(@"%@",strTime);
                timeout--;
            }
        });
         dispatch_resume(_timer);
    };
    //打开视频播放器
    cell.topView.photosView.btnblock = ^(NSURL *url) {
        self.playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:self.playerController];
//        _playerView = [[ZFPlayerView alloc] init];
//        // view
//        ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
//        // model
//        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
//        playerModel.fatherView = cell.topView.photosView;
//        playerModel.videoURL = url;
//        playerModel.title = @"";
//        [_playerView playerControlView:controlView playerModel:playerModel];
//        // delegate
//        _playerView.delegate = self;
//        // auto play the video
//        [_playerView autoPlayTheVideo];
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
    if(self.channesID != channesIDTypeauthorId){
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
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IWHomeDetailTableViewController *detailView = [[IWHomeDetailTableViewController alloc]init];
    IWStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    detailView.statusFrame = statusFrame;
    [self.navigationController pushViewController:detailView animated:YES];
}

/**
 *  显示最新辣条的数量
 *
 *  @param count 最新辣条的数量
 */
- (void)showNewStatusCount:(int)count
{
    // 1.创建一个按钮
    UIButton *btn = [[UIButton alloc] init];
    // below : 下面  btn会显示在self.navigationController.navigationBar的下面
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    
    // 2.设置图片和文字
    btn.userInteractionEnabled = NO;
    [btn setBackgroundImage:[UIImage resizedImageWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    if (count) {
        NSString *title = [NSString stringWithFormat:@"共有%d条新的辣条", count];
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"没有新的辣条" forState:UIControlStateNormal];
    }
    
    // 3.设置按钮的初始frame
    CGFloat btnH = 30;
    CGFloat btnY = 64 - btnH;
    CGFloat btnX = 0;
    CGFloat btnW = self.view.frame.size.width - 2 * btnX;
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    // 4.通过动画移动按钮(按钮向下移动 btnH + 1)
    [UIView animateWithDuration:0.7 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, btnH);
        
    } completion:^(BOOL finished) { // 向下移动的动画执行完毕后
        
        // 建议:尽量使用animateWithDuration, 不要使用animateKeyframesWithDuration
        [UIView animateWithDuration:0.7 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            btn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // 将btn从内存中移除
            [btn removeFromSuperview];
        }];
        
    }];
}

@end
