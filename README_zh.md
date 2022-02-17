# ali_auth

[![GitHub license](https://img.shields.io/github/license/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/issues)
[![GitHub forks](https://img.shields.io/github/forks/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/network)
[![GitHub stars](https://img.shields.io/github/stars/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/stargazers)
[![GitHub size](https://img.shields.io/github/repo-size/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth)
[![GitHub release](https://img.shields.io/github/v/release/CodeGather/flutter_ali_auth?style=social)](https://github.com/CodeGather/flutter_ali_auth/releases)

## :large_blue_circle: 国际化

[English](README.md) | 中文文档

这是一个阿里云号码认证服务中的一键登录的插件

由于项目的其他功能都采用阿里云的服务，在一键登录的功能上也采用阿里云利于后期的更好维护。
本插件免费开源，高定制，如果在使用中有什么问题，欢迎反馈，如果觉得本插件还不够好可以提供您的宝贵意见，
如果你想在自己项目中定制，请将本插件clone为本地进行修改，但是通过本插件进行修改后发布其他版本的插件也欢迎，
但是在使用或者参考了本插件的思路或者相关内容，<h3><b>请注明出处并且链接到本插件，谢谢您的配合。</b></h3>

## 由于从0.0.6开始使用前端配置参数，所以修改的比较大，如果不想修改请勿进行升级，以免造成不必要的麻烦

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

董敬龙:异常动画在个别机型会有 效果不明显  如果你想要全屏和弹窗同时使用那就避免不了
董敬龙:或者你们可以选择不设置动画

1、 针对移动闪退问题：
在示范工程，pods -> TARGETS -> ali_auth -> Build Settings -> Linking -> Other Linker Flags 里面加上 -ObjC（因为AuthSDK是通过pod依赖进去的，所有对应的target里面要加这个配置，不然移动网络会crash）
如下图所示：  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/error_add.jpg" alt="cmcc_crash" width="100">

2、该插件已添加ATAuthSDK.framework，在编译时请勿将ATAuthSDK.framework重复添加，以免出现未知错误
如下图所示添加的为错误操作  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/error_add.jpg" alt="cmcc_crash" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/error_add2.png" alt="cmcc_crash" width="100">
  
- DEMO效果入下
  
<img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/WechatIMG7.jpeg" alt="android截图1" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/WechatIMG6.jpeg" alt="android截图2" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/WechatIMG5.jpeg" alt="android截图3" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_4172.PNG" alt="ios截图1" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_4173.PNG" alt="ios截图2" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_4174.PNG" alt="ios截图3" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_0456.PNG" alt="ios截图4" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_0457.PNG" alt="ios截图5" width="100"><img src="https://raw.githubusercontent.com/CodeGather/flutter_ali_auth/master/screenshot/IMG_4228.PNG" alt="ios截图6" width="100">
