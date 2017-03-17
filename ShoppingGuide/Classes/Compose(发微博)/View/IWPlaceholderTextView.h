//
//  IWPlaceholderTextView.h
//  ItcastWeibo
//
//  Created by mj on 14-1-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  有占位文字的TextView

#import <UIKit/UIKit.h>

@interface IWPlaceholderTextView : UITextView
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) UIColor *placeholderColor;
@end
