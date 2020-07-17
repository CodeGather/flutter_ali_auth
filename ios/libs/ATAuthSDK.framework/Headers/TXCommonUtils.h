//
//  TXCommonUtils.h
//  authsdk
//
//  Created by yangli on 12/03/2018.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TX_Auth_Result_Success      @"6666"
#define TX_Auth_Result_TimeOut      @"5555"
#define TX_Auth_Result_Fail         @"4444"
#define TX_Auth_Result_No_SIM_Card  @"1111"
#define TX_Auth_Result_No_Network   @"2222"
#define TX_Auth_Result_Other_Err    @"3333"
#define TX_Auth_Result_Param_Err    @"3344"
#define TX_Auth_Result_Demotion     @"4445"
#define TX_Auth_Result_Limited      @"4446"

#define TX_Login_AuthPage_Show_Success      @"6665" // 授权页成功唤起事件
#define TX_Login_Return_Action              @"6667" // 点击了返回按钮
#define TX_Login_SSO_Action                 @"6668" // 点击了登录按钮(并成功获取了token)
#define TX_Login_Change_Action              @"6669" // 点击了切换按钮
#define TX_Login_CheckBox_Action            @"6670" // 点击了check box按钮 (注: 2.7.0以前的老接口对外暂时没有该回调)
#define TX_Login_Protocol_Action            @"6671" // 点击了协议按钮 (注: 2.7.0以前的老接口对外暂时没有该回调)
#define TX_Login_ClickLoginBtn_Action       @"6672" // 点击了登录按钮事件 (注: 2.7.0以前的老接口对外暂时没有该回调)

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
获取当前上网卡网络名称
@return 结果
*/
+ (NSString *)getCurrentMobileNetworkName;

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
 判断运营商是否改变，仅支持不同运营商改变，不支持相同运营商改变
 注：仅支持新接口，不支持warning系列的接口
 */
+ (BOOL)isChangedCarrier;

/**
通过颜色设置生成图片，支持弧度设置，比如一键登录按钮背景图片
*/
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isRoundedCorner:(BOOL )isRounded radius:(CGFloat)radius;

/**
 获取当前设备的唯一标识ID
 */
+ (NSString *)getUniqueID;



@end
