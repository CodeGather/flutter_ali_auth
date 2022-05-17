//
//  TXModel.h
//  AliComSDKDemo
//
//  Created by 沈超 on 2019/11/5.
//  Copyright © 2019 alicom. All rights reserved.
//
#import <Flutter/Flutter.h>

#import <Foundation/Foundation.h>
#import <ATAuthSDK/ATAuthSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNSBuildModelUtils : NSObject

/// 
+ (FlutterViewController *) flutterVC;

/// 创建全屏的model
+ (TXCustomModel *)buildFullScreenModel;

/// 创建弹窗的model
+ (TXCustomModel *)buildAlertModel;

/// 创建全屏的model
+ (TXCustomModel *)buildNewFullScreenModel: (NSDictionary *) viewConfig selector:(SEL)selector target:(id)target;

/// 创建弹窗的model
+ (TXCustomModel *)buildNewAlertModel: (NSDictionary *) viewConfig selector:(SEL)selector target:(id)target;

@end

NS_ASSUME_NONNULL_END
