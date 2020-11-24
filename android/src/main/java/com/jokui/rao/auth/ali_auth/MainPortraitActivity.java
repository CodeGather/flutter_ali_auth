package com.jokui.rao.auth.ali_auth;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.AuthUIControlClickListener;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.PreLoginResultListener;
import com.mobile.auth.gatewayauth.TokenResultListener;
import com.mobile.auth.gatewayauth.model.TokenRet;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import static com.jokui.rao.auth.ali_auth.AppUtils.dp2px;
import static com.mobile.auth.gatewayauth.PhoneNumberAuthHelper.SERVICE_TYPE_LOGIN;

public class MainPortraitActivity implements PluginRegistry.ActivityResultListener {
    private final String TAG = "MainPortraitActivity";

    private final Activity activity;
    private final Context context;
    private PhoneNumberAuthHelper mAlicomAuthHelper;
    private TokenResultListener mTokenListener;
    private String token;
    private View switchTV;
    private int mScreenWidthDp;
    private int mScreenHeightDp;

    private final int SUCCESS = 0;
    private final int ERROR = -1;


    public MainPortraitActivity(Activity activity, Context context) {
        this.activity = activity;
        this.context = context;
    }
    
    @Override
    public boolean onActivityResult(int i, int i1, Intent intent) {
        return false;
    }

    private void updateScreenSize(int authPageScreenOrientation) {
        int screenHeightDp = AppUtils.px2dp(context, AppUtils.getPhoneHeightPixels(context));
        int screenWidthDp = AppUtils.px2dp(context, AppUtils.getPhoneWidthPixels(context));
        mScreenWidthDp = screenWidthDp;
        mScreenHeightDp = screenHeightDp;
    }

    public void init(final MethodCall call, final MethodChannel.Result methodResult) {
        mTokenListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(final String ret) {
                activity.runOnUiThread(new Runnable() {

                    @Override
                    public void run() {
                        Log.e("xxxxxx", "onTokenSuccess:" + ret);
                        /*
                         *   setText just show the result for get token。
                         *   use ret to verfiy number。
                         */
                        TokenRet tokenRet = null;
                        try {
                            tokenRet = JSON.parseObject(ret, TokenRet.class);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        JSONObject jsonObject = new JSONObject();

                        if (tokenRet != null && ("600024").equals(tokenRet.getCode())) {
                            jsonObject.put("code", tokenRet.getCode());
                            jsonObject.put("msg", "终端自检成功！");
                        }

                        if (tokenRet != null && ("600001").equals(tokenRet.getCode())) {
                            jsonObject.put("code", tokenRet.getCode());
                            jsonObject.put("msg", "唤起授权页成功！");
                        }

                        if (tokenRet != null && ("600000").equals(tokenRet.getCode())) {
                            token = tokenRet.getToken();
                            mAlicomAuthHelper.quitLoginPage();
                            jsonObject.put("code", tokenRet.getCode());
                            jsonObject.put("msg", "获取token成功！");
                        }
                        methodResult.success(jsonObject);
                    }
                });
            }

            @Override
            public void onTokenFailed(final String ret) {
                Log.e("xxxxxx", "onTokenFailed:" + ret);
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        /*
                         *  setText just show the result for get token
                         *  do something when getToken failed, such as use sms verify code.
                         */
                        JSONObject jsonObject = new JSONObject();
                        jsonObject.put("code", 5000);
                        jsonObject.put("msg", "失败：" + ret);
                        methodResult.success(jsonObject);
                    }
                });
            }
        };

        mAlicomAuthHelper = PhoneNumberAuthHelper.getInstance(context, mTokenListener);

        // 初始化SDK
        String SK = call.argument("sk");
        mAlicomAuthHelper.setAuthSDKInfo(SK);

        // 设置检测是否有支持一键登录或者本机号码认证环境
        /*
         *   使用一键登录传入 SERVICE_TYPE_LOGIN
         *   使用号码校验传入 SERVICE_TYPE_AUTH
         */
        int checkEnvAvailable = (int) call.argument("checkEnvAvailable");
        mAlicomAuthHelper.checkEnvAvailable(checkEnvAvailable);

        // 设置调试模式
        boolean isDebug = (boolean) call.argument("debug");
        mAlicomAuthHelper.getReporter().setLoggerEnable(isDebug);

        // 设置UI点击回调
        mAlicomAuthHelper.setUIClickListener(new AuthUIControlClickListener() {
            @Override
            public void onClick(String code, Context context, String jsonObj) {
                Log.e("xxxxxx", "OnUIControlClick:code=" + code + ", jsonObj=" + (jsonObj == null ? "" : jsonObj));
            }
        });

        // 判断是否使用dialog登录
        boolean type = (boolean) call.argument("type");
        if(type){
            configLoginTokenPort(call, methodResult);
        } else {
            configLoginTokenPortDialog(call, methodResult);
        }

        preLogin(call, methodResult);
    }


    /** SDK 判断网络环境是否支持 */
    /**
     * @deprecated
     */
    public boolean checkVerifyEnable(MethodCall call, MethodChannel.Result result) {
        // 判断网络是否支持
        boolean checkRet = mAlicomAuthHelper.checkEnvAvailable();
        if (!checkRet){
            Log.d(TAG, ("当前网络不支持，请检测蜂窝网络后重试"));
        }

        result.success(checkRet);
        return checkRet;
    }

    /** SDK设置debug模式 */
    public void setDebugMode(MethodCall call, MethodChannel.Result result) {
        Object enable = getValueByKey(call, "debug");
        if (enable != null) {
            mAlicomAuthHelper.getReporter().setLoggerEnable((Boolean) enable);
        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("result", enable);
        result.success(jsonObject);
    }

    /** SDK 一键登录预取号 */
    public void preLogin(MethodCall call, final MethodChannel.Result result) {
        int timeOut = 5000;
        if (call.hasArgument("timeOut")) {
        Integer value = call.argument("timeOut");
            timeOut = value;
        }

        mAlicomAuthHelper.accelerateLoginPage(timeOut, new PreLoginResultListener() {
            @Override
            public void onTokenSuccess(final String vendor) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Log.d(TAG, vendor + "预取号成功！");
                        JSONObject jsonObject = new JSONObject();
                        jsonObject.put("code", vendor);
                        jsonObject.put("msg", "预取号成功！");
                        result.success(jsonObject);
                    }
                });
            }

            @Override
            public void onTokenFailed(final String vendor, final String ret) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        Log.d(TAG, vendor + "预取号失败:\n" + ret);
                        JSONObject jsonObject = new JSONObject();
                        jsonObject.put("code", ret);
                        jsonObject.put("msg", "预取号失败");
                        result.success(jsonObject);
                    }
                });
            }
        });
    }

    // 正常登录
    public void login(final MethodCall call, final MethodChannel.Result methodResult){
        getAuthListener(call, methodResult);
        mAlicomAuthHelper.getLoginToken(context, 5000);
    }

    // dialog登录
    public void loginDialog(final MethodCall call, final MethodChannel.Result methodResult){
        getAuthListener(call, methodResult);
        mAlicomAuthHelper.getLoginToken(context, 5000);
    }

    // 获取登录token
    public void getToken(final MethodCall call, final MethodChannel.Result methodResult){
        getAuthListener(call, methodResult);
        mAlicomAuthHelper.getVerifyToken(5000);
    }

    // 获取监听数据
    private void getAuthListener(final MethodCall call, final MethodChannel.Result methodResult){
        mAlicomAuthHelper.setAuthListener(new TokenResultListener() {
            @Override
            public void onTokenSuccess(final String ret) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        TokenRet tokenRet = null;
                        try {
                            tokenRet = JSON.parseObject(ret, TokenRet.class);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                        if (tokenRet != null && !("600001").equals(tokenRet.getCode())) {
                            JSONObject jsonObject = new JSONObject();
                            jsonObject.put("returnCode", tokenRet.getCode());
                            jsonObject.put("returnMsg", tokenRet.getMsg());
                            jsonObject.put("returnData", tokenRet.getToken());
                            //转化成json字符串
                            methodResult.success(jsonObject);
                            mAlicomAuthHelper.quitLoginPage();
                        }
                        Log.d(TAG, ("成功:\n" + ret));
                    }
                });
            }
            @Override
            public void onTokenFailed(final String ret) {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        TokenRet tokenRet = null;
                        try {
                            tokenRet = JSON.parseObject(ret, TokenRet.class);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                        JSONObject jsonObject = new JSONObject();
                        jsonObject.put("returnCode", tokenRet.getCode());
                        jsonObject.put("returnMsg", tokenRet.getMsg());
                        //转化成json字符串
                        methodResult.success(jsonObject);

                        Log.d(TAG, ("失败:\n" + ret));
                    }
                });
            }
        });
    }

    // 自定义UI
    private void initDynamicView() {
//        switchTV = LayoutInflater.from(context).inflate(R.layout.custom_login_add, new RelativeLayout(context), false);
//        RelativeLayout.LayoutParams mLayoutParams2 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, dp2px(activity, 150));
//        mLayoutParams2.addRule(RelativeLayout.CENTER_HORIZONTAL, RelativeLayout.TRUE);
//        mLayoutParams2.setMargins(0, dp2px(context, 450), 0, 0);
//        switchTV.setText("-----  自定义view  -----");
//        switchTV.setTextColor(0xff999999);
//        switchTV.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13.0F);
//        switchTV.setLayoutParams(mLayoutParams2);
    }

    private ImageView createLandDialogPhoneNumberIcon( float rightMargin, float topMargin, float fontSize) {
        ImageView imageView = new ImageView(context);
        int size = AppUtils.dp2px(context, fontSize);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT
        );
        layoutParams.addRule(RelativeLayout.ALIGN_RIGHT, RelativeLayout.TRUE);
        layoutParams.topMargin = AppUtils.px2dp(context, topMargin);
        layoutParams.rightMargin = AppUtils.px2dp(context, rightMargin);
        imageView.setLayoutParams(layoutParams);
        imageView.setBackgroundResource(R.drawable.slogan);
        imageView.setScaleType(ImageView.ScaleType.CENTER);
        return imageView;
    }

    private View createLandDialogCustomSwitchView(int layoutHeight, float leftMargin, float topMargin, float fontSize) {
        View v = LayoutInflater.from(context).inflate(R.layout.custom_slogan, new RelativeLayout(context), false);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT
        );
//        // 左侧按钮布局
//        v.findViewById(R.id.login_left).setOnClickListener(new View.OnClickListener() {
//            @Override public void onClick(View v) {
//                Log.d(TAG, ("login_left 被点击了"));
//            }
//        });
//
//        // 右侧按钮布局
//        v.findViewById(R.id.login_right).setOnClickListener(new View.OnClickListener() {
//            @Override public void onClick(View v) {
//                Log.d(TAG, ("login_right 被点击了"));
//            }
//        });
        TextView txv = v.findViewById(R.id.slogan_title);
        txv.setTextSize(fontSize);
        // int size = AppUtils.dp2px(context, 23);
        layoutParams.topMargin = AppUtils.px2dp(context, topMargin);
        layoutParams.leftMargin = AppUtils.px2dp(context, leftMargin);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP, RelativeLayout.TRUE);
        v.setLayoutParams(layoutParams);
        return v;
    }

    // ⼀键登录授权⻚⾯
    private void configLoginTokenPort(final MethodCall call, final MethodChannel.Result methodResult) {
        initDynamicView();
        Log.d(TAG, "configLoginTokenPort: "+call.arguments);
        mAlicomAuthHelper.removeAuthRegisterXmlConfig();
        mAlicomAuthHelper.removeAuthRegisterViewConfig();

        // 添加第三方登录按钮
        mAlicomAuthHelper.addAuthRegistViewConfig("switch_acc_tv", new AuthRegisterViewConfig.Builder()
                .setView(switchTV)
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
                .build());

        // 添加第三方登录按钮
//        mAlicomAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
//            .setLayout(R.layout.custom_login_add, new AbstractPnsViewDelegate() {
//                @Override public void onViewCreated(View view) {
//                    // 左侧按钮布局
//                    findViewById(R.id.login_left).setOnClickListener(new View.OnClickListener() {
//                        @Override public void onClick(View v) {
//                            Log.d(TAG, ("login_left 被点击了"));
//                        }
//                    });
//
//                    // 右侧按钮布局
//                    findViewById(R.id.login_right).setOnClickListener(new View.OnClickListener() {
//                        @Override public void onClick(View v) {
//                            Log.d(TAG, ("login_right 被点击了"));
//                        }
//                    });
//                    //new AliAuthPlugin(call, methodResult)._events.success(message);
//                }
//            })
//            .build());


        // 添加图片
//         mAlicomAuthHelper.addAuthRegistViewConfig("image_icon",
//                 new AuthRegisterViewConfig.Builder()
//                         .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
//                         .setView(createLandDialogPhoneNumberIcon(0, 0, 200))
//                         .build());

        final View switchContainer = createLandDialogCustomSwitchView(250,0, 0, 24);

        // 添加文字布局
        mAlicomAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
            .setLayout(R.layout.custom_slogan, new AbstractPnsViewDelegate() {
                @Override public void onViewCreated(View view) {
                    findViewById(R.id.slogan_title).setOnClickListener(new View.OnClickListener() {
                        @Override public void onClick(View v) {
                            Log.d(TAG, ("slogan 被点击了"));
                        }
                    });
                }
            })
            .build());

        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        mAlicomAuthHelper.setAuthUIConfig(
            new AuthUIConfig.Builder()
            // 状态栏背景色
            .setStatusBarColor(Color.parseColor("#ffffff"))
            // .setStatusBarColor(Color.TRANSPARENT)
            .setLightColor(true)
            // 导航栏设置
            .setNavHidden(true)
            .setNavColor(Color.parseColor("#3971fe")) // 导航栏背景色
            .setNavText("本机号码一键登录") // 导航栏背景色
            .setAppPrivacyColor(Color.GRAY, Color.parseColor("#3971fe"))
            // logo设置
            .setLogoHidden(true)
            .setLogoImgPath("ic_launcher")
            // slogan 设置
            .setSloganHidden(true)
            // 号码设置
            .setNumberColor(Color.parseColor("#3C4F5E"))
            // 按钮设置
            .setLogBtnBackgroundPath("button")
            .setLogBtnHeight(38)
            .setAuthPageActIn("in_activity", "out_activity")
            .setAuthPageActOut("in_activity", "out_activity")
            .setVendorPrivacyPrefix("《")
            .setVendorPrivacySuffix("》")
            // 切换到其他登录方式
            .setSwitchAccTextColor(Color.parseColor("#3A71FF"))
            .setSwitchAccText("使用验证码登录")
            .setScreenOrientation(authPageOrientation)
            // 勾选框
            .setCheckboxHidden(false)
            // 勾选框后方文字
            // .setPrivacyBefore("sadadasda")
            .setPrivacyState(false)
            // .setLogBtnBackgroundPath("slogan")
            //.setPrivacyBefore("《达理用户协议》")
            .setAppPrivacyOne("《达理用户协议》", "https://www.baidu.com")
            .setAppPrivacyTwo("《达理用户隐私》", "https://www.baidu.com")
            //.setStatusBarUIFlag(View.SYSTEM_UI_FLAG_LOW_PROFILE) // 沉浸式，需隐藏状态栏否则会出现和状态栏重叠的问题
            .setStatusBarUIFlag(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN) // 沉浸式，需隐藏状态栏否则会出现和状态栏重叠的问题
            // 手机底部虚拟部分颜色
            .setBottomNavColor(Color.parseColor("#ffffff"))
            .create()
        );
    }
    // 弹窗授权⻚⾯
    private void configLoginTokenPortDialog(final MethodCall call, final MethodChannel.Result methodResult) {
        // initDynamicView();
        mAlicomAuthHelper.removeAuthRegisterXmlConfig();
        mAlicomAuthHelper.removeAuthRegisterViewConfig();
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);
        int dialogWidth = (int) (mScreenWidthDp * 0.8f);
        int dialogHeight = (int) (mScreenHeightDp * 0.65f);
        // mAlicomAuthHelper.addAuthRegisterXmlConfig(
        //     new AuthRegisterXmlConfig.Builder().setLayout(R.layout.custom_port_dialog_action_bar, new AbstractPnsViewDelegate() {
        //         @Override
        //         public void onViewCreated(View view) {
        //             findViewById(R.id.btn_close).setOnClickListener(new View.OnClickListener() {
        //                 @Override
        //                 public void onClick(View v) {
        //                     mAlicomAuthHelper.quitLoginPage();
        //                 }
        //             });
        //         }
        //     }).build()
        // );
        int logBtnOffset = dialogHeight / 2;
        mAlicomAuthHelper.setAuthUIConfig(
            new AuthUIConfig.Builder()
            // .setAppPrivacyOne("《自定义隐私协议》", "https://www.baidu.com")
            .setAppPrivacyColor(Color.GRAY, Color.parseColor("#3971fe"))
            .setPrivacyState(false)
            .setCheckboxHidden(true)
//            .setNavHidden(false)
//            .setNavColor(Color.parseColor("#3971fe"))
//            .setNavReturnImgPath("icon_close")
            .setWebNavColor(Color.parseColor("#3971fe"))
            .setAuthPageActIn("in_activity", "out_activity")
            .setAuthPageActOut("in_activity", "out_activity")
            .setVendorPrivacyPrefix("《")
            .setVendorPrivacySuffix("》")
            .setLogoImgPath("ic_launcher")
            .setLogBtnWidth(dialogWidth - 30)
            .setLogBtnMarginLeftAndRight(15)
            .setLogBtnBackgroundPath("button")
            .setLogoOffsetY(48)
            .setLogoWidth(42)
            .setLogoHeight(42)
            .setLogBtnOffsetY(logBtnOffset)
            .setSloganText("为了您的账号安全，请先绑定手机号")
            .setSloganOffsetY(logBtnOffset - 100)
            .setSloganTextSize(11)
            .setNumFieldOffsetY(logBtnOffset - 50)
            .setSwitchOffsetY(logBtnOffset + 50)
            .setSwitchAccTextSize(11)
//            .setPageBackgroundPath("dialog_background_color")
            .setNumberSize(17)
            .setLogBtnHeight(38)
            .setLogBtnTextSize(16)
            .setDialogWidth(dialogWidth)
            .setDialogHeight(dialogHeight)
            .setDialogBottom(false)
//            .setDialogAlpha(82)
            .setScreenOrientation(authPageOrientation)
            .create()
        );
    }

    // 获取key值
    private Object getValueByKey(MethodCall call, String key) {
        if (call != null && call.hasArgument(key)) {
            return call.argument(key);
        } else {
            return null;
        }
    }

    // 判断网络类型
    public static String getNetworkClass(Context context) {
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo info = cm.getActiveNetworkInfo();
        if(info==null || !info.isConnected())
            return "-"; //not connected
        if(info.getType() == ConnectivityManager.TYPE_WIFI)
            return "WIFI";
        if(info.getType() == ConnectivityManager.TYPE_MOBILE){
            int networkType = info.getSubtype();
            switch (networkType) {
                case TelephonyManager.NETWORK_TYPE_GPRS:
                case TelephonyManager.NETWORK_TYPE_EDGE:
                case TelephonyManager.NETWORK_TYPE_CDMA:
                case TelephonyManager.NETWORK_TYPE_1xRTT:
                case TelephonyManager.NETWORK_TYPE_IDEN: //api<8 : replace by 11
                    return "2G";
                case TelephonyManager.NETWORK_TYPE_UMTS:
                case TelephonyManager.NETWORK_TYPE_EVDO_0:
                case TelephonyManager.NETWORK_TYPE_EVDO_A:
                case TelephonyManager.NETWORK_TYPE_HSDPA:
                case TelephonyManager.NETWORK_TYPE_HSUPA:
                case TelephonyManager.NETWORK_TYPE_HSPA:
                case TelephonyManager.NETWORK_TYPE_EVDO_B: //api<9 : replace by 14
                case TelephonyManager.NETWORK_TYPE_EHRPD:  //api<11 : replace by 12
                case TelephonyManager.NETWORK_TYPE_HSPAP:  //api<13 : replace by 15
                    return "3G";
                case TelephonyManager.NETWORK_TYPE_LTE:    //api<11 : replace by 13
                    return "4G";
                default:
                    return "?";
            }
        }
        return "?";
    }
}

