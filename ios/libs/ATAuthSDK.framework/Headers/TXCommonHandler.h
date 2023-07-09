//
//  TXCommonHandler.h
//  ATAuthSDK
//
//  Created by yangli on 15/03/2018.

#import <Foundation/Foundation.h>
#import "TXCustomModel.h"
#import "PNSReporter.h"

typedef NS_ENUM(NSInteger, PNSAuthType) {
    PNSAuthTypeVerifyToken = 1,  //本机号码校验
    PNSAuthTypeLoginToken = 2    //一键登录
};

@interface TXCommonHandler : NSObject

/**
 *  获取该类的单例实例对象
 *  @return  单例实例对象
 */
+ (instancetype _Nonnull )sharedInstance;

/**
 *  获取当前SDK版本号
 *  @return  字符串，sdk版本号
 */
- (NSString *_Nonnull)getVersion;

/**
 *  初始化SDK调用参数，app生命周期内调用一次
 *  @param  info app对应的秘钥
 *  @param  complete 结果异步回调到主线程，成功时resultDic=@{resultCode:600000, msg:...}，其他情况时"resultCode"值请参考PNSReturnCode
 */
- (void)setAuthSDKInfo:(NSString * _Nonnull)info complete:(void(^_Nullable)(NSDictionary * _Nonnull resultDic))complete;

/**
 *  检查当前环境是否支持一键登录或号码认证，resultDic 返回 PNSCodeSuccess 说明当前环境支持
 *  @param  authType 服务类型 PNSAuthTypeVerifyToken 本机号码校验流程，PNSAuthTypeLoginToken 一键登录流程
 *  @param  complete 结果异步回调到主线程，成功时resultDic=@{resultCode:600000, msg:...}，其他情况时"resultCode"值请参考PNSReturnCode，只有成功回调才能保障后续接口调用
 */
- (void)checkEnvAvailableWithAuthType:(PNSAuthType)authType complete:(void (^_Nullable)(NSDictionary * _Nullable resultDic))complete;

/**
 *  加速获取本机号码校验token，防止调用 getVerifyTokenWithTimeout:complete: 获取token时间过长
 *  @param  timeout 接口超时时间，单位s，默认为3.0s
 *  @param  complete 结果异步回调到主线程，成功时resultDic=@{resultCode:600000, token:..., msg:...}，其他情况时"resultCode"值请参考PNSReturnCode
 */
- (void)accelerateVerifyWithTimeout:(NSTimeInterval)timeout complete:(void (^_Nullable)(NSDictionary * _Nonnull resultDic))complete;

/**
 *  获取本机号码校验Token
 *  @param  timeout 接口超时时间，单位s，默认为3.0s
 *  @param  complete 结果异步回调到主线程，成功时resultDic=@{resultCode:600000, token:..., msg:...}，其他情况时"resultCode"值请参考PNSReturnCode
 */
- (void)getVerifyTokenWithTimeout:(NSTimeInterval)timeout complete:(void (^_Nullable)(NSDictionary * _Nonnull resultDic))complete;

/**
 *  加速一键登录授权页弹起，防止调用 getLoginTokenWithTimeout:controller:model:complete: 等待弹起授权页时间过长
 *  @param  timeout 接口超时时间，单位s，默认为3.0s
 *  @param  complete 结果异步回调到主线程，成功时resultDic=@{resultCode:600000, msg:...}，其他情况时"resultCode"值请参考PNSReturnCode
 */
- (void)accelerateLoginPageWithTimeout:(NSTimeInterval)timeout complete:(void (^_Nullable)(NSDictionary * _Nonnull resultDic))complete;

/**
 *  获取一键登录Token，调用该接口首先会弹起授权页，点击授权页的登录按钮获取Token
 *  @warning 注意的是，如果前面没有调用 accelerateLoginPageWithTimeout:complete: 接口，该接口内部会自动先帮我们调用，成功后才会弹起授权页，所以有一个明显的等待过程
 *  @param  timeout 接口超时时间，单位s，默认为3.0s
 *  @param  controller 唤起自定义授权页的容器，内部会对其进行验证，检查是否符合条件
 *  @param  model 自定义授权页面选项，可为nil，采用默认的授权页面，具体请参考TXCustomModel.h文件
 *  @param  complete 结果异步回调到主线程，"resultDic"里面的"resultCode"值请参考PNSReturnCode，如下：
 *
 *          授权页控件点击事件：700000（点击授权页返回按钮）、700001（点击切换其他登录方式）、
 *          700002（点击登录按钮事件，根据返回字典里面的 "isChecked"字段来区分check box是否被选中，只有被选中的时候内部才会去获取Token）、700003（点击check box事件）、700004（点击协议富文本文字）
 接口回调其他事件：600001（授权页唤起成功）、600002（授权页唤起失败）、600000（成功获取Token）、600011（获取Token失败）、
 *          600015（获取Token超时）、600013（运营商维护升级，该功能不可用）、600014（运营商维护升级，该功能已达最大调用次数）.....
 */
- (void)getLoginTokenWithTimeout:(NSTimeInterval)timeout controller:(UIViewController *_Nonnull)controller model:(TXCustomModel *_Nullable)model complete:(void (^_Nullable)(NSDictionary * _Nonnull resultDic))complete;

/**
 *  此接口仅用于开发期间用于一键登录页面不同机型尺寸适配调试（可支持模拟器），非正式页面，手机掩码为0，不能正常登录，请开发者注意下
 *  @param  controller 唤起自定义授权页的容器，内部会对其进行验证，检查是否符合条件
 *  @param  model 自定义授权页面选项，可为nil，采用默认的授权页面，具体请参考TXCustomModel.h文件
 *  @param  complete 结果异步回调到主线程，"resultDic"里面的"resultCode"值请参考PNSReturnCode
 */
- (void)debugLoginUIWithController:(UIViewController *_Nonnull)controller model:(TXCustomModel *_Nullable)model complete:(void (^_Nullable)(NSDictionary * _Nonnull resultDic))complete;

/**
 *  授权页弹起后，修改checkbox按钮选中状态，当checkout按钮隐藏时，设置不生效
 */
- (void)setCheckboxIsChecked:(BOOL)isChecked;

/**
 *  手动隐藏一键登录获取登录Token之后的等待动画，默认为自动隐藏，当设置 TXCustomModel 实例 autoHideLoginLoading = NO 时, 可调用该方法手动隐藏
 */
- (void)hideLoginLoading;

/**
 *  注销授权页，建议用此方法，对于移动卡授权页的消失会清空一些数据
 *  @param flag 是否添加动画
 *  @param complete 成功返回
 */
- (void)cancelLoginVCAnimated:(BOOL)flag complete:(void (^_Nullable)(void))complete;

/**
 *  获取日志埋点相关控制对象
 */
- (PNSReporter * _Nonnull)getReporter;

/**
 关闭二次授权弹窗页
 */
- (void)closePrivactAlertView;



/**
 *  检查及准备调用环境，resultDic返回PNSCodeSuccess才能调用下面的功能接口
 *  @param  complete 结果异步回调到主线程，成功时resultDic=@{resultCode:600000, msg:...}，其他情况时"resultCode"值请参考PNSReturnCode，只有成功回调才能保障后续接口调用
 */
- (void)checkEnvAvailableWithComplete:(void (^_Nullable)(NSDictionary * _Nullable resultDic))complete DEPRECATED_MSG_ATTRIBUTE("Please use checkEnvAvailableWithAuthType:complete: instead");

@end
