//
//  IWCommitCell.h
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/3/21.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IWCommit;
@interface IWCommitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarimage;
@property (weak, nonatomic) IBOutlet UILabel *userNamelab;
@property (weak, nonatomic) IBOutlet UILabel *contentlab;
@property (weak, nonatomic) IBOutlet UILabel *createTime;


@property (nonatomic,strong) IWCommit *commit;
@end
