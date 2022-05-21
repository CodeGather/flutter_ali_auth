package com.sean.rao.ali_auth.config;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.os.Build;

import androidx.core.graphics.drawable.RoundedBitmapDrawable;
import androidx.core.graphics.drawable.RoundedBitmapDrawableFactory;

import com.alibaba.fastjson.JSONObject;
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

    public DialogPortConfig(Activity activity, EventChannel.EventSink _eventSink, JSONObject jsonObject, AuthUIConfig.Builder config, PhoneNumberAuthHelper authHelper) {
        super(activity, _eventSink, jsonObject, config, authHelper);
        mPackageName = AppUtils.getPackageName(activity);
    }

    @Override
    public void configAuthPage() {
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);

        if (jsonObject.containsKey("pageBackgroundPath") && !jsonObject.getString("pageBackgroundPath").isEmpty()) {
            try {
                RoundedBitmapDrawable pageBackgroundDrawable = RoundedBitmapDrawableFactory.create(mContext.getResources(), UtilTool.getPathToBitmap(mContext, jsonObject.getString("pageBackgroundPath")));
                pageBackgroundDrawable.setCornerRadius(AppUtils.dp2px(mContext, jsonObject.getIntValue("pageBackgroundRadius")));
                autoConfig.setPageBackgroundDrawable(pageBackgroundDrawable);
            } catch (IOException e) {
                eventSink.success(UtilTool.resultFormatData("500000", null, e.getMessage()));
            }
        }
        mAuthHelper.setAuthUIConfig(autoConfig.setScreenOrientation(authPageOrientation).create());
    }
}
