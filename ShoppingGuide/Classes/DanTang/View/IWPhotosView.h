//
//  IWPhotosView.h
//  ItcastWeibo
//
//  Created by apple on 14-5-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface IWPhotosView : UIView
/**
 *  需要展示的图片(数组里面装的都是IWPhoto模型)
 */
@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, strong) MPMoviePlayerViewController *playerController;

typedef void (^playBlock)(NSURL *);
@property playBlock btnblock;
/**
 *  根据图片的个数返回相册的最终尺寸
 */
+ (CGSize)photosViewSizeWithPhotosCount:(int)count;
@end
