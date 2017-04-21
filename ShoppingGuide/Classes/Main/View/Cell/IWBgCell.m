//
//  IWBgCell.m
//  示例-ItcastWeibo
//
//  Created by MJ Lee on 14-5-4.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWBgCell.h"

@implementation IWBgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *bg = [[UIImageView alloc] init];
        self.backgroundView = bg;
        self.bg = bg;
        
        UIImageView *selectedBg = [[UIImageView alloc] init];
        self.selectedBackgroundView = selectedBg;
        self.selectedBg = selectedBg;
    }
    return self;
}

@end
