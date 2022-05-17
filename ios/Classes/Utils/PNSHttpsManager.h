//
//  PNSHttpsManager.h
//  ATAuthSceneDemo
//
//  Created by 刘超的MacBook on 2020/8/11.
//  Copyright © 2020 刘超的MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PNSHttpsManager : NSObject

/// 从自己服务器获取 ATAuthSDK 秘钥
+ (void)requestATAuthSDKInfo:(void(^)(BOOL isSuccess, NSString *authSDKInfo))block;

/// 去服务端校验本机号码校验Token是否和当前手机号一致
+ (void)requstVerifyWithNumber:(NSString *)number token:(NSString *)token block:(void(^)(BOOL isSuccess, NSString *msg))block;

/// 用一键登录Token去服务端换取手机号
+ (void)requestLoginWithToken:(NSString *)token block:(void(^)(BOOL isSuccess, NSString *phoneNumber))block;

@end

NS_ASSUME_NONNULL_END
