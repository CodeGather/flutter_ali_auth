package com.sean.rao.ali_auth.config;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.sean.rao.ali_auth.utils.AppUtils;

import io.flutter.plugin.common.EventChannel;

public class DialogLandConfig extends BaseUIConfig{
    private int mOldScreenOrientation;


    public DialogLandConfig() {
        super();
    }

    @Override
    public void configAuthPage() {
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE;
        if (Build.VERSION.SDK_INT == 26) {
            mOldScreenOrientation = mActivity.getRequestedOrientation();
            mActivity.setRequestedOrientation(authPageOrientation);
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);
        final int dialogWidth = (int) (mScreenWidthDp * 0.63);
        final int dialogHeight = (int) (mScreenHeightDp * 0.6);

        //sdk默认控件的区域是marginTop50dp
        int designHeight = dialogHeight - 50;
        int unit = designHeight / 10;
        int logBtnHeight = (int) (unit * 1.2);
        final int logBtnOffsetY = unit * 3;

        final View switchContainer = createLandDialogCustomSwitchView();
        mAuthHelper.addAuthRegistViewConfig("number_logo", new AuthRegisterViewConfig.Builder()
                .setView(initNumberView())
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_NUMBER)
                .setCustomInterface(new CustomInterface() {
                    @Override
                    public void onClick(Context context) {

                    }
                }).build());
        mAuthHelper.addAuthRegistViewConfig("switch_other", new AuthRegisterViewConfig.Builder()
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_NUMBER)
                .setView(switchContainer).build());
//        mAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
//                .setLayout(R.layout.custom_land_dialog, new AbstractPnsViewDelegate() {
//                    @Override
//                    public void onViewCreated(View view) {
//                        findViewById(R.id.tv_title).setVisibility(View.GONE);
//                        findViewById(R.id.btn_close).setOnClickListener(new View.OnClickListener() {
//                            @Override
//                            public void onClick(View v) {
//                                mAuthHelper.quitLoginPage();
//                            }
//                        });
//                        int iconTopMargin = AppUtils.dp2px(getContext(), logBtnOffsetY + 50);
//                        View iconContainer = findViewById(R.id.container_icon);
//                        RelativeLayout.LayoutParams iconLayout = (RelativeLayout.LayoutParams) iconContainer.getLayoutParams();
//                        iconLayout.topMargin = iconTopMargin;
//                        iconLayout.width = AppUtils.dp2px(getContext(), dialogWidth / 2 - 60);
//                    }
//                })
//                .build());
        mAuthHelper.setAuthUIConfig(config.setScreenOrientation(authPageOrientation).create());
    }

    private ImageView createLandDialogPhoneNumberIcon(int leftMargin) {
        ImageView imageView = new ImageView(mContext);
        int size = AppUtils.dp2px(mContext, 23);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(size, size);
        layoutParams.addRule(RelativeLayout.CENTER_VERTICAL, RelativeLayout.TRUE);
        layoutParams.leftMargin = leftMargin;
        imageView.setLayoutParams(layoutParams);
        // imageView.setBackgroundResource(R.drawable.phone);
        imageView.setScaleType(ImageView.ScaleType.CENTER);
        return imageView;
    }

    private View createLandDialogCustomSwitchView() {
//        View v = LayoutInflater.from(mContext).inflate(R.layout.custom_switch_other, new RelativeLayout(mContext), false);
//        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,
//                RelativeLayout.LayoutParams.WRAP_CONTENT);
//        layoutParams.addRule(RelativeLayout.CENTER_VERTICAL, RelativeLayout.TRUE);
//        v.setLayoutParams(layoutParams);
//        return v;
        return null;
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mOldScreenOrientation != mActivity.getRequestedOrientation()) {
            mActivity.setRequestedOrientation(mOldScreenOrientation);
        }
    }

    private ImageView initNumberView() {
        ImageView pImageView = new ImageView(mContext);
        // pImageView.setImageResource(R.drawable.phone);
        pImageView.setScaleType(ImageView.ScaleType.FIT_XY);
        RelativeLayout.LayoutParams pParams = new RelativeLayout.LayoutParams(AppUtils.dp2px(mContext, 30), AppUtils.dp2px(mContext, 30));
        pParams.setMargins(AppUtils.dp2px(mContext, 30), 0, 0, 0);
        pImageView.setLayoutParams(pParams);
        return pImageView;
    }
}
