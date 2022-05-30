# 注意事项
1、如果使用自定义协议页面 (对小白不够友好，需要会Android布局) 
    1.1 添加清单
    ```<!--   自定义协议页面    -->
    <activity
        android:configChanges="orientation|keyboardHidden|screenSize|uiMode|fontScale"
        android:name="com.sean.rao.aliAuth.CustomWebViewActivity"
        android:theme="@style/AppTheme"
        android:exported="true"
        android:screenOrientation="sensorPortrait">
       <intent-filter>
           <action android:name="com.sean.rao.ali_auth_example.protocolWeb"/>
           <category android:name="android.intent.category.DEFAULT"/>
       </intent-filter>
    </activity>```   
    1.2 拷贝Activity文件    
    ```ali_auth/example/android/app/src/main/java/com/sean/rao/aliAuth/CustomWebViewActivity.java```   
    1.3 拷贝布局文件  
    ```ali_auth/example/android/app/src/main/res/layout/activity_custom_web.xml```    
    1.4 拷贝资源文件    
    ```ali_auth/example/android/app/src/main/res/drawable/icon_close.png```   
    1.5 修改CustomWebViewActivity.java 将R 资源引入