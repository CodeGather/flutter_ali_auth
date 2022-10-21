#  

## 1.0.8
* 新增蜂窝网络是否开启功能 checkCellularDataEnable

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
