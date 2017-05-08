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
#import "UMMobClick/MobClick.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"

@interface LYTMViewController ()<WKNavigationDelegate,WKUIDelegate>{
    dispatch_queue_t queue;
}

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation LYTMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("latiaoQueue", DISPATCH_QUEUE_CONCURRENT);
    self.title = @"赞品";
    self.webView = [[WKWebView alloc]init];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    //网页自适配
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkUserType_backward_9x15_"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackClick)];
    dispatch_async(queue, ^{
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.yzyp.online/index.php?r=index/wap"]]];
    });
    
}

// 进入页面，建议在此处添加
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_async(queue, ^{
        NSString* cName = [NSString stringWithFormat:@"%@",  self.title, nil];
        [MobClick beginLogPageView:cName];
    });
    
    
}

// 退出页面，建议在此处添加
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    dispatch_async(queue, ^{
        NSString* cName = [NSString stringWithFormat:@"%@", self.title, nil];
        [MobClick endLogPageView:cName];
    });
    
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [SVProgressHUD showWithStatus:@"正在加载"];
    IWLog(@"webView:%f",self.webView.frame.size.height);
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    [self foraward:navigationAction.request];
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}


// 返回事件
- (void)navigationBackClick {
    [self.webView goBack];
}

-(void)foraward:(NSURLRequest *)request{
    NSString *URLString = [NSString stringWithFormat:@"%@",request.URL];
    // 淘宝
    if ([URLString containsString:@"taobao://m.taobao.com"]) {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
            [MobClick event:@"taobao"];
        }
    }
    
    // 天猫
    if ([URLString containsString:@"detail.m.tmall.com"]) {
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL options:@{} completionHandler:nil];
            [MobClick event:@"detail"];
        }
    }
    
}
@end
