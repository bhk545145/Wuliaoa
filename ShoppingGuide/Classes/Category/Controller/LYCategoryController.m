//
//  LYCategoryController.m
//  ShoppingGuide
//
//  Created by coderLL on 16/9/1.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import "LYCategoryController.h"
#import "LYSearchController.h"
#import "LYThemeCollectionController.h"
#import "LYCollectionDetailController.h"
#import "LYCategoryBottomView.h"

#import "SPKitExample.h"
#import "SPUtil.h"

@interface LYCategoryController ()<LYCategoryGroupDelegate>
@property (nonatomic, weak) UINavigationController *weakDetailNavigationController;
@end

@implementation LYCategoryController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupUI];
    [self _presentSplitControllerAnimated:YES];
}

- (void)_presentSplitControllerAnimated:(BOOL)aAnimated
{
    if ([self.view.window.rootViewController isKindOfClass:[UISplitViewController class]]) {
        /// 已经进入主页面
        return;
    }
    
    UISplitViewController *splitController = [[UISplitViewController alloc] init];
    
    if ([splitController respondsToSelector:@selector(setPreferredDisplayMode:)]) {
        [splitController setPreferredDisplayMode:UISplitViewControllerDisplayModeAllVisible];
    }
    
    /// 各个页面
    
    UINavigationController *masterController = nil, *detailController = nil;
    
    {
        /// 消息列表页面
        
        UIViewController *viewController = [[UIViewController alloc] init];
        [viewController.view setBackgroundColor:[UIColor whiteColor]];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        detailController = nvc;
    }
    
    
    
    
    {
        /// 会话列表页面
        __weak typeof(self) weakSelf = self;
        self.weakDetailNavigationController = detailController;
        
        YWConversationListViewController *conversationListController = [[SPKitExample sharedInstance] exampleMakeConversationListControllerWithSelectItemBlock:^(YWConversation *aConversation) {
            
            if ([weakSelf.weakDetailNavigationController.viewControllers.lastObject isKindOfClass:[YWConversationViewController class]]) {
                YWConversationViewController *oldConvController = weakSelf.weakDetailNavigationController.viewControllers.lastObject;
                if ([oldConvController.conversation.conversationId isEqualToString:aConversation.conversationId]) {
                    return;
                }
            }
            
            
            YWConversationViewController *convController = [[SPKitExample sharedInstance] exampleMakeConversationViewControllerWithConversation:aConversation];
            if (convController) {
                [weakSelf.weakDetailNavigationController popToRootViewControllerAnimated:NO];
                [weakSelf.weakDetailNavigationController pushViewController:convController animated:NO];
                
                /// 关闭按钮
                UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(actionCloseiPad:)];
                [convController.navigationItem setLeftBarButtonItem:closeItem];
            }
        }];
        
        masterController = [[UINavigationController alloc] initWithRootViewController:conversationListController];
        
        /// 注销按钮
        UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(actionLogoutiPad:)];
        [conversationListController.navigationItem setLeftBarButtonItem:logoutItem];
    }
    
    [splitController setViewControllers:@[masterController, detailController]];
    
    splitController.view.frame = self.view.window.bounds;
    [UIView transitionWithView:self.view.window
                      duration:0.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.view.window.rootViewController = splitController;
                    }
                    completion:nil];
}

//- (void)setupUI {
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Feed_SearchBtn_18x18_"] style:UIBarButtonItemStylePlain target:self action:@selector(categorySearchClick)];
//
//    // 设置下面的视图具体内容
//    [self setupScrollView];
//}
//
//- (void)setupScrollView {
//    UIScrollView *sc = [[UIScrollView alloc] init];
//    sc.frame = self.view.bounds;
//    [self.view addSubview:sc];
//    
//    LYThemeCollectionController *themeVc = [[LYThemeCollectionController alloc] init];
//    [self addChildViewController:themeVc];
//    themeVc.view.frame = CGRectMake(0, 0, MRScreenW, 140);
//    [sc addSubview:themeVc.view];
//    
//    LYCategoryBottomView *bottomView = [[LYCategoryBottomView alloc] init];
//    bottomView.frame = CGRectMake(0, CGRectGetMaxY(themeVc.view.frame) + 10, MRScreenW, MRScreenH - 150);
//    bottomView.groupDelegate = self;
//    
//    [sc addSubview:bottomView];
//}
//
//- (void)categorySearchClick {
//    LYSearchController *searchVc = [[LYSearchController alloc] init];
//    [self.navigationController pushViewController:searchVc animated:YES];
//}
//
//#pragma mark - <LYCategoryGroupDelegate>
//
//- (void)groupButtonItemClcik:(UIButton *)btn {
//    LYCollectionDetailController *detailVc = [[LYCollectionDetailController alloc] init];
//    detailVc.type = @"风格品类";
//    detailVc.id = btn.tag;
//    detailVc.title = btn.titleLabel.text;
//    [self.navigationController pushViewController:detailVc animated:YES];
//}



@end
