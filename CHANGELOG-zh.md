#  

## 1.2.7
* 添加返回参数 isChecked
* 统一背景参数 pageBackgroundPath
* 优化iOS端代码参数统一配置
* 修复Android物理按键返回后无法再次打开问题
* 修复android无法打开二次弹窗的问题

## 1.2.6
* 更新android sdk 为 2.13.10
* 更新ios sdk 为 2.13.10
* 更新web sdk 为 2.1.4
* 修改fastjson2 -> 2.0.51.android5
* 修复ios底部弹窗模式下协议详情导航参数 privacyNavColor、privacyNavBackImage、privacyNavTitleFont、privacyNavTitleColor
* 请注意需要在项目下gradle.properties添加以下内容，具体参看demo：org.gradle.jvmargs=-Xmx1536M -Dfile.encoding=UTF-8 --add-opens=java.base/java.io=ALL-UNNAMED

## 1.2.5
* 修复底部弹窗dialogHeight、alertCloseImageX、alertCloseImageY、alertCloseImageW、alertCloseImageH 参数

## 1.2.4
* 修复 checkboxHidden 参数

## 1.2.3
* 更新android sdk 为 2.13.5
* 更新ios sdk 为 2.13.7
* 更新web sdk 为 2.1.3
* 修复 isLightColor 字段不生效 -> 参数调整为 lightColor

## 1.2.2
* 更新android sdk 为 2.13.6
* 更新ios sdk 为 2.13.7

## 1.2.1
* 更新android sdk 为 2.13.5
* 更新ios sdk 为 2.13.7
* 更新web sdk 为 2.1.3

## 1.2.0
* 更新android sdk 为 2.13.3
* 更新ios sdk 为 2.13.3

## 1.1.9
* 修复android sdk 版本错误

## 1.1.8
* 更新android sdk 为 2.13.2.1
* 更新ios sdk 为 2.13.2
* 尊敬的客户，您好：因中国联通号码认证产品能力升级，且升级后的SDK与原SDK不兼容，为不影响云通信号码认证服务的正常使用，请务必确保在2024年3月31日前完成新方案号的创建，并下载、集成最新版本SDK。具体升级指引请详见

## 1.1.7
* 修复BUG

## 1.1.6
* 更新ios sdk 为 2.12.17.2
* 更新android sdk 为 2.12.17.2

## 1.1.5
* 更新ios sdk 为 2.12.16
* 更新android sdk 为 2.12.16

## 1.1.4
* 更新ios sdk 为 2.12.15
* 更新android sdk 为 2.12.15
* 授权页弹窗模式点击非弹窗区域可以退出授权页。

## 1.1.3
* iOS 新增是否点击切换按钮时是否校验协议 -> switchCheck
* 修复新增的协议文字颜色参数
* 去除workflows编译测试

## 1.1.2
* 更新web sdk 为 2.0.10
* 更新ios sdk 为 2.12.14
* 更新android sdk 为 2.12.14
* 授权页运营商协议文本颜色 -> protocolOwnColor
* 授权页协议1文本颜色 -> protocolOwnOneColor
* 授权页协议2文本颜色 -> protocolOwnTwoColor
* 授权页协议3文本颜色 -> protocolOwnThreeColor
* 二次授权页协议1文本颜色 -> privacyAlertOwnOneColor
* 二次授权页协议2文本颜色 -> privacyAlertOwnTwoColor
* 二次授权页协议3文本颜色 -> privacyAlertOwnThreeColor
* 二次授权页运营商协议文本颜色 -> privacyAlertOperatorColor
* 性能优化
* 提升稳定性

## 1.1.1
* 更新ios sdk 为 2.12.13.1
* 更新android sdk 为 2.12.13.1
* 性能优化
* 提升稳定性
* 修复 setLoadingBackgroundPath -> setLogBtnBackgroundPath

## 1.1.0
* 更新ios sdk 为2.12.12
* 新增autoQuitPage字段
* 新增isHideToast字段
* 新增toastText字段
* 新增toastBackground字段
* 新增toastColor字段
* 新增toastPadding字段
* 新增toastMarginTop字段
* 新增toastMarginBottom字段
* 新增toastPositionMode字段
* 新增toastDelay字段
* 新增第三方按钮需要同意协议功能

## 1.0.9
* 更新android sdk 为2.12.11.2
* 更新ios sdk 为2.12.11
* 升级fastjson修复漏洞

## 1.0.8
* 新增蜂窝网络是否开启功能 checkCellularDataEnable
* 修复iOS _NSPlaceholderArray initWithObjects:count

## 1.0.7
* 修复iOS协议对其问题
* 新增监听的暂停、恢复、移除事件
* 新增根据条件是否需要多个监听 isOnlyOne
* 修复iOS 切换其它标题的坐标问题

## 1.0.6

* 更新插件二次认证参数（android 已完毕）
* 修复iOS弹窗、底部弹窗参数配置问题
* 升级Android compileSdkVersion 为 33
* 新增Android 返回按钮返回桌面的处理方案

## 1.0.5

* 更新android sdk 为2.12.9
* 更新ios sdk 为2.12.9
* 修复iOS协议坐标问题
* 优化iOS初始化返回，去除无用返回
* 添加（演示APP后台重启的视频包含断网情况下获取正常）demo
* 下个版本即将添加二次弹窗界面

## 1.0.4

* 修复Android 后台后点击桌面图标重启问题
* 修复iOS、Android首次初始化返回sdk版本参数问题
* 修复iOS第三方布局按钮和Android效果不一致问题
* logBtnToastHidden 参数为Android 独有参数iOS端无效果
* 修复插件初始化在延时登录的情况下再次更新时被直接调起授权页面的问题
* 新增iOS第三方布局添加文字的问题

## 1.0.3

* 修复ios 依赖问题

## 1.0.2

* 更新android 下载源为阿里云
* 更新ios 重复依赖问题

## 1.0.1

* 更新android sdk 为2.12.6.3
* 更新ios sdk 为2.12.6
* 修复iOS部分用户报错问题，重复引入导致 issues84

## 1.0.0

* 插件重构

## 0.2.3

* 更新android sdk 为2.12.4
* Android sdk 修复so文件名过长在老版本系统偶现Crash的问题
* Android sdk 优化协议按钮勾选体验
* 更新ios sdk 为2.12.4
* IOS sdk 开放授权页协议动画属性（privacyAnimation）
* IOS sdk 新增 自定义协议页面控制 privacyVCIsCustomized

## 0.2.2

* 修复Android弹窗和全屏的配置BUG

## 0.2.1

* 修复Android点击用户协议是授权页面被关闭BUG
* 修改Android为枚举
* 修复IOS切换运营商时页面被关闭BUG

## 0.2.0

* 修复安卓端切换多选框时页面授权页面被关闭问题

## 0.1.9

* 修改初始化的提示信息
* 更新android sdk 为2.12.3.4

## 0.1.8

* 修改初始化的提示信息
* 更新android sdk 为2.12.3
* 更新ios sdk 为2.12.3.1

## 0.1.7

* 修复iOS没有图片路径报错
* 修复iOS自定义返回按钮错误
* 去除参数checkBoxImages 如需使用，请使用uncheckedImgPath，checkedImgPath参数代替
* 更新android sdk 为2.12.1.4


## 0.1.6

* 修复changeBtnIsHidden改为changeBtnTitle

## 0.1.5

* 修复IOS端无按钮图片报错BUG
* 修复IOS端图片不显示BUG

## 0.1.4

* 新增沉浸式布局时方案，自定义返回关闭按钮以及协议页面的处理
* 更新iOS端SDK版本为2.12.1.3

## 0.1.3

* 新增是否隐藏自定义布局
* 更新Android端SDK版本为2.12.1
* 更新iOS端SDK版本为2.12.1
* 迁移 null-safety

## 0.1.2

* 更新Android端SDK版本为2.12.0.1
* 更新iOS端SDK版本为2.12.0
* 优化ios端一键登录按钮的默认样式以及背景方式

## 0.1.1

* 修复ios 弹窗模式下登录按钮背景图片问题

## 0.1.0

* 修复ios 弹窗模式下关闭按钮路径设置无效BUG

## 0.0.9

* 修复android 和 iOS 返回状态码不一致问题
* 修复若干BUG

## 0.0.8

* 修改DEMO在移动卡的情况下无法联网的情况
* 更新Android端SDK版本为2.11.1.1
* 更新iOS端SDK版本为2.11.2

## 0.0.7

* 优化iOS相关

## 0.0.6

* 重构代码，自定义所有配置参数，统一监听返接口，更多的配置，更多的可能性，更好的自定义布局，让你的需求不在为难
* 去除接口 appleploginlisten 统一为loginlisten
* 完善文档详情请查看接口文件
* android 完成修改以及文档的完善
* iOS 同步SDK更新相关过期接口
* iOS 优化相关代码统一监听返接口
* logo可以通过assets/logo.png的方式传递

## 0.0.5

* 更新插件的资源文件，因为SDK减少了不必要的资源文件
* 在使用最新的SDK时，修复Android返回数据类型为string

## 0.0.4

* 更新SDK 到最新版本到 2.11.1
* 添加与代码相关的注释
* 相关监听接口调整如下：loginlisten>appleploginlisten

## 0.0.3

* 更新SDK 到最新版本到 2.10.0
* 新注释和相关说明

## 0.0.2

* iOS 开发完成
  
## 0.0.1

* Android 开发完成
