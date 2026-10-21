package com.sean.rao.ali_auth.config;

import android.content.pm.ActivityInfo;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.RippleDrawable;
import android.os.Build;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import com.alibaba.fastjson2.JSONObject;
import com.sean.rao.ali_auth.utils.AppUtils;
import com.sean.rao.ali_auth.utils.UtilTool;
import java.io.IOException;

import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.sean.rao.ali_auth.common.CustomAuthUIControlClickListener;

public class FullPortConfig extends BaseUIConfig {
    private final String TAG = "全屏竖屏样式";

    public FullPortConfig() {
        super();
    }

    @Override
    public void configAuthPage() {
        if (jsonObject.getBooleanValue("authPageCrossFade")) {
            config.setAuthPageActIn("ali_auth_fade_in", "ali_auth_hold");
            // SDK 2.14.23 passes these directly to overridePendingTransition
            // (enter, exit), despite the misleading setter parameter names.
            config.setAuthPageActOut("ali_auth_hold", "ali_auth_fade_out");
        }
        if (jsonObject.getBooleanValue("logBtnTextBold")) {
            config.setLogBtnTypeface(Build.VERSION.SDK_INT >= 28
                    ? Typeface.create(Typeface.DEFAULT, 600, false)
                    : Typeface.DEFAULT_BOLD);
        }
        mAuthHelper.setUIClickListener(new CustomAuthUIControlClickListener());
        int switchHeight = jsonObject.getIntValue("switchAccButtonHeight");
        if (!jsonObject.getBooleanValue("switchAccHidden") && switchHeight > 0
                && !jsonObject.getBooleanValue("switchCheck", true)) {
            // The SDK's default text-only target is about 19dp tall. A real
            // button has a stable hit area and handles the first tap directly.
            config.setSwitchAccHidden(true);
            Button alternate = new Button(mActivity);
            alternate.setText(jsonObject.getString("switchAccText") == null
                    ? "其他登录方式" : jsonObject.getString("switchAccText"));
            alternate.setTextSize(TypedValue.COMPLEX_UNIT_SP,
                    jsonObject.getIntValue("switchAccTextSize", 14));
            // formatParmas has already converted top-level colors to ARGB ints.
            int color = jsonObject.getIntValue("switchAccTextColor", Color.DKGRAY);
            alternate.setTextColor(color);
            alternate.setTypeface(Typeface.DEFAULT);
            alternate.setAllCaps(false);
            alternate.setGravity(Gravity.CENTER);
            alternate.setPadding(0, 0, 0, 0);
            alternate.setStateListAnimator(null);
            GradientDrawable mask = new GradientDrawable();
            mask.setColor(Color.WHITE);
            mask.setCornerRadius(AppUtils.dp2px(mContext, 24));
            alternate.setBackground(new RippleDrawable(
                    ColorStateList.valueOf((color & 0x00ffffff) | 0x20000000), null, mask));
            RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
                    AppUtils.dp2px(mContext, jsonObject.getIntValue("switchAccButtonWidth", 200)),
                    AppUtils.dp2px(mContext, Math.max(48, switchHeight)));
            params.addRule(RelativeLayout.CENTER_HORIZONTAL);
            // Keep the original label center while expanding above and below.
            params.topMargin = AppUtils.dp2px(mContext,
                    jsonObject.getIntValue("switchOffsetY")
                            + (19 - Math.max(48, switchHeight)) / 2f);
            alternate.setLayoutParams(params);
            alternate.setOnClickListener(view -> {
                view.setEnabled(false);
                // Notify before dismissal so Flutter can prepare the next
                // frame. Native code owns this close, with no second request.
                showResult("700001", "用户切换其他登录方式", "");
                mAuthHelper.quitLoginPage();
            });
            mAuthHelper.addAuthRegistViewConfig("auth_alternate", new AuthRegisterViewConfig.Builder()
                    .setView(alternate)
                    .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
                    .build());
        }
        View thirdView = initSwitchView(420);
        if (thirdView != null) {
            mAuthHelper.addAuthRegistViewConfig("switch_msg", new AuthRegisterViewConfig.Builder()
                    .setView(thirdView)
                    .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
                    .build());
        }
        // A hidden navigation bar also hides its default back item. Keep a
        // real, accessible close button in the authorization body.
        JSONObject close = jsonObject.getJSONObject("customReturnBtn");
        if (jsonObject.getBooleanValue("navHidden") &&
                !jsonObject.getBooleanValue("navReturnHidden") && close != null &&
                close.getString("imgPath") != null) {
            ImageButton button = new ImageButton(mActivity);
            try {
                button.setBackground(UtilTool.getBitmapToBitmapDrawable(mContext,
                        UtilTool.flutterToPath(close.getString("imgPath"))));
                button.setContentDescription("关闭登录");
                RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(
                        AppUtils.dp2px(mContext, close.getFloatValue("width")),
                        AppUtils.dp2px(mContext, close.getFloatValue("height")));
                params.leftMargin = AppUtils.dp2px(mContext, close.getFloatValue("left"));
                params.topMargin = AppUtils.dp2px(mContext, close.getFloatValue("top"));
                button.setLayoutParams(params);
                button.setOnClickListener(view -> {
                    showResult("700000", "用户取消登录", "");
                    mAuthHelper.quitLoginPage();
                });
                mAuthHelper.addAuthRegistViewConfig("auth_close", new AuthRegisterViewConfig.Builder()
                        .setView(button)
                        .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
                        .build());
            } catch (IOException error) {
                // Preserve a way out when a caller supplies a missing image.
                config.setNavHidden(false);
            }
        }
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        mAuthHelper.setAuthUIConfig(config.setScreenOrientation(authPageOrientation).create());
    }
}
