//
//  BLUITextFieldView.m
//  BLDNAKitTool
//
//  Created by 朱俊杰 on 16/7/13.
//  Copyright © 2016年 Broadlink. All rights reserved.
//

#import "BLUITextFieldView.h"

@implementation BLUITextFieldView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView *leftImageview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.highlighted = NO;
        _leftImageView.contentMode = UIViewContentModeCenter;
        _leftImageView.center = leftImageview.center;
        [leftImageview addSubview:_leftImageView];
        
        self.leftView = leftImageview;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightbtnview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _rightButton = [[UIButton alloc]init];
        _rightButton.center = rightbtnview.center;
        [rightbtnview addSubview:_rightButton];
        
        self.rightView = rightbtnview;
    }
    
    return self;
}

@end
