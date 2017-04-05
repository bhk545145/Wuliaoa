//
//  LYLikeCell.m
//  ShoppingGuide
//
//  Created by coderLL on 16/9/20.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import "LYLikeCell.h"
#import "UIImageView+WebCache.h"
#import "LYItem.h"
#import "IWStatus.h"

@interface LYLikeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation LYLikeCell

- (void)setItem:(LYItem *)item {
    _item = item;
    
    self.title.text = item.title;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:item.cover_image_url]];
}

- (void)setStatus:(IWStatus *)status {
    _status = status;
    
    self.title.text = status;
//    [self.imageV sd_setImageWithURL:[NSURL URLWithString:status.authorAvatar]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
