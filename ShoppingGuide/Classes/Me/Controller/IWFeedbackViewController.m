//
//  IWFeedbackViewController.m
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/5/25.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import "IWFeedbackViewController.h"
#import "IWAccount.h"
#import "IWToken.h"
#import "IWAccountTool.h"
#import "SVProgressHUD.h"
#import "IWWeiboTool.h"
#import "LYNetworkTool.h"
#import "IWPlaceholderTextView.h"

@interface IWFeedbackViewController ()
@property (weak, nonatomic) IBOutlet IWPlaceholderTextView *feedbackTextView;

@end

@implementation IWFeedbackViewController

- (void)dealloc {
    IWLog(@"%@释放了",self.class);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    [self setupTextView];
    
    
    //点击背景关闭键盘
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTap)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)setupNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)setupTextView {
    self.feedbackTextView.font = [UIFont systemFontOfSize:15];
    self.feedbackTextView.placeholder = @"把您的宝贵意见反馈给我们...";
    self.feedbackTextView.alwaysBounceVertical = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self.feedbackTextView];
}

- (void)textDidChange:(NSNotification *)note
{
    self.navigationItem.rightBarButtonItem.enabled = _feedbackTextView.text.length != 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)sendClick{
    [self sendStatusWithoutImage];
    [self.navigationController popViewControllerAnimated:YES];
}

//发送无图片
- (void)sendStatusWithoutImage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    IWToken *token = [IWAccountTool token];
    params[@"token"] = token.token;
    params[@"userId"] = token.userId;
    params[@"content"] = self.feedbackTextView.text;
    params[@"device"] = [IWWeiboTool iphoneType];
    [[LYNetworkTool sharedNetworkTool] loadDataJsonInfoPost:IWFeedbackURL parameters:params success:^(id  _Nullable responseObject) {
        [SVProgressHUD showWithStatus:@"发送成功"];
        
    } failure:^(NSError * _Nullable error) {
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}

//点击背景关闭键盘
-(IBAction)backgroundTap{
    [_feedbackTextView resignFirstResponder];
}



@end
