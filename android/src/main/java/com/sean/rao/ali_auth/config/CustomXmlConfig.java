package com.sean.rao.ali_auth.config;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;
import com.sean.rao.ali_auth.R;
import com.sean.rao.ali_auth.utils.UtilTool;

import io.flutter.plugin.common.EventChannel;

/**
 * xml文件方便预览
 * 可以通过addAuthRegisterXmlConfig一次性统一添加授权页的所有自定义view
 */
public class CustomXmlConfig extends BaseUIConfig {

    public CustomXmlConfig() {
        super();
    }
    @Override
    public void configAuthPage() {
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }

        int getCustomXml = mContext.getResources().getIdentifier("custom_full_port", "layout", mContext.getPackageName());
        // 判断是否有自定义布局文件，没有则加载默认布局文件
        if(getCustomXml == 0){
            getCustomXml = mContext.getResources().getIdentifier("custom_full_port", "layout", mContext.getPackageName());
        }
        View customXmlLayout = LayoutInflater.from(mContext).inflate(getCustomXml, new RelativeLayout(mContext), false);
        mAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
                .setLayout(getCustomXml, new AbstractPnsViewDelegate() {
                    @Override
                    public void onViewCreated(View view) {
                        findViewById(R.id.btn_back).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                /// 点击关闭按钮
                                // eventSink.success(UtilTool.resultFormatData("700000", null, null));
                                showResult("700000", "点击返回按钮", "");
                                mAuthHelper.quitLoginPage();
                            }
                        });

                        findViewById(R.id.tv_switch).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                /// 点击切换其他按钮
                                showResult("700001", "切换到其他方式", "");
                                // eventSink.success(UtilTool.resultFormatData("700001", null, null));
                                mAuthHelper.quitLoginPage();
                            }
                        });
                    }
                })
                .build());
        mAuthHelper.setAuthUIConfig(config.setScreenOrientation(authPageOrientation).create());
    }
}
