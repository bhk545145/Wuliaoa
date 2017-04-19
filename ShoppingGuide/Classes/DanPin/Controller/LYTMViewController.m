//
//  LYTMViewController.m
//  ShoppingGuide
//
//  Created by coderLL on 16/9/20.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import "LYTMViewController.h"
#import "LYProduct.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "BaiduMobStat.h"

@interface LYTMViewController ()<UIWebViewDelegate>{
    dispatch_queue_t queue;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LYTMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("latiaoQueue", DISPATCH_QUEUE_CONCURRENT);
    self.title = @"赞品";
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkUserType_backward_9x15_"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackClick)];
    
    [self setupWebView];
    __weak typeof(self) weakSelf = self;
    // 刷新
    [weakSelf.webView.scrollView.mj_header beginRefreshing];

}

// 进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
    [[BaiduMobStat defaultStat] pageviewStartWithName:cName];
    
}

// 退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:cName];
}

- (void)setupWebView{
    /// 自动对页面进行缩放以适应屏幕
    self.webView.scalesPageToFit = YES;
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewInfo)];
}

- (void)loadNewInfo{
    dispatch_async(queue, ^{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://demo.dataoke.com/"]]];
        //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.product.ali_click]]];
        
        
    });
    
}

#pragma mark - <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    IWLog(@"URL---%@",request);
    [self foraward:request];
    [[BaiduMobStat defaultStat] webviewStartLoadWithRequest:request];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:@"数据加载中..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    __weak typeof(self) weakSelf = self;
    [weakSelf.webView.scrollView.mj_header endRefreshing];
    if(self.webView.canGoBack){
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.webView.scrollView.bounces = NO;
    }else{
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.webView.scrollView.bounces = YES;
    }
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:@"出错啦~"];
     __weak typeof(self) weakSelf = self;
    [weakSelf.webView.scrollView.mj_header endRefreshing];
}



// 返回事件
- (void)navigationBackClick {
    [self.webView goBack];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)foraward:(NSURLRequest *)request{
    NSString *URLString = [NSString stringWithFormat:@"%@",request.URL];
    // 淘宝
    if ([URLString containsString:@"taobao://m.taobao.com"]) {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
        }
    }
    
    // 天猫
    if ([URLString containsString:@"detail.m.tmall.com"]) {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
        }
    }
    
}
@end
