//
//  IWOAuthViewController.m
//  ItcastWeibo
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWOAuthViewController.h"
#import "AFNetworking.h"
#import "IWAccount.h"
#import "IWWeiboTool.h"
#import "MBProgressHUD+MJ.h"
#import "IWAccountTool.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "BLUITextFieldView.h"
#define FitWidth 1
#define FitHeight 1 
@interface IWOAuthViewController () <UIWebViewDelegate,UITextFieldDelegate>
@property(nonatomic, assign)NSInteger keyboardHeight;
@property(nonatomic, assign)BOOL keyboardIsShow;
@property(nonatomic, strong)BLUITextFieldView *userTextField;
@property(nonatomic, strong)BLUITextFieldView *passTextField;
@property(nonatomic, strong)UIButton *sendLoginCodeButton;
@property(nonatomic, strong)UIButton *loginButton;
@property(nonatomic, strong)UISwitch *passwordOrCodeSwitch;
@end

@implementation IWOAuthViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录";
    
    //图标
    UIImageView *iconIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 92/2, 150, 58, 47)];
    iconIamgeView.image = [UIImage imageNamed:@"dnakit"];
//    [self.view addSubview:iconIamgeView];
    //名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconIamgeView.frame.origin.x, iconIamgeView.frame.origin.y + iconIamgeView.frame.size.height, iconIamgeView.frame.size.width, 40 * FitHeight)];
    nameLabel.text = @"辣条";
    nameLabel.font = [UIFont systemFontOfSize:25];
    nameLabel.textAlignment = 1;
    nameLabel.textColor = [UIColor blackColor];
//    [self.view addSubview:nameLabel];
    
    //用户名
    _userTextField = [[BLUITextFieldView alloc] initWithFrame:CGRectMake(70 * FitWidth, nameLabel.frame.origin.y + nameLabel.frame.size.height - 100, 526/2 * FitWidth, 30)];
    _userTextField.borderStyle = UITextBorderStyleRoundedRect;
    _userTextField.leftImageView.image = [UIImage imageNamed:@"account_def"];
    _userTextField.leftImageView.highlightedImage = [UIImage imageNamed:@"account"];
    _userTextField.layer.masksToBounds = YES;
    _userTextField.layer.cornerRadius = 5.0f;
    [self.view addSubview:_userTextField];
    
    //密码
    _passTextField = [[BLUITextFieldView alloc] initWithFrame:CGRectMake(_userTextField.frame.origin.x, _userTextField.frame.origin.y + _userTextField.frame.size.height + 20 * FitHeight, _userTextField.frame.size.width, _userTextField.frame.size.height)];
    [_passTextField setBorderStyle:UITextBorderStyleRoundedRect];
    _passTextField.secureTextEntry = YES;
    [self.view addSubview:_passTextField];
    
    
    //是否验证码登录开关
    _passwordOrCodeSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(_passTextField.frame.origin.x, _passTextField.frame.origin.y + _passTextField.frame.size.height + 20 * FitHeight, _passTextField.frame.size.width/2, _passTextField.frame.size.height)];
    [_passwordOrCodeSwitch addTarget:self action:@selector(PassOrCodeChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_passwordOrCodeSwitch];
    
    
    //获取验证码
    _sendLoginCodeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sendLoginCodeButton.frame = CGRectMake(_passTextField.frame.origin.x + _passTextField.frame.size.width/2, _passTextField.frame.origin.y + _passTextField.frame.size.height + 20 * FitHeight, _passTextField.frame.size.width/2, _passwordOrCodeSwitch.frame.size.height);
    [_sendLoginCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendLoginCodeButton addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendLoginCodeButton];

    
    //登录
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginButton.frame = CGRectMake(_passTextField.frame.origin.x, _sendLoginCodeButton.frame.origin.y + _sendLoginCodeButton.frame.size.height + 20 * FitHeight, _passTextField.frame.size.width, 50);
    _loginButton.backgroundColor = IWColor(57, 177, 255);
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.layer.cornerRadius = 25 * FitWidth;
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    
    //键盘监听
    _keyboardIsShow = NO;
    //键盘出现或改变时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘退出时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 输入框
    _userTextField.delegate = self;
    _passTextField.delegate = self;
    
    _userTextField.placeholder = @"手机号";
    _passTextField.placeholder = @"密码";
    
//    _userTextField.textAlignment = NSTextAlignmentCenter;
//    _passTextField.textAlignment = NSTextAlignmentCenter;
    
    //指定编辑时键盘的return键类型
    _userTextField.returnKeyType = UIReturnKeyNext;
    _passTextField.returnKeyType = UIReturnKeyDone;
    
    //注册键盘响应事件方法
    [_userTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
  
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userNameStr = [defaults objectForKey:@"UserName"];
    NSString *passwordStr = [defaults objectForKey:@"Password"];
    
    _passTextField.text = passwordStr;
    _userTextField.text = userNameStr;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - keyboard
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
    _keyboardIsShow = YES;
    NSLog(@"keyboardHeight --- >%ld", _keyboardHeight);
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _keyboardIsShow = NO;
}
#pragma mark - textField
-(void) resumeView
{
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
//点击键盘上的Return按钮响应的方法
-(void)nextOnKeyboard:(UITextField *)sender
{
    if (sender == _userTextField) {
        [_passTextField becomeFirstResponder];
    }else {
        [self hidenKeyboard];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_userTextField resignFirstResponder];
    [_passTextField resignFirstResponder];
}
//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.passTextField resignFirstResponder];
    [self.userTextField resignFirstResponder];
    [self resumeView];
}
#pragma mark - protocol
//textFieldProtocol
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField == _userTextField) {
        _userTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }else if (textField == _passTextField){
        _passTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    
    NSTimeInterval animationDuration = 0.3f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect textFieldFrame = [textField convertRect:textField.frame toView:self.view];
    // 上移
    if (_keyboardIsShow) {
        float y = self.view.frame.origin.y;
        if (height - textFieldFrame.origin.y - y - _keyboardHeight > 90) {
            return YES;
        }
        CGRect rect = CGRectMake(0.0f, y - textField.frame.size.height, width, height);
        self.view.frame = rect;
    } else {
        
        int offset = textFieldFrame.origin.y - height;
        NSLog(@"offset --- >%d",offset);
        CGRect rect = CGRectMake(0.0f, - offset, width, height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
    
    return YES;
    
}

#pragma mark 登录方法
- (void)loginBtnAction:(id)sender{
    [self hidenKeyboard];
    
    NSString *userNameStr = _userTextField.text;
    NSString *passwordStr = _passTextField.text;
    
    if (_passwordOrCodeSwitch.on == YES) {
        [self codeLoginuserNameStr:userNameStr passwordStr:passwordStr];
    }else{
        [self passwordLoginuserNameStr:userNameStr passwordStr:passwordStr];
    }
    

}


- (void)codeLoginuserNameStr:(NSString *)userNameStr passwordStr:(NSString *)passwordStr{
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = userNameStr;
    params[@"code"] = passwordStr;
    params[@"device"] = [IWWeiboTool iphoneType];
    
    // 3.发送请求
    [mgr POST:IWCodeLoginURl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        IWAccount *account = [IWAccount mj_objectWithKeyValues:responseObject[@"result"]];
        int isLongin = [responseObject[@"status"] intValue];
        if (isLongin == 1) {
            [MBProgressHUD showSuccess:@"登录成功"];
            [IWAccountTool saveAccount:account];
            [IWWeiboTool chooseTabBarController];
        }else{
            [MBProgressHUD showSuccess:@"登录失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showSuccess:@"发送失败"];
    }];
}


- (void)passwordLoginuserNameStr:(NSString *)userNameStr passwordStr:(NSString *)passwordStr{
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = userNameStr;
    params[@"password"] = passwordStr;
    params[@"device"] = [IWWeiboTool iphoneType];
    
    // 3.发送请求
    [mgr POST:IWLoginURl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        IWAccount *account = [IWAccount mj_objectWithKeyValues:responseObject[@"result"]];
        int isLongin = [responseObject[@"status"] intValue];
        if (isLongin == 1) {
            [MBProgressHUD showSuccess:@"登录成功"];
            [IWAccountTool saveAccount:account];
            [IWWeiboTool chooseTabBarController];
        }else{
            [MBProgressHUD showSuccess:@"登录失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showSuccess:@"发送失败"];
    }];
}

- (void)PassOrCodeChange:(UISwitch *)sender{
    if (sender.on) {
        _passTextField.placeholder = @"验证码";
        _passTextField.secureTextEntry = NO;
    }else{
        _passTextField.placeholder = @"密码";
        _passTextField.secureTextEntry = YES;
    }
}

- (void)sendBtnAction:(id)sender{
    [self hidenKeyboard];
    
    NSString *userNameStr = _userTextField.text;
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 3.发送请求
    NSString *sendLoginCodeURL = [NSString stringWithFormat:@"http://wuliaoa.izanpin.com/api/sms/sendLoginSecurityCode/%@",userNameStr];
    [mgr POST:sendLoginCodeURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        int status = [responseObject[@"status"] intValue];
        if (status == 1) {
            [MBProgressHUD showSuccess:@"发送成功"];
            [_passwordOrCodeSwitch setOn:YES animated:YES];
            _passTextField.placeholder = @"验证码";
        }else{
            [MBProgressHUD showSuccess:@"发送失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showSuccess:@"发送失败"];
    }];
    

}



@end
