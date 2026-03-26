//
//  YTXNetUtils.h
//  YTXOperators
//
//  Created by yangli on 2020/11/9.
//  Copyright © 2020 com.alicom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTXNetUtils : NSObject

/**
 判断当前设备蜂窝数据网络是否开启，即3G/4G
 @return 结果
 */
- (BOOL)checkDeviceCellularDataEnable;

/**
判断当前上网卡运营商是否是中国联通
@return 结果
*/
- (BOOL)isChinaUnicom;

/**
判断当前上网卡运营商是否是中国移动
@return 结果
*/
- (BOOL)isChinaMobile;

/**
判断当前上网卡运营商是否是中国电信
@return 结果
*/
- (BOOL)isChinaTelecom;

/**
获取当前上网卡运营商名称，比如中国移动、中国电信、中国联通
@return 结果
*/
- (NSString *)getCurrentCarrierName;

/**
获取当前上网卡运营商编码，比如46000、46001、46003
@return 结果
*/
- (NSString *)getCurrentCarrierCode API_DEPRECATED("废弃，完成不可用，返回空字符串", ios(4.0, 16.0));

/**
获取当前上网卡网络类型，比如WiFi，4G
@return 结果
*/
- (NSString *)getNetworktype;

/**
判断当前设备是否有SIM卡
@return 结果
*/
- (BOOL)simSupportedIsOK;

/**
 判断wwan是否开着（通过p0网卡判断，无wifi或有wifi情况下都能检测到）
 @return 结果
 */
- (BOOL)isWWANOpen;

/**
 判断WiFi是否开着
 @return 结果
 */
- (BOOL)isWiFiOpen;

/**
 判断wwan是否开着（仅无wifi情况下）
 @return 结果
 */
- (BOOL)reachableViaWWAN;

/**
 获取设备当前网络私网IP地址
  @return 结果
 */
- (NSString *)getMobilePrivateIPAddress:(BOOL)preferIPv4;

/**
获取双卡设备下，非上网卡信息
 @return 结果
*/
- (NSString *)getOptionalCarrierInfo API_DEPRECATED("废弃，完成不可用，返回空字符串", ios(4.0, 16.0));;

/**
 获取当前蜂网络Ip地址
 */
- (NSString *)getCellularIp;

@end

NS_ASSUME_NONNULL_END
