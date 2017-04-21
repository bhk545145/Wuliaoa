//
//  IWAboutMeViewController.m
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/4/21.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import "IWAboutMeViewController.h"

@interface IWAboutMeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versiontxt;

@end

@implementation IWAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.versiontxt.text = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
