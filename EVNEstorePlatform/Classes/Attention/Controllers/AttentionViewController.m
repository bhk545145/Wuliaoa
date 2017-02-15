//
//  AttentionViewController.m
//  EVNEstorePlatform
//
//  Created by developer on 2016/12/30.
//  Copyright © 2016年 仁伯安. All rights reserved.
//

#import "AttentionViewController.h"

@interface AttentionViewController ()

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AttentionViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"无聊图";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    if ((!_tableView)) {
        
    }
    return  _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}
@end
