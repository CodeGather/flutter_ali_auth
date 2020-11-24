/*
 * @Author: 21克的爱情
 * @Date: 2020-06-17 16:07:44
 * @Email: raohong07@163.com
 * @LastEditors: 21克的爱情
 * @LastEditTime: 2020-11-23 14:55:23
 * @Description:
 */
package com.jokui.rao.auth.ali_auth;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
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

import java.util.HashMap;
import java.util.Map;

import static com.jokui.rao.auth.ali_auth.AppUtils.dp2px;
import static com.mobile.auth.gatewayauth.PhoneNumberAuthHelper.SERVICE_TYPE_LOGIN;

/** AliAuthPlugin */
public class AliAuthPlugin extends FlutterActivity implements FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler {

    private final String TAG = "MainPortraitActivity";

    public static EventChannel.EventSink _events;
    private static final String METHOD_CHANNEL = "ali_auth";
    private static final String EVENT_CHANNEL = "ali_auth/event";

    private static Activity activity;
    private static Context mContext;
    private PhoneNumberAuthHelper mAlicomAuthHelper;
    private TokenResultListener mTokenListener;
    private static String token;
    private View switchTV;
    private int mScreenWidthDp;
    private int mScreenHeightDp;
    private MethodCall _call;
    private Result _methodResult;

    public AliAuthPlugin() {
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), METHOD_CHANNEL);
        final EventChannel eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), EVENT_CHANNEL);

        AliAuthPlugin instance = new AliAuthPlugin();

        eventChannel.setStreamHandler(instance);
        channel.setMethodCallHandler(instance);

        mContext = flutterPluginBinding.getApplicationContext();
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "ali_auth");
        channel.setMethodCallHandler(new AliAuthPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "init":
                _call = call;
                _methodResult = result;
                if( _events != null){
                    init();
                }
                break;
            case "getToken":
                getToken(call,result);
                break;
            case "preLogin":
                preLogin(call,result);
                break;
            case "login":
                login(call,result);
                break;
            case "loginDialog":
                loginDialog(call,result);
                break;
            case "checkVerifyEnable":
                checkVerifyEnable(call,result);
                break;
            case "setDebugMode":
                setDebugMode(call,result);
                break;
            default:
                throw new IllegalArgumentException("Unkown operation" + call.method);

        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onDetachedFromEngine: ");
    }

    ///activity 生命周期
    @Override
    public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
        Log.e("onAttachedToActivity", "onAttachedToActivity" + activityPluginBinding);
        activity = activityPluginBinding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "onDetachedFromActivityForConfigChanges: ");
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        Log.d(TAG, "onReattachedToActivityForConfigChanges: ");
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity: ");
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d("TAG", "onListen: "+events);
        /// 经过测试有时onlisten执行在onMethodCall至后
        if( _events == null && events != null){
            _events = events;
            init();
        }
    }

    @Override
    public void onCancel(Object arguments) {
        if( _events != null){
            _events = null;
        }
    }



    private void init() {
        /// 获取参数配置
        HashMap viewConfig = _call.argument("config");
        final JSONObject jsonObject = new JSONObject();

        /// 判断必要参数
        if(!_call.hasArgument("config") || viewConfig == null || !_call.hasArgument("sk")){
            Log.d(TAG, ("检测config 配置信息"));
            jsonObject.put("code", "500");
            jsonObject.put("msg", "The required parameter config or sk cannot be empty, please check the parameter configuration");
            jsonObject.put("data", null);
            //转化成json字符串
            _events.success(jsonObject);
            return;
        }

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

                        resultData(tokenRet);
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
                        _events.success(jsonObject);
                    }
                });
            }
        };
        mAlicomAuthHelper = PhoneNumberAuthHelper.getInstance(mContext, mTokenListener);

        mAlicomAuthHelper.setAuthSDKInfo((String) _call.argument("sk"));
        // 设置是否开启debug模式
        boolean isDebug =  !viewConfig.containsKey("isDebug") || viewConfig.get("isDebug") == null || (boolean) viewConfig.get("isDebug");
        mAlicomAuthHelper.getReporter().setLoggerEnable(isDebug);

        // 设置初始化界面的参数
        boolean isDialog =  !viewConfig.containsKey("isDialog") || viewConfig.get("isDialog") == null || !(boolean) viewConfig.get("isDialog");
        if (isDialog) {
            configLoginTokenPort(_call, _methodResult);
        } else {
            configLoginTokenPortDialog(_call, _methodResult);
        }

        // 判断网络是否支持
        mAlicomAuthHelper.checkEnvAvailable(SERVICE_TYPE_LOGIN);
        // UI 点击回调
        mAlicomAuthHelper.setUIClickListener(new AuthUIControlClickListener() {
            @Override
            public void onClick(String code, Context context, String jsonObj) {
                Log.e("xxxxxx", "OnUIControlClick:code=" + code + ", jsonObj=" + (jsonObj == null ? "" : jsonObj));
                jsonObject.put("code", code);
                jsonObject.put("msg", "phone");
                jsonObject.put("data", null);
                //转化成json字符串
                _events.success(jsonObject);
            }
        });

        // 开始预取号
        preLogin(_call, _methodResult);
    }

    /**
     * 注意:
     * super.onBackPressed()会自动调用finish()方法,关闭当前Activity.
     */
    @Override
    public void onBackPressed() {
        super.onBackPressed();
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code", "700000");
        jsonObject.put("msg", "⽤户取消免密登录");
        jsonObject.put("data", null);
        //转化成json字符串
        _events.success(jsonObject);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if ((keyCode == KeyEvent.KEYCODE_BACK)) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("code", "700000");
            jsonObject.put("msg", "⽤户取消免密登录");
            jsonObject.put("data", null);
            //转化成json字符串
            _events.success(jsonObject);
            return true;
        }else {
            return super.onKeyDown(keyCode, event);
        }
    }

    /** SDK 判断网络环境是否支持 */
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
                        _events.success(jsonObject);
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
                        _events.success(jsonObject);
                    }
                });
            }
        });
    }
    // 正常登录
    public void login(final MethodCall call, final MethodChannel.Result methodResult){
        getAuthListener();
        mAlicomAuthHelper.getLoginToken(mContext, 5000);
    }

    // dialog登录
    public void loginDialog(final MethodCall call, final MethodChannel.Result methodResult){
        getAuthListener();
        mAlicomAuthHelper.getLoginToken(mContext, 5000);
    }

    // 获取登录token
    public void getToken(final MethodCall call, final MethodChannel.Result methodResult){
        getAuthListener();
        mAlicomAuthHelper.getVerifyToken(5000);
    }

    // 获取监听数据
    private void getAuthListener(){
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
                        resultData(tokenRet);
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
                        resultData(tokenRet);
                        Log.d(TAG, ("失败:\n" + ret));
                    }
                });
            }
        });
    }

    private void resultData(TokenRet tokenRet){
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("data", null);

        switch (tokenRet.getCode()){
            case "600000":
                token = tokenRet.getToken();
                mAlicomAuthHelper.quitLoginPage();
                jsonObject.put("code", tokenRet.getCode());
                jsonObject.put("msg", "获取token成功！");
                jsonObject.put("data", token);
                break;
            case "600001":
                jsonObject.put("msg", "唤起授权页成功！");
                break;
            case "600002":
                jsonObject.put("msg", "唤起授权⻚失败！建议切换到其他登录⽅式");
                break;
            case "600004":
                jsonObject.put("msg", "获取运营商配置信息失败！创建⼯单联系⼯程师");
                break;
            case "600005":
                jsonObject.put("msg", "⼿机终端不安全！切换到其他登录⽅式");
                break;
            case "600007":
                jsonObject.put("msg", "未检测到sim卡！⽤户检查 SIM 卡后重试");
                break;
            case "600008":
                jsonObject.put("msg", "蜂窝⽹络未开启！⽤户开启移动⽹络后重试");
                break;
            case "600009":
                jsonObject.put("msg", "⽆法判断运营商! 创建⼯单联系⼯程师");
                break;
            case "600010":
                jsonObject.put("msg", "未知异常创建！⼯单联系⼯程师");
                break;
            case "600011":
                jsonObject.put("msg", "获取token失败！切换到其他登录⽅式");
                break;
            case "600012":
                jsonObject.put("msg", "预取号失败！");
                break;
            case "600013":
                jsonObject.put("msg", "运营商维护升级！该功能不可⽤创建⼯单联系⼯程师");
                break;
            case "600014":
                jsonObject.put("msg", "运营商维护升级！该功能已达最⼤调⽤次创建⼯单联系⼯程师");
                break;
            case "600015":
                jsonObject.put("msg", "接⼝超时！切换到其他登录⽅式");
                break;
            case "600017":
                jsonObject.put("msg", "AppID、Appkey解析失败! 秘钥未设置或者设置错误，请先检查秘钥信息，如果⽆法解决问题创建⼯单联系⼯程师");
                break;
            case "600021":
                jsonObject.put("msg", "点击登录时检测到运营商已切换！⽤户退出授权⻚，重新登录");
                break;
            case "600023":
                jsonObject.put("msg", "加载⾃定义控件异常！检查⾃定义控件添加是否正确");
                break;
            case "600024":
                jsonObject.put("msg", "终端环境检查⽀持认证");
                break;
            case "600025":
                jsonObject.put("msg", "终端检测参数错误检查传⼊参数类型与范围是否正确");
                break;
            case "600026":
                jsonObject.put("msg", "授权⻚已加载时不允许调⽤加速或预取号接⼝检查是否有授权⻚拉起后，去调⽤preLogin或者accelerateAuthPage的接⼝，该⾏为不允许");
                break;
            default:
                break;
        }
        jsonObject.put("code", tokenRet.getCode());
        _events.success(jsonObject);
    }

    private ImageView createLandDialogPhoneNumberIcon(String name, int rightMargin, int topMargin, float fontSize) {
        ImageView imageView = new ImageView(mContext);
        int size = AppUtils.dp2px(mContext, fontSize);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT
        );
        layoutParams.addRule(RelativeLayout.ALIGN_RIGHT, RelativeLayout.TRUE);
        layoutParams.topMargin = topMargin; //AppUtils.px2dp(mContext, topMargin);
        layoutParams.rightMargin = rightMargin; //AppUtils.px2dp(mContext, rightMargin);
        imageView.setLayoutParams(layoutParams);
        int resoureId = mContext.getResources().getIdentifier(name,"drawable", mContext.getPackageName());
        imageView.setBackgroundResource(resoureId);
        imageView.setScaleType(ImageView.ScaleType.CENTER);
        return imageView;
    }

    private View createLandDialogCustomSwitchView(int layoutHeight, float leftMargin, float topMargin, float fontSize) {
        View v = LayoutInflater.from(mContext).inflate(R.layout.custom_slogan, new RelativeLayout(mContext), false);
        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
                RelativeLayout.LayoutParams.MATCH_PARENT,
                RelativeLayout.LayoutParams.WRAP_CONTENT
        );
        // 左侧按钮布局
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
        layoutParams.topMargin = AppUtils.px2dp(mContext, topMargin);
        layoutParams.leftMargin = AppUtils.px2dp(mContext, leftMargin);
        layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP, RelativeLayout.TRUE);
        v.setLayoutParams(layoutParams);
        return v;
    }

    // 自定义UI
    private void initDynamicView() {
        int getCustomXml = mContext.getResources().getIdentifier("custom_login", "layout", mContext.getPackageName());
        // 判断是否有自定义布局文件，没有则加载默认布局文件
        if(getCustomXml == 0){
            getCustomXml = mContext.getResources().getIdentifier("custom_login_layout", "layout", mContext.getPackageName());
        }
        switchTV = LayoutInflater.from(mContext).inflate(getCustomXml, new RelativeLayout(mContext), false);
        RelativeLayout.LayoutParams mLayoutParams2 = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, dp2px(activity, 150));
        mLayoutParams2.addRule(RelativeLayout.CENTER_HORIZONTAL, RelativeLayout.TRUE);
        mLayoutParams2.setMargins(0, dp2px(mContext, 400), 0, 0);

        // 获取到图片列表的父控件
        LinearLayout list = switchTV.findViewById(R.id.container_icon);
        // 循环监听图片按钮
        for (int i = 0; i < list.getChildCount(); i++) {
            View view = list.getChildAt(i);
            if (view instanceof ImageView) {
                final int finalI = i;
                view.setOnClickListener(new View.OnClickListener() {
                    @Override public void onClick(View v) {
                        Log.d(TAG, "您点击了第" + finalI + "个按钮");
                        JSONObject jsonObject = new JSONObject();
                        jsonObject.put("code", "700005");
                        jsonObject.put("msg", "点击第三方登录按钮");
                        jsonObject.put("data", finalI);
                        //转化成json字符串
                        _events.success(jsonObject);
                    }
                });
            }
        }

        switchTV.setLayoutParams(mLayoutParams2);
    }

    // 自定义背景
    private void initBackgroundView( MethodCall call ) {
        Map viewConfig = (Map) call.argument("config");

        if(dataStatus( viewConfig, "customPageBackgroundLyout")){
            int getCustomXml = mContext.getResources().getIdentifier("custom_page_background", "layout", mContext.getPackageName());
            // 判断是否有自定义布局文件，没有则加载默认布局文件
            if(getCustomXml == 0){
                getCustomXml = mContext.getResources().getIdentifier("custom_page_view_background", "layout", mContext.getPackageName());
            }
            mAlicomAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
                .setLayout(getCustomXml, new AbstractPnsViewDelegate() {
                    @Override
                    public void onViewCreated(View view) {
                    }
                })
                .build());
        }
    }

    /// ⼀键登录授权⻚⾯
    private void configLoginTokenPort(final MethodCall call, final MethodChannel.Result methodResult) {
        configBuilder(call);

        initDynamicView();

        initBackgroundView(call);

        /// 添加第三方登录按钮
        mAlicomAuthHelper.addAuthRegistViewConfig(
            "switch_acc_tv",
            new AuthRegisterViewConfig.Builder()
                .setView(switchTV)
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
                .build()
        );

    }

    /// 判断数据
    private boolean dataStatus( Map data, String key ){
        if(data.containsKey(key) && data.get(key) != null){
            if((data.get(key) instanceof Float) || (data.get(key) instanceof Double) && (double) data.get(key) > -1){
                Log.d(TAG, "判断" + key + "字段类型为----------------------：Float");
                return true;
            } else if((data.get(key) instanceof Integer) || (data.get(key) instanceof Number) && (int) data.get(key) > -1){
                Log.d(TAG, "判断" + key + "字段类型为----------------------：Interfer");
                return true;
            } else if((data.get(key) instanceof Boolean) && (boolean) data.get(key)){
                Log.d(TAG, "判断" + key + "字段类型为----------------------：Boolean");
                return true;
            } else if((data.get(key) instanceof String) && !((String) data.get(key)).equals("")){
                Log.d(TAG, "判断" + key + "字段类型为----------------------：String");
                return true;
            } else {
                Log.d(TAG, "判断" + key + "字段类型为----------------------：未知");
                return false;
            }
        } else {
            Log.d(TAG, "判断" + key + "字段类型为----------------------：不存在");
            return false;
        }
    }

    /// 弹窗授权⻚⾯
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
        configBuilder(call);
//        mAlicomAuthHelper.setAuthUIConfig(
//                new AuthUIConfig.Builder()
//                        // .setAppPrivacyOne("《自定义隐私协议》", "https://www.baidu.com")
//                        .setAppPrivacyColor(Color.GRAY, Color.parseColor("#3971fe"))
//                        .setPrivacyState(false)
//                        .setCheckboxHidden(true)
//                        .setNavHidden(false)
//                        .setNavColor(Color.parseColor("#3971fe"))
//                        .setNavReturnImgPath("icon_close")
//                        .setWebNavColor(Color.parseColor("#3971fe"))
//                        .setAuthPageActIn("in_activity", "out_activity")
//                        .setAuthPageActOut("in_activity", "out_activity")
//                        .setVendorPrivacyPrefix("《")
//                        .setVendorPrivacySuffix("》")
//                        .setLogoImgPath("ic_launcher")
//                        .setLogBtnWidth(dialogWidth - 30)
//                        .setLogBtnMarginLeftAndRight(15)
//                        .setLogBtnBackgroundPath("button")
//                        .setLogoOffsetY(48)
//                        .setLogoWidth(42)
//                        .setLogoHeight(42)
//                        .setLogBtnOffsetY(logBtnOffset)
//                        .setSloganText("为了您的账号安全，请先绑定手机号")
//                        .setSloganOffsetY(logBtnOffset - 100)
//                        .setSloganTextSize(11)
//                        .setNumFieldOffsetY(logBtnOffset - 50)
//                        .setSwitchOffsetY(logBtnOffset + 50)
//                        .setSwitchAccTextSize(11)
//                        .setPageBackgroundPath("dialog_background_color")
//                        .setNumberSize(17)
//                        .setLogBtnHeight(38)
//                        .setLogBtnTextSize(16)
//                        .setDialogWidth(dialogWidth)
//                        .setDialogHeight(dialogHeight)
//                        .setDialogBottom(false)
//                        .setDialogAlpha(82)
//                        .setScreenOrientation(authPageOrientation)
//                        .create()
//        );


    }

    // 公共配置
    private void configBuilder(final MethodCall call){
        mAlicomAuthHelper.removeAuthRegisterXmlConfig();
        mAlicomAuthHelper.removeAuthRegisterViewConfig();

        Map viewConfig = (Map) call.argument("config");
        AuthUIConfig.Builder config = new AuthUIConfig.Builder();

        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }

        config.setScreenOrientation(authPageOrientation);

        int dialogWidth = (int) (mScreenWidthDp * 0.8f);
        int dialogHeight = (int) (mScreenHeightDp * 0.65f);
        /// 设置弹窗模式授权⻚宽度，单位dp，设置⼤于0即为弹窗模式
        if(dataStatus( viewConfig, "dialogWidth")){
            if((int) viewConfig.get("dialogWidth") > 0){
                dialogWidth = (int) viewConfig.get("dialogWidth");
                config.setDialogWidth(dialogWidth);
            }
        } else {
            if(dataStatus( viewConfig, "isDialog")){
                config.setDialogWidth(dialogWidth);
            }
        }

        /// 设置弹窗模式授权⻚⾼度，单位dp，设置⼤于0即为弹窗模式
        if(dataStatus( viewConfig, "dialogHeight")){
            if((int) viewConfig.get("dialogHeight") > 0){
                dialogHeight = (int) viewConfig.get("dialogHeight");
                config.setDialogHeight(dialogHeight);
            }
        } else {
            if(dataStatus( viewConfig, "isDialog")){
                config.setDialogHeight(dialogHeight);
            }
        }

        /// statusBarColor 设置状态栏颜⾊（系统版本 5.0 以上可设置）
        if(dataStatus( viewConfig, "statusBarColor")){
            config.setStatusBarColor(Color.parseColor((String) viewConfig.get("statusBarColor")));
        }
        /// 设置状态栏字体颜⾊（系统版本 6.0 以上可21设置⿊⾊、⽩⾊）。true 为⿊⾊
        if(dataStatus( viewConfig, "lightColor")){
            config.setLightColor((boolean) viewConfig.get("lightColor"));
        }
        /// 设置导航栏颜⾊
        if(dataStatus( viewConfig, "navColor")){
            config.setNavColor(Color.parseColor((String) viewConfig.get("navColor")));
        }
        /// 设置导航栏标题⽂字
        if(dataStatus( viewConfig, "navText")){
            config.setNavText((String) viewConfig.get("navText"));
        }
        /// 设置导航栏标题⽂字颜⾊
        if(dataStatus( viewConfig, "navTextColor")){
            config.setNavTextColor(Color.parseColor((String) viewConfig.get("navTextColor")));
        }
        /// 设置导航栏标题⽂字⼤⼩
        if(dataStatus( viewConfig, "navTextSize")){
            config.setNavTextSize((int) viewConfig.get("navTextSize"));
        }
        /// 设置导航栏返回键图⽚
        if(dataStatus( viewConfig, "navReturnImgPath")){
            config.setNavReturnImgPath((String) viewConfig.get("navReturnImgPath"));
        }

        /// 设置导航栏返回键图⽚宽度
        if(dataStatus( viewConfig, "navReturnImgWidth")){
            config.setNavReturnImgWidth((int) viewConfig.get("navReturnImgWidth"));
        }

        /// 设置导航栏返回键图⽚高度
        if(dataStatus( viewConfig, "navReturnImgHeight")){
            config.setNavReturnScaleType(ImageView.ScaleType.CENTER);
            config.setNavReturnImgHeight((int) viewConfig.get("navReturnImgHeight"));
        }

        /// 设置导航栏返回按钮隐藏
        if(dataStatus( viewConfig, "navReturnHidden")){
            config.setNavReturnHidden((boolean) viewConfig.get("navReturnHidden"));
        }
        /// 设置默认导航栏是否隐藏
        if(dataStatus( viewConfig, "navHidden")){
            config.setNavHidden((boolean) viewConfig.get("navHidden"));
        }
        /// 设置状态栏是否隐藏
        if(dataStatus( viewConfig, "statusBarHidden")){
            config.setStatusBarHidden((boolean) viewConfig.get("statusBarHidden"));
        }
        /// 设置状态栏UI属性 View.SYSTEM_UI_FLAG_LOW_PROFILE View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
        if(dataStatus( viewConfig, "statusBarUIFlag")){
            config.setStatusBarUIFlag((int) viewConfig.get("statusBarUIFlag"));
        }
        /// 设置协议⻚状态栏颜⾊（系统版本 5.0 以上可设置）不设置则与授权⻚设置⼀致
        if(dataStatus( viewConfig, "webViewStatusBarColor")){
            config.setWebViewStatusBarColor(Color.parseColor((String) viewConfig.get("webViewStatusBarColor")));
        }
        /// 设置协议⻚顶部导航栏背景⾊不设置则与授权⻚设置⼀致
        if(dataStatus( viewConfig, "webNavColor")){
            config.setWebNavColor(Color.parseColor((String) viewConfig.get("webNavColor")));
        }
        /// 设置协议⻚顶部导航栏标题颜⾊不设置则与授权⻚设置⼀致
        if(dataStatus( viewConfig, "webNavTextColor")){
            config.setWebNavTextColor(Color.parseColor((String) viewConfig.get("webNavTextColor")));
        }
        /// 设置协议⻚顶部导航栏⽂字⼤⼩22不设置则与授权⻚设置⼀致
        if(dataStatus( viewConfig, "webNavTextSize")){
            config.setWebNavTextSize((int) viewConfig.get("webNavTextSize"));
        }
        /// 设置协议⻚导航栏返回按钮图⽚路径不设置则与授权⻚设置⼀致
        if(dataStatus( viewConfig, "webNavReturnImgPath")){
            config.setWebNavReturnImgPath((String) viewConfig.get("webNavReturnImgPath"));
        }
        /// 设置底部虚拟按键背景⾊（系统版本 5.0 以上可设置）
        if(dataStatus( viewConfig, "bottomNavColor")){
            config.setBottomNavColor(Color.parseColor((String) viewConfig.get("bottomNavColor")));
        }
        /// 隐藏logo
        if(dataStatus( viewConfig, "logoHidden")){
            config.setLogoHidden((boolean) viewConfig.get("logoHidden"));
        }
        /// 设置logo 图⽚
        if(dataStatus( viewConfig, "logoImgPath")){
            config.setLogoImgPath((String) viewConfig.get("logoImgPath"));
        }
        /// 设置logo 控件宽度
        if(dataStatus( viewConfig, "logoWidth")){
            config.setLogoWidth((int) viewConfig.get("logoWidth"));
        }
        /// 设置logo 控件⾼度
        if(dataStatus( viewConfig, "logoHeight")){
            config.setLogoHeight((int) viewConfig.get("logoHeight"));
        }
        /// 设置logo 控件相对导航栏顶部的位移，单位dp
        if(dataStatus( viewConfig, "logoOffsetY")){
            config.setLogoOffsetY((int) viewConfig.get("logoOffsetY"));
        }
        /// 设置logo图⽚缩放模式 ImageView.ScaleType
        if(dataStatus( viewConfig, "logoScaleType")){
            config.setLogoScaleType(ImageView.ScaleType.valueOf((String) viewConfig.get("logoScaleType")));
        }
        /// 设置slogan ⽂字内容
        if(dataStatus( viewConfig, "sloganText")){
            config.setSloganText((String) viewConfig.get("sloganText"));
        }
        /// 设置slogan ⽂字颜⾊
        if(dataStatus( viewConfig, "sloganTextColor")){
            config.setSloganTextColor(Color.parseColor((String) viewConfig.get("sloganTextColor")));
        }
        /// 设置slogan ⽂字⼤⼩
        if(dataStatus( viewConfig, "sloganTextSize")){
            config.setSloganTextSize((int) viewConfig.get("sloganTextSize"));
        }
        /// 设置slogan 相对导航栏顶部的 位移，单位dp
        if(dataStatus( viewConfig, "sloganOffsetY")){
            config.setSloganOffsetY((int) viewConfig.get("sloganOffsetY"));
        }
        /// 设置⼿机号码字体颜⾊
        if(dataStatus( viewConfig, "numberColor")){
            config.setNumberColor(Color.parseColor((String) viewConfig.get("numberColor")));
        }
        /// 设置⼿机号码字体⼤⼩
        if(dataStatus( viewConfig, "numberSize")){
            config.setNumberSize((int) viewConfig.get("numberSize"));
        }
        /// 设置号码栏控件相对导航栏顶部的位移，单位 dp
        if(dataStatus( viewConfig, "numFieldOffsetY")){
            config.setNumFieldOffsetY((int) viewConfig.get("numFieldOffsetY"));
        }
        /// 设置号码栏相对于默认位置的X轴偏移量，单位dp
        if(dataStatus( viewConfig, "numberFieldOffsetX")){
            config.setNumberFieldOffsetX((int) viewConfig.get("numberFieldOffsetX"));
        }
        /// 设置⼿机号掩码的布局对⻬⽅式，只⽀持Gravity.CENTER_HORIZONTAL、Gravity.LEFT、Gravity.RIGHT三种对⻬⽅式
        if(dataStatus( viewConfig, "numberLayoutGravity")){
            config.setNumberLayoutGravity((int) viewConfig.get("numberLayoutGravity"));
        }
        /// 设置登录按钮⽂字
        if(dataStatus( viewConfig, "logBtnText")){
            config.setLogBtnText((String) viewConfig.get("logBtnText"));
        }
        /// 设置登录按钮⽂字颜⾊
        if(dataStatus( viewConfig, "logBtnTextColor")){
            config.setLogBtnTextColor(Color.parseColor((String) viewConfig.get("logBtnTextColor")));
        }
        /// 设置登录按钮⽂字⼤⼩
        if(dataStatus( viewConfig, "logBtnTextSize")){
            config.setLogBtnTextSize((int) viewConfig.get("logBtnTextSize"));
        }
        /// 设置登录按钮宽度，单位 dp
        if(dataStatus( viewConfig, "logBtnWidth")){
            config.setLogBtnWidth((int) viewConfig.get("logBtnWidth"));
        }
        /// 设置登录按钮⾼度，单位dp
        if(dataStatus( viewConfig, "logBtnHeight")){
            config.setLogBtnHeight((int) viewConfig.get("logBtnHeight"));
        }
        /// 设置登录按钮相对于屏幕左右边缘边距
        if(dataStatus( viewConfig, "logBtnMarginLeftAndRight")){
            config.setLogBtnMarginLeftAndRight((int) viewConfig.get("logBtnMarginLeftAndRight"));
        }
        /// 设置登录按钮背景图⽚路径
        if(dataStatus( viewConfig, "logBtnBackgroundPath")){
            config.setLogBtnBackgroundPath((String) viewConfig.get("logBtnBackgroundPath"));
        }
        /// 设置登录按钮相对导航栏顶部的位移，单位 dp
        if(dataStatus( viewConfig, "logBtnOffsetY")){
            config.setLogBtnOffsetY((int) viewConfig.get("logBtnOffsetY"));
        }
        /// 设置登录loading dialog 背景图⽚路径24
        if(dataStatus( viewConfig, "loadingImgPath")){
            config.setLoadingImgPath((String) viewConfig.get("loadingImgPath"));
        }
        /// 设置登陆按钮X轴偏移量，如果设置了setLogBtnMarginLeftAndRight，并且布局对⻬⽅式为左对⻬或者右对⻬,则会在margin的基础上再增加offsetX的偏移量，如果是居中对⻬，则仅仅会在居中的基础上再做offsetX的偏移。
        if(dataStatus( viewConfig, "logBtnOffsetX")){
            config.setLogBtnOffsetX((int) viewConfig.get("logBtnOffsetX"));
        }
        /// 设置登陆按钮布局对⻬⽅式，只⽀持Gravity.CENTER_HORIZONTAL、Gravity.LEFT、Gravity.RIGHT三种对⻬⽅式
        if(dataStatus( viewConfig, "logBtnLayoutGravity")){
            config.setLogBtnLayoutGravity((int) viewConfig.get("logBtnLayoutGravity"));
        }
        /// 设置开发者隐私条款 1 名称和URL(名称，url) String,String
        if(dataStatus( viewConfig, "appPrivacyOne")){
            String[] appPrivacyOne = ((String) viewConfig.get("appPrivacyOne")).split(",");
            config.setAppPrivacyOne(appPrivacyOne[0], appPrivacyOne[1]);
        }
        /// 设置开发者隐私条款 2 名称和URL(名称，url) String,String
        if(dataStatus( viewConfig, "appPrivacyTwo")){
            String[] appPrivacyTwo = ((String) viewConfig.get("appPrivacyTwo")).split(",");
            config.setAppPrivacyTwo(appPrivacyTwo[0], appPrivacyTwo[1]);
        }
        /// 设置隐私条款名称颜⾊(基础⽂字颜⾊，协议⽂字颜⾊)
        if(dataStatus( viewConfig, "appPrivacyColor")){
            String[] appPrivacyColor = ((String) viewConfig.get("appPrivacyColor")).split(",");
            config.setAppPrivacyColor(Color.parseColor(appPrivacyColor[0]), Color.parseColor(appPrivacyColor[1]));
        }
        /// 设置隐私条款相对导航栏顶部的位移，单位dp
        if(dataStatus( viewConfig, "privacyOffsetY")){
            config.setPrivacyOffsetY((int) viewConfig.get("privacyOffsetY"));
        }
        /// 设置隐私条款是否默认勾选
        if(dataStatus( viewConfig, "privacyState")){
            config.setPrivacyState((boolean) viewConfig.get("privacyState"));
        }
        /// 设置隐私条款⽂字对⻬⽅式，单位Gravity.xxx
        if(dataStatus( viewConfig, "protocolGravity")){
            config.setProtocolGravity((int) viewConfig.get("protocolGravity"));
        }
        /// 设置隐私条款⽂字⼤⼩，单位sp
        if(dataStatus( viewConfig, "privacyTextSize")){
            config.setPrivacyTextSize((int) viewConfig.get("privacyTextSize"));
        }
        /// 设置隐私条款距离⼿机左右边缘的边距，单位dp
        if(dataStatus( viewConfig, "privacyMargin")){
            config.setPrivacyMargin((int) viewConfig.get("privacyMargin"));
        }
        /// 设置开发者隐私条款前置⾃定义25⽂案
        if(dataStatus( viewConfig, "privacyBefore")){
            config.setPrivacyBefore((String) viewConfig.get("privacyBefore"));
        }
        /// 设置开发者隐私条款尾部⾃定义⽂案
        if(dataStatus( viewConfig, "privacyEnd")){
            config.setPrivacyEnd((String) viewConfig.get("privacyEnd"));
        }
        /// 设置复选框是否隐藏
        if(dataStatus( viewConfig, "checkboxHidden")){
            config.setCheckboxHidden((boolean) viewConfig.get("checkboxHidden"));
        }
        /// 设置复选框未选中时图⽚
        if(dataStatus( viewConfig, "uncheckedImgPath")){
            config.setUncheckedImgPath((String) viewConfig.get("uncheckedImgPath"));
        }
        /// 设置复选框选中时图⽚
        if(dataStatus( viewConfig, "checkedImgPath")){
            config.setCheckedImgPath((String) viewConfig.get("checkedImgPath"));
        }
        /// 设置运营商协议前缀符号，只能设置⼀个字符，且只能设置<>()《》【】『』[]（）中的⼀个
        if(dataStatus( viewConfig, "vendorPrivacyPrefix")){
            config.setVendorPrivacyPrefix((String) viewConfig.get("vendorPrivacyPrefix"));
        }
        /// 设置运营商协议后缀符号，只能设置⼀个字符，且只能设置<>()《》【】『』[]（）中的⼀个
        if(dataStatus( viewConfig, "vendorPrivacySuffix")){
            config.setVendorPrivacySuffix((String) viewConfig.get("vendorPrivacySuffix"));
        }
        /// 设置隐私栏的布局对⻬⽅式，该接⼝控制了整个隐私栏（包含checkbox）在其⽗布局中的对⻬⽅式，⽽setProtocolGravity控制的是隐私协议⽂字内容在⽂本框中的对⻬⽅式
        if(dataStatus( viewConfig, "protocolLayoutGravity")){
            config.setProtocolLayoutGravity((int) viewConfig.get("protocolLayoutGravity"));
        }
        /// 设置隐私栏X轴偏移量，单位dp
        if(dataStatus( viewConfig, "privacyOffsetX")){
            config.setPrivacyOffsetX((int) viewConfig.get("privacyOffsetX"));
        }
        /// 设置checkbox未勾选时，点击登录按钮toast是否显示
        if(dataStatus( viewConfig, "logBtnToastHidden")){
            config.setLogBtnToastHidden((boolean) viewConfig.get("logBtnToastHidden"));
        }
        /// 设置授权⻚进场动画
        if(dataStatus( viewConfig, "authPageActIn")){
            String[] authPageActIn = ((String) viewConfig.get("authPageActIn")).split(",");
            config.setAuthPageActIn(authPageActIn[0], authPageActIn[1]);
        }
        /// 设置授权⻚退出动画
        if(dataStatus( viewConfig, "authPageActOut")){
            String[] authPageActOut = ((String) viewConfig.get("authPageActOut")).split(",");
            config.setAuthPageActOut(authPageActOut[0], authPageActOut[1]);
        }
        /// 设置授权⻚背景图drawable资源的⽬录，不需要加后缀，⽐如图⽚在drawable中的存放⽬录是res/drawablexxhdpi/loading.png,则传⼊参数为"loading"，setPageBackgroundPath("loading")。
        if(dataStatus( viewConfig, "pageBackgroundPath")){
            config.setPageBackgroundPath((String) viewConfig.get("pageBackgroundPath"));
        }

        /// 设置切换按钮点是否可⻅
        if(dataStatus( viewConfig, "switchAccHidden")){
            config.setSwitchAccHidden((boolean) viewConfig.get("switchAccHidden"));
        }

        /// 设置切换按钮⽂字内容
        if(dataStatus( viewConfig, "switchAccText")){
            config.setSwitchAccText((String) viewConfig.get("switchAccText"));
        }

        /// 设置切换按钮⽂字颜⾊
        if(dataStatus( viewConfig, "switchAccTextColor")){
            config.setSwitchAccTextColor(Color.parseColor((String) viewConfig.get("switchAccTextColor")));
        }

        /// 设置切换按钮⽂字⼤⼩
        if(dataStatus( viewConfig, "switchAccTextSize")){
            config.setSwitchAccTextSize((int) viewConfig.get("switchAccTextSize"));
        }

        /// 设置换按钮相对导航栏顶部的位移，单位 dp
        if(dataStatus( viewConfig, "switchOffsetY")){
            config.setSwitchOffsetY((int) viewConfig.get("switchOffsetY"));
        }

        /// 是dislog的配置
        if(dataStatus( viewConfig, "isDialog")){
            /// 设置换按钮相对导航栏顶部的位移，单位 dp
            if(dataStatus( viewConfig, "dialogAlpha")){
                config.setDialogAlpha(Float.parseFloat(String.valueOf((double) viewConfig.get("dialogAlpha"))));
            }

            /// 设置弹窗模式授权⻚X轴偏移, 单位dp
            if(dataStatus( viewConfig, "dialogOffsetX")){
                config.setDialogOffsetX((int) viewConfig.get("dialogOffsetX"));
            }

            /// 设置弹窗模式授权⻚Y轴偏移, 单位dp
            if(dataStatus( viewConfig, "dialogOffsetY")){
                config.setDialogOffsetY((int) viewConfig.get("dialogOffsetY"));
            }

            /// 设置授权⻚是否居于底部
            if(dataStatus( viewConfig, "dialogBottom")){
                config.setDialogBottom((boolean) viewConfig.get("dialogBottom"));
            }
        }

        mAlicomAuthHelper.setAuthUIConfig(config.create());
    }

    /// 获取key
    private Object getValueByKey(MethodCall call, String key) {
        if (call != null && call.hasArgument(key)) {
            return call.argument(key);
        } else {
            return null;
        }
    }

    /// 获取屏幕
    private void updateScreenSize(int authPageScreenOrientation) {
        int screenHeightDp = AppUtils.px2dp(mContext, AppUtils.getPhoneHeightPixels(mContext));
        int screenWidthDp = AppUtils.px2dp(mContext, AppUtils.getPhoneWidthPixels(mContext));
        mScreenWidthDp = screenWidthDp;
        mScreenHeightDp = screenHeightDp;
    }

}

