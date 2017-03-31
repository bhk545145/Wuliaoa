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
#import "IWCommitCell.h"
#import "IWStatusToolbar.h"

#import "LYNetworkTool.h"
#import "IWAccount.h"
#import "IWAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "IWWeiboTool.h"
#import "IWCommit.h"
#import "MJExtension.h"
#import "IWPhoto.h"

#import "MessageTextView.h"

#import <LoremIpsum/LoremIpsum.h>

#define DEBUG_CUSTOM_TYPING_INDICATOR 0
#define DEBUG_CUSTOM_BOTTOM_VIEW 0
static NSString* commitCell = @"commitCell";
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([IWCommitCell class]) bundle:nil] forCellReuseIdentifier:commitCell];

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
        cell.statusToolbar.btnblock = ^(){
            [self getComment];
        };
        return cell;
    }else{
        IWCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:commitCell];
        IWCommit *commit = _commentArray[indexPath.row - 1];
        cell.commit = commit;
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
        // 1.取出这行微博的内容
        IWCommit *commit = _commentArray[indexPath.row - 1];
        // 2.计算微博内容大小占据的高度
        NSString *text = commit.content;
        CGFloat textHeight  = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(250,MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        // sizeWithFont: 根据字体来算text的宽高
        // constrainedToSize: 限制算出来的文集的宽度和高度 这里限制宽度为250个像素点
        // lineBreakMode: 换行的模式
        // 设置cell的高度
        return  textHeight < 55 ? 55 : textHeight + 5;
    }
    
}


//发送评论按钮
- (void)didPressRightButton:(id)sender
{
    [self.textView refreshFirstResponder];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    IWAccount *account = [IWAccountTool account];
    params[@"userId"] = account.user.id;
    params[@"content"] = self.textView.text;
    NSString *articleId = _statusFrame.status.id;
    NSString *URLString = [NSString stringWithFormat:@"%@/comment/%@",IWAPPURL,articleId];

    [[LYNetworkTool sharedNetworkTool] loadDataJsonInfoPost:URLString parameters:params success:^(id  _Nullable responseObject) {
        [self getComment];
        [self.textView resignFirstResponder];
    } failure:^(NSError * _Nullable error) {
        
    }];
    [super didPressRightButton:sender];
}

//获取评论
- (void)getComment{
    NSString *articleId = _statusFrame.status.id;
    NSString *URLString = [NSString stringWithFormat:@"%@/comment/%@/1/10",IWAPPURL,articleId];

    [[LYNetworkTool sharedNetworkTool] loadDataInfo:URLString parameters:nil success:^(id  _Nullable responseObject) {
        IWLog(@"评论————————%@",responseObject[@"result"]);
        _commentArray = [IWCommit mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"list"]];
        [self getarticle];
        
    } failure:^(NSError * _Nullable error) {
        
    }];
}
//根据id获取最新辣条
- (void)getarticle{
    NSString *articleId = _statusFrame.status.id;
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",IWArticleURL,articleId];
    [[LYNetworkTool sharedNetworkTool] loadDataInfo:URLString parameters:nil success:^(id  _Nullable responseObject) {
        IWLog(@"最新辣条————————%@",responseObject);
        // Tell MJExtension what type model will be contained in IWPhoto.
        [IWStatus mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"images" : [IWPhoto class]};
        }];
        // 将字典数组转为模型数组(里面放的就是IWStatus模型)
        NSArray *responseObjectArray = [NSArray arrayWithObject:responseObject];
        NSArray *statusArray = [IWStatus mj_objectArrayWithKeyValuesArray:responseObjectArray];
        // 创建frame模型对象
        for (IWStatus *status in statusArray) {
            IWStatusFrame *statusFrame = [[IWStatusFrame alloc] init];
            // 传递微博模型数据
            statusFrame.status = status;
            _statusFrame = statusFrame;
            [self.tableView reloadData];
        }
        
    } failure:^(NSError * _Nullable error) {
        
    }];

}

@end
