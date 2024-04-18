[![Pub](https://img.shields.io/pub/v/ali_auth.svg)](https://pub.flutter-io.cn/packages/ali_auth)
![example workflow](https://github.com/CodeGather/flutter_ali_auth/actions/workflows/build.yml/badge.svg)
![example workflow](https://github.com/CodeGather/flutter_ali_auth/actions/workflows/release.yml/badge.svg)
![example workflow](https://github.com/CodeGather/flutter_ali_auth/actions/workflows/publish.yml/badge.svg)


# ali_auth

[![GitHub license](https://img.shields.io/github/license/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/issues)
[![GitHub forks](https://img.shields.io/github/forks/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/network)
[![GitHub stars](https://img.shields.io/github/stars/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/stargazers)
[![GitHub size](https://img.shields.io/github/repo-size/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth)
[![GitHub release](https://img.shields.io/github/v/release/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/releases)
[![GitHub dependency](https://img.shields.io/librariesio/github/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth)


## :large_blue_circle: Internationalization

English | [中文文档](README.md)

This is a one click login plug-in for alicloud number authentication service
As other functions of the project use alicloud services, Alibaba cloud is also used in the one click login function, which is conducive to better maintenance in the later stage.
This plug-in is free, open source and highly customized. If you have any problems in use, you are welcome to give feedback. If you feel that this plug-in is not good enough, you can provide your valuable opinions,
If you want to customize in your own project, please modify the clone of this plug-in locally. However, you are welcome to release other versions of plug-ins after modifying through this plug-in,
However, when using or referring to the ideas or related contents of this plug-in,   
 
# Please indicate the source and link to this plug-in. Thank you for your cooperation.  


## In order to solve most of the problems and repair a large number of bugs, the refactored version is used from 1.0.0. The API may be adjusted during use. I hope all partners can update the new version and continue to maintain it later.    
 

## Refactoring version 1.0.0 - focus!!!!!!! Please put this part in the manifest file of the app. Please refer to the demo settings for details

## Related support

|    platform  | support  |
| :------:|:----:|
| Android  | YES |
| Ios      | YES |

## code click response

|    响应码  | 响应码描述  |
| :--------:|:----------:|
| 700000    | 点击返回按钮，⽤户取消免密登录（android 物理按钮/虚拟返回按钮暂未实现）请自行使用flutter替代 |
| 700001    | 点击切换按钮，⽤户取消免密登录 |
| 700002    | 点击登录按钮事件 |
| 700003    | 点击check box事件 |
| 700004    | 点击协议富⽂本⽂字事件 |
| 700005    | 点击点击第三方按钮事件 |

## 步骤

- [帮助文档](https://help.aliyun.com/product/75010.html)
- [前往添加号码认证方案-获取秘钥](https://dypns.console.aliyun.com/?spm=5176.12818093.favorites.ddypns.488716d0ttKe13#/)
- 使用秘钥初始化环境 AliAuthPlugin.initSdk()

## matters needing attention

1、 针对移动闪退问题：
在示范工程，pods -> TARGETS -> ali_auth -> Build Settings -> Linking -> Other Linker Flags 里面加上 -ObjC（因为AuthSDK是通过pod依赖进去的，所有对应的target里面要加这个配置，不然移动网络会crash）
如下图所示：  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/error_add.jpg" alt="cmcc_crash" width="100">

2、该插件已添加ATAuthSDK.framework，在编译时请勿将ATAuthSDK.framework重复添加，以免出现未知错误
如下图所示添加的为错误操作  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/error_add.jpg" alt="cmcc_crash" width="110"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/error_add2.png" alt="cmcc_crash" width="200">
  
## Install    
```
dependencies:
  ali_auth:
    git:
      url: https://github.com/CodeGather/flutter_ali_auth.git
```

## DEMO    
  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_123128.jpg" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_120625.jpg" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_120629.jpg" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_120634.jpg" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/Screenshot_20220517_120649.jpg" width="100">
  
## VIDEO
  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/SVID_20220517_120504.gif" width="100"> 

## Reward

<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/play_al.jpg" width="200"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/play_wx.jpg" width="222">  

## QQ Group chat

<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshots/play_qq.jpg" width="200">

## Stargazers over time

[![Stargazers over time](https://starchart.cc/CodeGather/flutter_ali_auth.svg)](https://starchart.cc/CodeGather/flutter_ali_auth)

