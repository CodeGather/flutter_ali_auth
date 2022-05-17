//
//  TXCommonUtils.h
//  authsdk
//
//  Created by yangli on 12/03/2018.

#import <Foundation/Foundation.h>

@interface TXCommonUtils : NSObject

/**
 判断当前设备蜂窝数据网络是否开启，即3G/4G
 @return 结果
 */
+ (BOOL)checkDeviceCellularDataEnable;

/**
判断当前上网卡运营商是否是中国联通
@return 结果
*/
+ (BOOL)isChinaUnicom;

/**
判断当前上网卡运营商是否是中国移动
@return 结果
*/
+ (BOOL)isChinaMobile;

/**
判断当前上网卡运营商是否是中国电信
@return 结果
*/
+ (BOOL)isChinaTelecom;

/**
获取当前上网卡运营商名称，比如中国移动、中国电信、中国联通
@return 结果
*/
+ (NSString *)getCurrentCarrierName;

/**
获取当前上网卡网络类型，比如WiFi，4G
@return 结果
*/
+ (NSString *)getNetworktype;

/**
判断当前设备是否有SIM卡
@return 结果
*/
+ (BOOL)simSupportedIsOK;

/**
 判断wwan是否开着（通过p0网卡判断，无wifi或有wifi情况下都能检测到）
 @return 结果
 */
+ (BOOL)isWWANOpen;

/**
 判断wwan是否开着（仅无wifi情况下）
 @return 结果
 */
+ (BOOL)reachableViaWWAN;

/**
 获取设备当前网络私网IP地址
  @return 结果
 */
+ (NSString *)getMobilePrivateIPAddress:(BOOL)preferIPv4;

/**
 获取当前设备的唯一标识ID
 */
+ (NSString *)getUniqueID;

/**
通过颜色设置生成图片，支持弧度设置，比如一键登录按钮背景图片
*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isRoundedCorner:(BOOL )isRounded radius:(CGFloat)radius;

@end
