
## 1.2.6
* 更新android sdk 为 2.13.10
* 更新ios sdk 为 2.13.10
* 更新web sdk 为 2.1.4
* 修改fastjson2 -> 2.0.51.android5 以兼容低版本android版本
* 修复ios底部弹窗模式下协议详情导航参数 privacyNavColor、privacyNavBackImage、privacyNavTitleFont、privacyNavTitleColor
* 请注意需要在项目下gradle.properties添加以下内容，具体参看demo：org.gradle.jvmargs=-Xmx1536M -Dfile.encoding=UTF-8 --add-opens=java.base/java.io=ALL-UNNAMED
