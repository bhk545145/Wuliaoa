//
//  LYActionSheetView.h
//  ShoppingGuide
//
//  Created by CoderLL on 16/9/6.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IWStatus;
@interface LYActionSheetView : UIView
@property (nonatomic,strong) IWStatus *status;
+ (void)show;
+ (void)showStatus:(IWStatus *)status;
@end
