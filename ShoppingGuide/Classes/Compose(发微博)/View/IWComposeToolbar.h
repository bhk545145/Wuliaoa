//
//  IWComposeToolbar.h
//  ItcastWeibo
//
//  Created by MJ Lee on 14-5-18.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IWComposeToolbarButtonTypeCamera,
    IWComposeToolbarButtonTypePicture,
    IWComposeToolbarButtonTypeMention,
    IWComposeToolbarButtonTypeTrend,
    IWComposeToolbarButtonTypeEmotion
} IWComposeToolbarButtonType;

@class IWComposeToolbar;

@protocol IWComposeToolbarDelegate <NSObject>
@optional
- (void)composeToolbar:(IWComposeToolbar *)toolbar didClickedButton:(IWComposeToolbarButtonType)buttonType;
@end

@interface IWComposeToolbar : UIView
@property (weak, nonatomic) id<IWComposeToolbarDelegate> delegate;
@end
