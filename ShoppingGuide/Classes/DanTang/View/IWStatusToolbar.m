//
//  IWStatusToolbar.m
//  ItcastWeibo
//
//  Created by apple on 14-5-11.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "IWStatusToolbar.h"
#import "IWStatus.h"
#import "AFNetworking.h"
#import "IWAccount.h"
#import "IWAccountTool.h"
#import "LYNetworkTool.h"
#import "SVProgressHUD.h"
#import "LYActionSheetView.h"


@interface IWStatusToolbar(){
    dispatch_queue_t queue;
}
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *dividers;
@property (nonatomic, weak) UIButton *reweetBtn;
@property (nonatomic, weak) UIButton *commentBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;
@property (nonatomic, weak) UIButton *hateBtn;
@end

@implementation IWStatusToolbar

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (NSMutableArray *)dividers
{
    if (_dividers == nil) {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        queue = dispatch_queue_create("latiaoQueue", DISPATCH_QUEUE_CONCURRENT);
        // 1.设置图片
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImageWithName:@""];
        self.highlightedImage = [UIImage resizedImageWithName:@""];
        
        // 2.添加按钮

        self.commentBtn = [self setupBtnWithTitle:@"评论" image:@"commenticon_textpage" bgImage:@"timeline_card_middlebottom_highlighted"];
        self.attitudeBtn = [self setupBtnWithTitle:@"赞" image:@"digupicon_comment" bgImage:@"digupicon_comment_press"];
        self.hateBtn = [self setupBtnWithTitle:@"踩" image:@"digdownicon_textpage" bgImage:@"digdownicon_textpage_press"];
                self.reweetBtn = [self setupBtnWithTitle:@"更多" image:@"moreicon_textpage" bgImage:@"timeline_card_leftbottom_highlighted"];
        
        // 3.添加分割线
        [self setupDivider];
        [self setupDivider];
        [self setupDivider];
        
        //4.指定tag

        self.commentBtn.tag = 101;
        self.attitudeBtn.tag = 102;
        self.hateBtn.tag = 103;
        self.reweetBtn.tag = 104;
        
    }
    return self;
}

/**
 *  初始化分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageWithName:@""];
    [self addSubview:divider];
    [self.dividers addObject:divider];
}

/**
 *  初始化按钮
 *
 *  @param title   按钮的文字
 *  @param image   按钮的小图片
 *  @param bgImage 按钮的背景
 */
- (UIButton *)setupBtnWithTitle:(NSString *)title image:(NSString *)image bgImage:(NSString *)bgImage
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageWithName:image] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btn.adjustsImageWhenHighlighted = NO;
    [btn setImage:[UIImage resizedImageWithName:bgImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(doButton1:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    // 添加按钮到数组
    [self.btns addObject:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.设置按钮的frame
    NSUInteger dividerCount = self.dividers.count; // 分割线的个数
    CGFloat dividerW = 2; // 分割线的宽度
    NSUInteger btnCount = self.btns.count;
    CGFloat btnW = (self.frame.size.width - dividerCount * dividerW) / btnCount;
    CGFloat btnH = self.frame.size.height;
    CGFloat btnY = 0;
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.btns[i];
        
        // 设置frame
        CGFloat btnX = i * (btnW + dividerW);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    // 2.设置分割线的frame
    CGFloat dividerH = btnH;
    CGFloat dividerY = 0;
    for (int j = 0; j<dividerCount; j++) {
        UIImageView *divider = self.dividers[j];
        
        // 设置frame
        UIButton *btn = self.btns[j];
        CGFloat dividerX = CGRectGetMaxX(btn.frame);
        divider.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    }
}

- (void)setStatus:(IWStatus *)status
{
    _status = status;
    
    // 1.设置转发数
    [self setupBtn:self.commentBtn originalTitle:@"评论" count:status.commentCount];
    [self setupBtn:self.attitudeBtn originalTitle:@"赞" count:status.likeCount];
    [self setupBtn:self.hateBtn originalTitle:@"踩" count:status.hateCount];
    [self setupBtn:self.reweetBtn originalTitle:@"更多" count:status.reposts_count];
}

/**
 *  设置按钮的显示标题
 *
 *  @param btn           哪个按钮需要设置标题
 *  @param originalTitle 按钮的原始标题(显示的数字为0的时候, 显示这个原始标题)
 *  @param count         显示的个数
 */
- (void)setupBtn:(UIButton *)btn originalTitle:(NSString *)originalTitle count:(int)count
{
    /**
     0 -> @"转发"
     <10000  -> 完整的数量, 比如个数为6545,  显示出来就是6545
     >= 10000
     * 整万(10100, 20326, 30000 ....) : 1万, 2万
     * 其他(14364) : 1.4万
     */
    
    if (count) { // 个数不为0
        NSString *title = nil;
        if (count < 10000) { // 小于1W
            title = [NSString stringWithFormat:@"%d", count];
        } else { // >= 1W
            // 42342 / 1000 * 0.1 = 42 * 0.1 = 4.2
            // 10742 / 1000 * 0.1 = 10 * 0.1 = 1.0
            // double countDouble = count / 1000 * 0.1;
            
            // 42342 / 10000.0 = 4.2342
            // 10742 / 10000.0 = 1.0742
            double countDouble = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", countDouble];
            
            // title == 4.2万 4.0万 1.0万 1.1万
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
        [btn setTitle:title forState:UIControlStateNormal];
    } else {
        [btn setTitle:originalTitle forState:UIControlStateNormal];
    }
}

- (void)doButton1:(UIButton *)sender{
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *URLString = [NSString stringWithFormat:@"%@/",IWArticleURL];
    NSString *URLtail;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    IWAccount *account = [IWAccountTool account];
    if(account){
        switch (sender.tag) {

            case 101:{
                IWLog(@"评论");
                break;
            }
            case 102:{
                IWLog(@"赞");
                URLtail = [NSString stringWithFormat:@"like/%@",_status.id];
                URLString = [URLString stringByAppendingString:URLtail];
                params[@"userId"] = account.id;
                dispatch_async(queue, ^{
                    [[LYNetworkTool sharedNetworkTool] loadDataInfoPost:URLString parameters:params success:^(id  _Nullable responseObject) {
                        IWLog(@"%@",responseObject);
                    } failure:^(NSError * _Nullable error) {
                        IWLog(@"%@",error);
                    }];
                });
                _btnblock();
                break;
            }
            case 103:{
                IWLog(@"踩");
                URLtail = [NSString stringWithFormat:@"hate/%@",_status.id];
                URLString = [URLString stringByAppendingString:URLtail];
                params[@"userId"] = account.id;
                dispatch_async(queue, ^{
                    [[LYNetworkTool sharedNetworkTool] loadDataInfoPost:URLString parameters:params success:^(id  _Nullable responseObject) {
                        IWLog(@"%@",responseObject);
                        
                    } failure:^(NSError * _Nullable error) {
                        IWLog(@"%@",error);
                    }];
                });
                _btnblock();
                break;
            }
            case 104:{
                IWLog(@"更多");
                [self shareItemClickStatus:_status];
                break;
            }
            default:{
                break;
            }
        }
        

    }else{
        [SVProgressHUD showErrorWithStatus:@"请先登录！"];
    }
}


// 点击分享
- (void)shareItemClickStatus:(IWStatus *)status {
    // 弹出分享框
    [LYActionSheetView showStatus:status];
}







@end
