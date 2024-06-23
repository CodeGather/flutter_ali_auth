package com.sean.rao.ali_auth.config;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Build;

import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.sean.rao.ali_auth.common.CustomAuthUIControlClickListener;

import io.flutter.plugin.common.EventChannel;

public class FullPortConfig extends BaseUIConfig {
    private final String TAG = "全屏竖屏样式";

    public FullPortConfig() {
        super();
    }

    @Override
    public void configAuthPage() {
        mAuthHelper.setUIClickListener(new CustomAuthUIControlClickListener());
        //添加自定义切换其他登录方式
        mAuthHelper.addAuthRegistViewConfig("switch_msg", new AuthRegisterViewConfig.Builder()
                .setView(initSwitchView(420))
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
//                .setCustomInterface(new CustomInterface() {
//                    @Override
//                    public void onClick(Context context) {
//                      JSONObject jsonObj = new JSONObject();
//                      jsonObj.put("code", "7000001");
//                      jsonObj.put("data", "");
//                      jsonObj.put("msg", "切换到短信登录方式");
//                      eventSink.success(jsonObj);
//                    }
//                })
                .build());
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        mAuthHelper.setAuthUIConfig(config.setScreenOrientation(authPageOrientation).create());
    }
}
