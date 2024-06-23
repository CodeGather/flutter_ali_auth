package com.sean.rao.ali_auth.config;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.view.View;
import android.widget.Toast;

import androidx.core.graphics.drawable.RoundedBitmapDrawable;
import androidx.core.graphics.drawable.RoundedBitmapDrawableFactory;

import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;
import com.sean.rao.ali_auth.utils.AppUtils;
import com.sean.rao.ali_auth.utils.UtilTool;

import java.io.IOException;

import io.flutter.plugin.common.EventChannel;

public class DialogBottomConfig extends BaseUIConfig {

    public DialogBottomConfig() {
        super();
    }

    @Override
    public void configAuthPage() {
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);

        int dialogHeight = (int) (mScreenHeightDp * 0.5f);
        //sdk默认控件的区域是marginTop50dp
        int designHeight = dialogHeight - 50;
        int unit = designHeight / 10;
        mAuthHelper.addAuthRegistViewConfig("switch_msg", new AuthRegisterViewConfig.Builder()
                .setView(initSwitchView(unit * 6))
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
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
