//
//  IWFeedbackViewController.m
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/5/25.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import "IWFeedbackViewController.h"

@interface IWFeedbackViewController ()

@end

@implementation IWFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendClick{
    
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
