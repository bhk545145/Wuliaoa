//
//  HostViewController.h
//  EVNEstorePlatform
//
//  Created by developer on 2016/12/30.
//  Copyright © 2016年 仁伯安. All rights reserved.
//

#import "BaseViewController.h"
#import "HotWordSearchViewController.h"
#import "EVNSearchBar.h"

@interface HostViewController : BaseViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, EVNSearchBarDelegate, HotWordSearchViewDelegate>

/**
 *  searchBar
 */
@property (strong, nonatomic) EVNSearchBar *searchBar;

@end


