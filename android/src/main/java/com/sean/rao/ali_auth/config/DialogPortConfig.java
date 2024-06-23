package com.sean.rao.ali_auth.config;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Build;

import androidx.core.graphics.drawable.RoundedBitmapDrawable;
import androidx.core.graphics.drawable.RoundedBitmapDrawableFactory;

import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.sean.rao.ali_auth.utils.AppUtils;
import com.sean.rao.ali_auth.utils.UtilTool;

import java.io.IOException;

import io.flutter.plugin.common.EventChannel;

public class DialogPortConfig extends BaseUIConfig {
    /**
     * 应用包名
     */
    private String mPackageName;

    public DialogPortConfig() {
        super();
        mPackageName = AppUtils.getPackageName(mActivity);
    }

    @Override
    public void configAuthPage() {
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);

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

        if (jsonObject.containsKey("pageBackgroundPath") && !jsonObject.getString("pageBackgroundPath").isEmpty()) {
            try {
                RoundedBitmapDrawable pageBackgroundDrawable = RoundedBitmapDrawableFactory.create(mContext.getResources(), UtilTool.getPathToBitmap(mContext, jsonObject.getString("pageBackgroundPath")));
                pageBackgroundDrawable.setCornerRadius(AppUtils.dp2px(mContext, jsonObject.getIntValue("pageBackgroundRadius")));
                config.setPageBackgroundDrawable(pageBackgroundDrawable);
            } catch (IOException e) {
                // eventSink.success(UtilTool.resultFormatData("500000", null, e.getMessage()));
                showResult("500000", "背景处理时出现错误", e.getMessage());
            }
        }
        mAuthHelper.setAuthUIConfig(config.setScreenOrientation(authPageOrientation).create());
    }
}
