[![CircleCI](https://circleci.com/gh/CodeGather/flutter_ali_auth/tree/master.svg?style=svg)](https://circleci.com/gh/CodeGather/flutter_ali_auth/tree/master)
![Ali_auth workflow](https://github.com/CodeGather/flutter_ali_auth/actions/workflows/actions_analysis.yml/badge.svg)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/8f5d7a0c1e5b4efebcd0502df53a61d0)](https://www.codacy.com/gh/CodeGather/flutter_ali_auth/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=CodeGather/flutter_ali_auth&amp;utm_campaign=Badge_Grade)

# ali_auth

[![GitHub license](https://img.shields.io/github/license/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/issues)
[![GitHub forks](https://img.shields.io/github/forks/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/network)
[![GitHub stars](https://img.shields.io/github/stars/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/stargazers)
[![GitHub size](https://img.shields.io/github/repo-size/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth)
[![GitHub release](https://img.shields.io/github/v/release/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/releases)
[![GitHub dependency](https://img.shields.io/librariesio/github/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth)


## :large_blue_circle: Internationalization

English | [中文文档](README_zh.md)

This is a one click login plug-in for alicloud number authentication service
As other functions of the project use alicloud services, Alibaba cloud is also used in the one click login function, which is conducive to better maintenance in the later stage.
This plug-in is free, open source and highly customized. If you have any problems in use, you are welcome to give feedback. If you feel that this plug-in is not good enough, you can provide your valuable opinions,
If you want to customize in your own project, please modify the clone of this plug-in locally. However, you are welcome to release other versions of plug-ins after modifying through this plug-in,
However, when using or referring to the ideas or related contents of this plug-in, < H3 > < b > please indicate the source and link to this plug-in. Thank you for your cooperation. </b></h3>

## Since the front-end configuration parameters are used from 0.0.6, the modifications are relatively large. If you do not want to modify them, do not upgrade them to avoid unnecessary trouble

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
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/error_add.jpg" alt="cmcc_crash" width="100">

2、该插件已添加ATAuthSDK.framework，在编译时请勿将ATAuthSDK.framework重复添加，以免出现未知错误
如下图所示添加的为错误操作  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/error_add.jpg" alt="cmcc_crash" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/error_add2.png" alt="cmcc_crash" width="100">
  
- DEMO
  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/WechatIMG7.jpeg" alt="android截图1" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/WechatIMG6.jpeg" alt="android截图2" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/WechatIMG5.jpeg" alt="android截图3" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_4172.PNG" alt="ios截图1" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_4173.PNG" alt="ios截图2" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_4174.PNG" alt="ios截图3" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_0456.PNG" alt="ios截图4" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_0457.PNG" alt="ios截图5" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_4228.PNG" alt="ios截图6" width="100">

## Stargazers over time

[![Stargazers over time](https://starchart.cc/CodeGather/flutter_ali_auth.svg)](https://starchart.cc/CodeGather/flutter_ali_auth)

