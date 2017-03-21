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

#import "LYNetworkTool.h"
#import "IWAccount.h"
#import "IWAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "IWWeiboTool.h"
#import "IWCommit.h"
#import "MJExtension.h"

#import "MessageTextView.h"

#import <LoremIpsum/LoremIpsum.h>

#define DEBUG_CUSTOM_TYPING_INDICATOR 0
#define DEBUG_CUSTOM_BOTTOM_VIEW 0

@interface IWHomeDetailTableViewController (){
    
}
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSArray *commentArray;
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
    [self getComment];
}



- (void)setStatusFrame:(IWStatusFrame *)statusFrame{
    _statusFrame = statusFrame;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1+ _commentArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 1.创建cell
        IWStatusCell *cell = [IWStatusCell cellWithTableView:tableView];
        
        // 2.传递frame模型
        cell.statusFrame = _statusFrame;
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"commitCell"];
        IWCommit *commit = _commentArray[indexPath.row - 1];
        cell.textLabel.text = commit.content;
        return cell;
    }
    
    
    
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        IWStatusFrame *statusFrame = _statusFrame;
        return statusFrame.cellHeight;
    }else{
        return 50;
    }
    
}


//发送评论按钮
- (void)didPressRightButton:(id)sender
{
    [self.textView refreshFirstResponder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    IWAccount *account = [IWAccountTool account];
    params[@"userId"] = account.id;
    params[@"content"] = self.textView.text;
    NSString *articleId = _statusFrame.status.id;
    NSString *URLString = [NSString stringWithFormat:@"http://latiao.izanpin.com/api/comment/%@",articleId];

    [[LYNetworkTool sharedNetworkTool] loadDataJsonInfoPost:URLString parameters:params success:^(id  _Nullable responseObject) {
        
    } failure:^(NSError * _Nullable error) {
        
    }];
    [super didPressRightButton:sender];
}

//获取评论
- (void)getComment{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    IWAccount *account = [IWAccountTool account];
    params[@"userId"] = account.id;
    params[@"content"] = self.textView.text;
    NSString *articleId = _statusFrame.status.id;
    NSString *URLString = [NSString stringWithFormat:@"http://wuliaoa.izanpin.com/api/comment/%@/1/10",articleId];

    [[LYNetworkTool sharedNetworkTool] loadDataInfo:URLString parameters:params success:^(id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"result"]);
        _commentArray = [IWCommit mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
        [self.tableView reloadData];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

@end
