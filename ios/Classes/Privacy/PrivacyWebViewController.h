//
//  PrivacyWebViewController.h
//  ATAuthSceneDemo
//
//  Created by 小明 on 2022/1/5.
//  Copyright © 2022 刘超的MacBook. All rights reserved.
//

#import "PNSBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrivacyWebViewController : PNSBaseViewController

- (instancetype)initWithUrl:(NSString *)url andUrlName:(NSString *)urlName;

/// 是否隐藏系统的导航栏
@property (nonatomic, assign) BOOL isHiddenNavgationBar;

@end

NS_ASSUME_NONNULL_END
