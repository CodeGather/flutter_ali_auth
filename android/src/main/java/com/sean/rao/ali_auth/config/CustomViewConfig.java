package com.sean.rao.ali_auth.config;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;

import io.flutter.plugin.common.EventChannel;

import static com.nirvana.tools.core.AppUtils.dp2px;

/**
 *  号码栏水平位置的自定义view 推荐使用addAuthRegistViewConfig 可以添加到相对精准的位置
 */
public class CustomViewConfig extends BaseUIConfig {

    public CustomViewConfig() {
        super();
    }

    @Override
    public void configAuthPage() {
        mAuthHelper.addAuthRegistViewConfig("switch_msg", new AuthRegisterViewConfig.Builder()
                .setView(initSwitchView(350))
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
                .setCustomInterface(new CustomInterface() {
                    @Override
                    public void onClick(Context context) {
//                        Toast.makeText(mContext, "切换到短信登录方式", Toast.LENGTH_SHORT).show();
//                        Intent pIntent = new Intent(mActivity, MessageActivity.class);
//                        mActivity.startActivityForResult(pIntent, 1002);
//                        mAuthHelper.quitLoginPage();
                    }
                }).build());
        mAuthHelper.addAuthRegistViewConfig("number_logo", new AuthRegisterViewConfig.Builder()
                .setView(initNumberLogoView())
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_NUMBER)
                .setCustomInterface(new CustomInterface() {
                    @Override
                    public void onClick(Context context) {

                    }
                }).build());
        mAuthHelper.addAuthRegistViewConfig("back_btn", new AuthRegisterViewConfig.Builder()
                .setView(initBackBtn())
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_TITLE_BAR)
                .setCustomInterface(new CustomInterface() {
                    @Override
                    public void onClick(Context context) {
                        mAuthHelper.quitLoginPage();
                        mActivity.finish();
                    }
                }).build());

        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }

        mAuthHelper.setAuthUIConfig(config.setScreenOrientation(authPageOrientation).create());
    }

    private ImageView initNumberLogoView() {
        ImageView pImageView = new ImageView(mContext);
        // pImageView.setImageResource(R.drawable.phone);
        pImageView.setScaleType(ImageView.ScaleType.FIT_XY);
        RelativeLayout.LayoutParams pParams = new RelativeLayout.LayoutParams(dp2px(mContext, 30), dp2px(mContext, 30));
        pParams.setMargins(dp2px(mContext, 100), 0, 0, 0);
        pImageView.setLayoutParams(pParams);
        return pImageView;
    }

    private ImageView initBackBtn() {
        ImageView pImageView = new ImageView(mContext);
        // pImageView.setImageResource(R.drawable.icon_close);
        pImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
        RelativeLayout.LayoutParams pParams = new RelativeLayout.LayoutParams(dp2px(mContext, 20), dp2px(mContext, 20));
        pParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT, RelativeLayout.TRUE);
        pParams.addRule(RelativeLayout.CENTER_VERTICAL, RelativeLayout.TRUE);
        pParams.setMargins(dp2px(mContext, 12.0F), 0, 0, 0);
        pImageView.setLayoutParams(pParams);
        return pImageView;
    }
}
