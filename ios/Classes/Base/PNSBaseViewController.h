//
//  PNSBaseViewController.h
//  ATAuthSceneDemo
//
//  Created by Yau的MacBook on 2022/5/19.
//  Copyright © 2022 Yau的MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNSBaseViewController : UIViewController

/**
 *  负责初始化和设置controller里面的view，也就是self.view的subView。目的在于分类代码，所以与view初始化的相关代码都写在这里。
 *
 *  @warning initSubviews只负责subviews的init，不负责布局。布局相关的代码应该写在 <b>viewDidLayoutSubviews</b>
 */
- (void)initSubviews NS_REQUIRES_SUPER;

/**
 *  负责布局controller里面的view，也就是self.view的subView。目的在于分类代码，所以与view初始化的相关代码都写在这里。
 *
 *  @warning setLayoutSubviews只负责布局subviews的约束
 */
- (void)setLayoutSubviews;

/// 是否需要将状态栏改为浅色文字，默认为浅文字色
- (BOOL)shouldSetStatusBarStyleLight;

/// 是否影藏电池栏 (默认不影藏)
- (BOOL)shouldHiddenStatusBar;

@end

NS_ASSUME_NONNULL_END
