//
//  TXModel.h
//  AliComSDKDemo
//
//  Created by 沈超 on 2019/11/5.
//  Copyright © 2019 alicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ATAuthSDK/ATAuthSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNSBuildModelUtils : NSObject

/// 创建全屏的model
+ (TXCustomModel *)buildFullScreenModel;

/// 创建弹窗的model
+ (TXCustomModel *)buildAlertModel;

@end

NS_ASSUME_NONNULL_END
