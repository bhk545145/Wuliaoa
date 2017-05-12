//
//  IWPhotoView.m
//  ItcastWeibo
//
//  Created by apple on 14-5-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWPhotoView.h"
#import "IWPhoto.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+Layout.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController/TZImagePickerController.h"

@interface IWPhotoView()
@property (nonatomic, weak) UIImageView *gifView;
@property (nonatomic, strong) UIImageView *videoImageView;
@end

@implementation IWPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加一个GIF小图片
        UIImage *image = [UIImage imageWithName:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        self.gifView = gifView;
        
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.hidden = YES;
        [self addSubview:_videoImageView];
    }
    return self;
}

- (void)setPhoto:(IWPhoto *)photo
{
    _photo = photo;
    // 控制gifView的可见性
    self.gifView.hidden = ![photo.thumbnailUrl containsString:@"gif"];
    // 控制videoImageView的可见性
    if ([photo.thumbnailUrl containsString:@"mp4"]) {
        _videoImageView.hidden = NO;
    }
    
    // 下载图片
    [self setImageWithURL:[NSURL URLWithString:photo.thumbnailUrl] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifView.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height);
    
    CGFloat width = self.tz_width / 3.0;
    _videoImageView.frame = CGRectMake(width, width, width, width);
}

@end
