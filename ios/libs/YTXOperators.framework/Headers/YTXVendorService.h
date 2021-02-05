//
//  YTXVendorService.h
//  ATAuthSDK
//
//  Created by 刘超的MacBook on 2020/1/15.
//  Copyright © 2020. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTXVendorService : NSObject

/**
*  获取SDK版本号
*/
+ (NSString *)getVersion;

/**
*  获取供应商SDK版本号
*/
+ (NSDictionary *)getVendorsVersion;

/**
 *  初始化或更新各个供应商的接口调用对象，根据各个供应商的配置信息
 *  @param  vendorConfigs 各个供应商配置信息
 */
- (void)updateVendorHandlers:(NSArray *)vendorConfigs;

/**
 *  获取本机号码校验Token
 *  @param  request 请求参数结构体
 *  @param  vendorConfig 当前供应商配置信息
 *  @param  complete 结果回调
 */
- (void)getVerifyTokenWithRequest:(NSDictionary *)request
                     vendorConfig:(NSDictionary *)vendorConfig
                         complete:(void(^)(NSDictionary *response))complete;

/**
 *  获取手机掩码
 *  @param  request 请求参数结构体
 *  @param  vendorConfig 当前供应商配置信息
 *  @param  complete 结果回调
 */
- (void)getMaskNumberWithRequest:(NSDictionary *)request
                    vendorConfig:(NSDictionary *)vendorConfig
                        complete:(void(^)(NSDictionary *response))complete;


/**
 *  电信/联通获取一键登录Token
 *  @param  request 请求参数结构体
 *  @param  vendorConfig 当前供应商配置信息
 *  @param  complete 结果回调
 *  @abstract  移动的获取登录Token不走这个回调，走弹起授权页的回调
 */
- (void)getLoginTokenWithRequest:(NSDictionary *)request
                    vendorConfig:(NSDictionary *)vendorConfig
                        complete:(void(^)(NSDictionary *response))complete;

- (void)deleteCacheWithVendorConfigs:(NSArray *)vendorConfigs;

@end

NS_ASSUME_NONNULL_END
