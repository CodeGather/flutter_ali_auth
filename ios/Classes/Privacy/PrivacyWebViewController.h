//
//  PrivacyWebViewController.h
//  ATAuthSceneDemo
//
//  Created by Yau的MacBook on 2022/5/19.
//  Copyright © 2022 Yau的MacBook. All rights reserved.
//

#import "PNSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrivacyWebViewController : PNSBaseViewController

- (instancetype)initWithUrl:(NSString *)url andUrlName:(NSString *)urlName;

/// 是否隐藏系统的导航栏
@property (nonatomic, assign) BOOL isHiddenNavgationBar;

@end

NS_ASSUME_NONNULL_END
