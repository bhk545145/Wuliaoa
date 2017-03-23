//
//  IWCommitCell.m
//  ShoppingGuide
//
//  Created by 白洪坤 on 2017/3/21.
//  Copyright © 2017年 Andrew554. All rights reserved.
//

#import "IWCommitCell.h"
#import "IWCommit.h"
#import "UIImageView+WebCache.h"

@implementation IWCommitCell

- (void)setCommit:(IWCommit *)commit {
    _commit = commit;
    [self.userAvatarimage sd_setImageWithURL:[NSURL URLWithString:commit.userAvatar]];
    self.userNamelab.text = commit.userName;
    self.contentlab.text = commit.content;
    self.createTime.text = commit.createTime;
}
@end
