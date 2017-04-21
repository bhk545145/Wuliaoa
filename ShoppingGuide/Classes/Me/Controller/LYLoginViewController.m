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
@interface LYLoginViewController ()<UITextFieldDelegate>{
    dispatch_queue_t queue;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendSmsBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordOrSms;
@property (weak, nonatomic) IBOutlet UIButton *sendSms;
@property (weak, nonatomic) IBOutlet UILabel *smstxt;
@property (nonatomic,assign) BOOL ispassword;
@end

@implementation LYLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.phoneNum becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("latiaoQueue", DISPATCH_QUEUE_CONCURRENT);
    _ispassword = NO;
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
        [self daojishi];
    } failure:^(NSError * _Nullable error) {
        [SVProgressHUD showSuccessWithStatus:@"发送失败"];
    }];

}

//验证码倒计时
- (void)daojishi{
    __block int timeout=30; //倒计时时间
    dispatch_queue_t timequeue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,timequeue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendSmsBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.sendSmsBtn.userInteractionEnabled = YES;
                [self.sendSmsBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 59;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendSmsBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [self.sendSmsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                self.sendSmsBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.phoneNum resignFirstResponder];
    [self.pwd resignFirstResponder];
}

- (IBAction)loginIn:(UIButton *)sender {
    if (_ispassword) {
        [self passwordLogin];
    }else{
        [self CodeLogin];
    }

   
}

//验证码登录
- (void)CodeLogin{
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.phoneNum.text;
    params[@"code"] = self.pwd.text;
    params[@"device"] = [IWWeiboTool iphoneType];
    dispatch_async(queue, ^{
        [[LYNetworkTool sharedNetworkTool] loginPost:IWCodeLoginURl parameters:params success:^(id  _Nullable responseObject) {
            IWLog(@"登录信息——————%@",responseObject);
            int isLongin = [responseObject[@"status"] intValue];
            if (isLongin == 1) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                IWAccount *account = [IWAccount mj_objectWithKeyValues:responseObject[@"result"][@"user"]];
                IWToken *token = [IWToken mj_objectWithKeyValues:responseObject[@"result"][@"token"]];
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
    });
}
//密码登录
- (void)passwordLogin{
    __weak typeof(self) weakSelf = self;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.phoneNum.text;
    params[@"password"] = self.pwd.text;
    params[@"device"] = [IWWeiboTool iphoneType];
    dispatch_async(queue, ^{
        [[LYNetworkTool sharedNetworkTool] loginPost:IWLoginURl parameters:params success:^(id  _Nullable responseObject) {
            IWLog(@"登录信息——————%@",responseObject);
            int isLongin = [responseObject[@"status"] intValue];
            if (isLongin == 1) {
                [SVProgressHUD showSuccessWithStatus:@"登录成功!"];
                IWAccount *account = [IWAccount mj_objectWithKeyValues:responseObject[@"result"][@"user"]];
                IWToken *token = [IWToken mj_objectWithKeyValues:responseObject[@"result"][@"token"]];
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
    });
}

- (void)cancel:(UIBarButtonItem *)item {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)registe {
    
}

- (IBAction)passwordOrSmsbtn:(id)sender {
    if (_ispassword) {
        [_passwordOrSms setTitle:@"验证码登入" forState:UIControlStateNormal];
        _smstxt.text = @"验证码";
        _sendSms.hidden = NO;
        _ispassword = NO;

    }else{
        [_passwordOrSms setTitle:@"密码登入" forState:UIControlStateNormal];
        _smstxt.text = @"密码";
        _sendSms.hidden = YES;
        _ispassword = YES;
    }
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.loginBtn.enabled = (self.phoneNum.text.length > 0 && self.pwd.text.length > 0) ? YES : NO;
    return YES;
}


@end
