//
//  IWHomeDetailTableViewController.m
//  Wuliaoa
//
//  Created by 白洪坤 on 2017/3/9.
//  Copyright © 2017年 itcast. All rights reserved.
//

#import "IWHomeDetailTableViewController.h"
#import "IWStatus.h"
#import "IWStatusFrame.h"
#import "IWStatusCell.h"

#import "AFNetworking.h"
#import "IWAccount.h"
#import "IWAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "IWWeiboTool.h"

#import "MessageTextView.h"

#import <LoremIpsum/LoremIpsum.h>

#define DEBUG_CUSTOM_TYPING_INDICATOR 0
#define DEBUG_CUSTOM_BOTTOM_VIEW 0

@interface IWHomeDetailTableViewController ()
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) UIWindow *pipWindow;
@end

@implementation IWHomeDetailTableViewController

- (instancetype)init
{
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}

- (void)commonInit
{
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIContentSizeCategoryDidChangeNotification object:nil];
    [self registerClassForTextView:[MessageTextView class]];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inverted = NO;
    [self.rightButton setTitle:@"发送" forState:UIControlStateNormal];
    
    [self.textInputbar.editorTitle setTextColor:[UIColor whiteColor]];
}



- (void)setStatusFrame:(IWStatusFrame *)statusFrame{
    _statusFrame = statusFrame;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 1.创建cell
        IWStatusCell *cell = [IWStatusCell cellWithTableView:tableView];
        
        // 2.传递frame模型
        cell.statusFrame = _statusFrame;
        return cell;
    }else{
        // 1.创建cell
        IWStatusCell *cell = [IWStatusCell cellWithTableView:tableView];
        
        // 2.传递frame模型
//        cell.statusFrame = _statusFrame;
        return cell;
    }
    
    
    
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IWStatusFrame *statusFrame = _statusFrame;
    return statusFrame.cellHeight;
}


//发送评论按钮
- (void)didPressRightButton:(id)sender
{
    [self.textView refreshFirstResponder];
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 2.封装请求参数
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    IWAccount *account = [IWAccountTool account];
    params[@"userId"] = account.id;
    params[@"content"] = self.textView.text;
    NSString *articleId = _statusFrame.status.id;
    NSString *URLString = [NSString stringWithFormat:@"http://latiao.izanpin.com/api/comment/%@",articleId];
    // 3.发送请求
    [mgr POST:URLString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD showSuccess:@"评论成功"];
        //通知首页刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:PROBE_DEVICES_CHANGED object:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showSuccess:@"评论失败"];
    }];
    
    
    [super didPressRightButton:sender];
}

//获取评论


@end
