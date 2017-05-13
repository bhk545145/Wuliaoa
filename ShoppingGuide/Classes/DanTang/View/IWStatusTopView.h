//
//  IWStatusTopView.h
//  ItcastWeibo
//
//  Created by apple on 14-5-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  微博cell顶部的view

#import <UIKit/UIKit.h>
#import "IWPhotosView.h"
@class IWStatusFrame;
@interface IWStatusTopView : UIImageView
@property (nonatomic, strong) IWStatusFrame *statusFrame;
/** 配图 */
@property (nonatomic, weak) IWPhotosView *photosView;
@end
