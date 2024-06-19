[![Pub](https://img.shields.io/pub/v/ali_auth.svg)](https://pub.flutter-io.cn/packages/ali_auth)
![example workflow](https://github.com/CodeGather/flutter_ali_auth/actions/workflows/build.yml/badge.svg)
![example workflow](https://github.com/CodeGather/flutter_ali_auth/actions/workflows/release.yml/badge.svg)
![example workflow](https://github.com/CodeGather/flutter_ali_auth/actions/workflows/publish.yml/badge.svg)


[![GitHub license](https://img.shields.io/github/license/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/issues)
[![GitHub forks](https://img.shields.io/github/forks/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/network)
[![GitHub stars](https://img.shields.io/github/stars/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/stargazers)
[![GitHub size](https://img.shields.io/github/repo-size/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth)
[![GitHub release](https://img.shields.io/github/v/release/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/releases)

## :large_blue_circle: 国际化

中文文档 | [English](README_en.md)

这是一个阿里云号码认证服务中的一键登录的插件

由于项目的其他功能都采用阿里云的服务，在一键登录的功能上也采用阿里云利于后期的更好维护。
本插件免费开源，高定制，如果在使用中有什么问题，欢迎反馈，如果觉得本插件还不够好可以提供您的宝贵意见，
如果你想在自己项目中定制，请将本插件clone为本地进行修改，但是通过本插件进行修改后发布其他版本的插件也欢迎，
但是在使用或者参考了本插件的思路或者相关内容，   

# 请注明出处并且链接到本插件，谢谢您的配合。  

# v1.1.9版本同步更新阿里云的sdk升级，请注意升级，否则不能使用原来的密钥升级方案请参考 [升级文档](https://help.aliyun.com/zh/pnvs/product-overview/upgrade-phone-number-verification-service-sdk-standard-edition)

```
<!-- 全屏时使用主题 android:theme="@android:style/Theme.NoTitleBar.Fullscreen" -->
<!-- 弹窗时使用主题 android:theme="@style/authsdk_activity_dialog" -->
<!-- 如果不需要使用窗口模式，不要使用authsdk_activity_dialog主题，会出现异常动画-->
<!-- 如果需要使用authsdk_activity_dialog主题，则screenOrientation一定不能指定明确的方向，
比如portrait、sensorPortrait，在8.0的系统上不允许窗口模式指定orientation，会发生crash，需要指定为behind，
然后在授权页的前一个页面指定具体的orientation-->

<!--协议页面webview-->
<activity
    android:name="com.mobile.auth.gatewayauth.activity.AuthWebVeiwActivity"
    android:configChanges="orientation|keyboardHidden|screenSize"
    tools:replace="android:theme"
    android:exported="false"
    android:launchMode="singleTop"
    android:screenOrientation="behind"
    android:theme="@style/authsdk_activity_dialog" />

<!--联通电信授权页-->
<activity
    android:name="com.mobile.auth.gatewayauth.LoginAuthActivity"
    android:configChanges="orientation|keyboardHidden|screenSize"
    tools:replace="android:configChanges"
    android:exported="false"
    android:launchMode="singleTop"
    android:screenOrientation="behind"
    android:theme="@style/authsdk_activity_dialog"/>

<!--移动授权页-->
<activity
    android:name="com.cmic.sso.sdk.activity.LoginAuthActivity"
    android:configChanges="orientation|keyboardHidden|screenSize"
    tools:replace="android:configChanges"
    android:exported="false"
    android:launchMode="singleTask"
    android:screenOrientation="behind"
    android:theme="@style/authsdk_activity_dialog" />
```

## 相关支持

|    平台  | 支持  |
| :------:|:----:|
| Android  | YES |
| Ios      | YES |


## 授权⻚点击事件响应码 

|    响应码  | 响应码描述  |
| :--------:|:----------:|
| 700000    | 点击返回按钮，⽤户取消免密登录（android 物理按钮/虚拟返回按钮暂未实现）请自行使用flutter替代 |
| 700001    | 点击切换按钮，⽤户取消免密登录 |
| 700002    | 点击登录按钮事件 |
| 700003    | 点击check box事件 |
| 700004    | 点击协议富⽂本⽂字事件 |
| 700005    | 点击点击第三方按钮事件 |

## 步骤
- 1、配置APP的签名安装于手机
- 2、获取签名APK文件下载地址：[点击下载快速获取签名工具](https://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/87870/cn_zh/1534313766610/AppSignGet.apk)
- 3、使用签名APP获取签名
- 4、配置appid+秘钥，阿里云后台配置签名，注意签名要和APP配置的签名一致，否则无法使用
- [帮助文档](https://help.aliyun.com/product/75010.html)
- [前往添加号码认证方案-获取秘钥](https://dypns.console.aliyun.com/?spm=5176.12818093.favorites.ddypns.488716d0ttKe13#/)
- 使用秘钥初始化环境 AliAuthPlugin.initSdk()

## 注意事项

关于点击事件穿透问题
## [参考一](https://www.jianshu.com/p/88d45977d482) [参考二](https://github.com/flutter/flutter/issues/35784)

1、 针对移动闪退问题：
在示范工程，pods -> TARGETS -> ali_auth -> Build Settings -> Linking -> Other Linker Flags 里面加上 -ObjC（因为AuthSDK是通过pod依赖进去的，所有对应的target里面要加这个配置，不然移动网络会crash）
如下图所示：  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/error_add.jpg" alt="cmcc_crash" width="100">

2、该插件已添加ATAuthSDK.framework，在编译时请勿将ATAuthSDK.framework重复添加，以免出现未知错误
如下图所示添加的为错误操作  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/error_add.jpg" alt="cmcc_crash" width="110"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/error_add2.png" alt="cmcc_crash" width="200">

## 实验安装    
```
dependencies:
   ali_auth:
      git:
        url: https://github.com/CodeGather/flutter_ali_auth.git
```

## DEMO截图    
  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_123128.jpg" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_120625.jpg" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_120629.jpg" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_120634.jpg" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_120649.jpg" width="100"> 
  
## 演示
  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/SVID_20220517_120504.gif" width="100"> 

## 如果你觉得不错欢迎打赏

<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/play_al.jpg" width="200"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/play_wx.jpg" width="222">  

## 知识星球
### 为了不浪费大家宝贵的时间，也迫于现实的压力，如果你想获取更优质的服务欢迎加入知识星球，提供的服务远比一杯咖啡更有性价比

<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/zsxq.png" width="400">  

## 关注趋势

[![Stargazers over time](https://starchart.cc/CodeGather/flutter_ali_auth.svg)](https://starchart.cc/CodeGather/flutter_ali_auth)
