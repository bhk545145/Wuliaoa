//
//  LYLoginViewController.m
//  ShoppingGuide
//
//  Created by coderLL on 16/9/18.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import "LYLoginViewController.h"
#import "LYNetworkTool.h"
#import "MJExtension.h"
#import "IWToken.h"
#import "IWAccount.h"
#import "IWAccountTool.h"
#import "IWWeiboTool.h"
#import "SVProgressHUD.h"
@interface LYLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LYLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.phoneNum becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registe)];
    
    self.phoneNum.delegate = self;
    self.pwd.delegate = self;
}
- (IBAction)codeUp:(UIButton *)sender {
    [self hidenKeyboard];
    
    NSString *userNameStr = self.phoneNum.text;
    
    // 3.发送请求
    NSString *sendLoginCodeURL = [NSString stringWithFormat:@"http://wuliaoa.izanpin.com/api/sms/sendLoginSecurityCode/%@",userNameStr];
    [[LYNetworkTool sharedNetworkTool]loginPost:sendLoginCodeURL parameters:nil success:^(id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    } failure:^(NSError * _Nullable error) {
        [SVProgressHUD showSuccessWithStatus:@"发送失败"];
    }];

}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.phoneNum resignFirstResponder];
    [self.pwd resignFirstResponder];
}

- (IBAction)loginIn:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.phoneNum.text;
    params[@"code"] = self.pwd.text;
    params[@"device"] = [IWWeiboTool iphoneType];
    
    [[LYNetworkTool sharedNetworkTool] loginPost:IWCodeLoginURl parameters:params success:^(id  _Nullable responseObject) {
        IWLog(@"登录信息——————%@",responseObject);
        int isLongin = [responseObject[@"status"] intValue];
        if (isLongin == 1) {
            IWAccount *account = [IWAccount mj_objectWithKeyValues:responseObject[@"result"][@"user"]];
            IWToken *token = [IWToken mj_objectWithKeyValues:responseObject[@"result"][@"token"]];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            IWLog(@"%@",account.nickname);
            [IWAccountTool saveAccount:account];
            [IWAccountTool saveToken:token];
            // 发送通知
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LYLoginNotification" object:nil];
            [IWWeiboTool chooseTabBarController];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"登录失败"];
        }
            // 退出登录界面
            [weakSelf dismissViewControllerAnimated:YES completion:nil];

    } failure:^(NSError * _Nullable error) {
        
         [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];
}

- (void)cancel:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)registe {
    
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.loginBtn.enabled = (self.phoneNum.text.length > 0 && self.pwd.text.length > 0) ? YES : NO;
    return YES;
}


@end
