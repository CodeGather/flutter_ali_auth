package com.sean.rao.ali_auth.login;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.util.Log;

import androidx.annotation.IntRange;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.PreLoginResultListener;
import com.mobile.auth.gatewayauth.ResultCode;
import com.mobile.auth.gatewayauth.TokenResultListener;
import com.mobile.auth.gatewayauth.model.TokenRet;
import com.sean.rao.ali_auth.common.Constant;
import com.sean.rao.ali_auth.config.BaseUIConfig;
import com.sean.rao.ali_auth.utils.UtilTool;

import java.util.Iterator;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

/**
 * 进app直接登录的场景
 */
public class OneKeyLoginPublic {
    private static final String TAG = OneKeyLoginPublic.class.getSimpleName();

    public PhoneNumberAuthHelper mPhoneNumberAuthHelper;
    public TokenResultListener mTokenResultListener;

    public Activity mActivity;
    public Context mContext;
    public BaseUIConfig mUIConfig;
    public JSONObject jsonObject;
    public EventChannel.EventSink eventSink;
    public boolean sdkAvailable = true;
    public AuthUIConfig.Builder config;

    public OneKeyLoginPublic(Activity activity, EventChannel.EventSink _eventSink, Object arguments){
        mActivity = activity;
        mContext = activity.getBaseContext();
        eventSink = _eventSink;
        jsonObject = formatParmas(arguments);
        config = getFormatConfig(jsonObject);

        // 初始化SDK
        sdkInit();
        mUIConfig = BaseUIConfig.init(jsonObject.getIntValue("pageType"), mActivity, _eventSink, jsonObject, config, mPhoneNumberAuthHelper);
        if (jsonObject.getBooleanValue("isDelay")) {
        } else {
            oneKeyLogin();
        }
    }

    /**
     * 初始化SDK
     */
    private void sdkInit() {
        mTokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                try {
                    Log.i(TAG, "checkEnvAvailable：" + s);
                    TokenRet tokenRet = TokenRet.fromJson(s);
                    if (ResultCode.CODE_ERROR_ENV_CHECK_SUCCESS.equals(tokenRet.getCode())) {
                        /// 延时登录的情况下加速拉起一键登录页面
                        if (jsonObject.getBooleanValue("isDelay")) {
                            accelerateLoginPage(5000);
                        }
                    }

                    if (ResultCode.CODE_SUCCESS.equals(tokenRet.getCode())) {
                        Log.i("TAG", "获取token成功：" + s);
                        mPhoneNumberAuthHelper.quitLoginPage();
                        mPhoneNumberAuthHelper.setAuthListener(null);
                    }
                    eventSink.success(UtilTool.resultFormatData(tokenRet.getCode(), null, tokenRet.getToken()));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onTokenFailed(String s) {
                sdkAvailable = false;
                Log.e(TAG, "获取token失败：" + s);
                try {
                    TokenRet tokenRet = TokenRet.fromJson(s);
                    eventSink.success(UtilTool.resultFormatData(tokenRet.getCode(), tokenRet.getMsg(),null));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                mPhoneNumberAuthHelper.setAuthListener(null);
            }
        };
        mPhoneNumberAuthHelper = PhoneNumberAuthHelper.getInstance(mContext, mTokenResultListener);
        mPhoneNumberAuthHelper.getReporter().setLoggerEnable(jsonObject.getBooleanValue("isDebug"));
        mPhoneNumberAuthHelper.setAuthSDKInfo(jsonObject.getString("androidSk"));

        /// 延时的情况下进行预取号，加快拉取授权页面
        if (jsonObject.getBooleanValue("isDelay")) {
            mPhoneNumberAuthHelper.checkEnvAvailable(PhoneNumberAuthHelper.SERVICE_TYPE_LOGIN);
        }
    }

    /**
     * 延时登录操作
     * @param timeout
     */
    public void startLogin(int timeout){
        if (sdkAvailable) {
            getLoginToken(timeout);
        } else {
            //如果环境检查失败 使用其他登录方式
        }
    }

    /**
     * 进入app就需要登录的场景使用
     */
    private void oneKeyLogin() {
        mPhoneNumberAuthHelper = PhoneNumberAuthHelper.getInstance(mActivity.getApplicationContext(), mTokenResultListener);
        mPhoneNumberAuthHelper.checkEnvAvailable(2);
        mUIConfig.configAuthPage();
        getLoginToken(5000);
    }

    /**
     * 在不是一进app就需要登录的场景 建议调用此接口 加速拉起一键登录页面
     * 等到用户点击登录的时候 授权页可以秒拉
     * 预取号的成功与否不影响一键登录功能，所以不需要等待预取号的返回。
     * @param timeout
     */
    private void accelerateLoginPage(int timeout) {
        mPhoneNumberAuthHelper.accelerateLoginPage(timeout, new PreLoginResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                Log.e(TAG, "预取号成功: " + s);
                eventSink.success(UtilTool.resultFormatData("600016", null, s));
            }
            @Override
            public void onTokenFailed(String s, String s1) {
                Log.e(TAG, "预取号失败：" + ", " + s1);
                JSONObject jsonDataObj = new JSONObject();
                jsonDataObj.put("name", s);
                jsonDataObj.put("name1", s1);
                eventSink.success(UtilTool.resultFormatData("600012", null, jsonDataObj));
            }
        });
    }

    /**
     * 拉起授权页
     * @param timeout 超时时间
     */
    public void getLoginToken(int timeout) {
        mUIConfig.configAuthPage();
        mTokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                TokenRet tokenRet = TokenRet.fromJson(s);
                try {
                    if (ResultCode.CODE_START_AUTHPAGE_SUCCESS.equals(tokenRet.getCode())) {
                        Log.i(TAG, "唤起授权页成功：" + s);
                    }
                    eventSink.success(UtilTool.resultFormatData(tokenRet.getCode(), tokenRet.getMsg(), tokenRet.getToken()));
                    if (ResultCode.CODE_SUCCESS.equals(tokenRet.getCode())) {
                        Log.i(TAG, "获取token成功：" + s);
                        mPhoneNumberAuthHelper.quitLoginPage();
                        mPhoneNumberAuthHelper.setAuthListener(null);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onTokenFailed(String s) {
                Log.e(TAG, "获取token失败：" + s);
                //如果环境检查失败 使用其他登录方式
                try {
                    TokenRet tokenRet = TokenRet.fromJson(s);
                    eventSink.success(UtilTool.resultFormatData(tokenRet.getCode(), tokenRet.getMsg(),null));
                } catch (Exception e) {
                    e.printStackTrace();
                }
                mPhoneNumberAuthHelper.quitLoginPage();
                mPhoneNumberAuthHelper.setAuthListener(null);
            }
        };
        mPhoneNumberAuthHelper.setAuthListener(mTokenResultListener);
        mPhoneNumberAuthHelper.getLoginToken(mContext, timeout);
    }


    /**
     * SDK环境检查函数，检查终端是否⽀持号码认证，通过TokenResultListener返回code
     * type 1：本机号码校验 2: ⼀键登录
     * 600024 终端⽀持认证
     * 600013 系统维护，功能不可⽤
     */
    public void checkEnvAvailable(@IntRange(from = 1, to = 2) int type){
        mPhoneNumberAuthHelper.checkEnvAvailable(PhoneNumberAuthHelper.SERVICE_TYPE_LOGIN);
    }

    /**
     * 退出授权页面
     */
    public void quitPage(){
        mPhoneNumberAuthHelper.quitLoginPage();
    }


    /**
     * 处理参数，对参数进行处理包含color、Path
     * @param parmas
     * @return
     */
    private JSONObject formatParmas(Object parmas){
        JSONObject formatData = JSONObject.parseObject(JSONObject.toJSONString(parmas));
        Iterator iter = formatData.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry entry = (Map.Entry) iter.next();
            // System.out.println(entry.getKey() + "----" + entry.getValue());
            // 判断是否使眼色代码
            if ((String.valueOf(entry.getKey()).contains("color") || String.valueOf(entry.getKey()).contains("Color")) && String.valueOf(entry.getValue()).contains("#"))
            {
                formatData.put(String.valueOf(entry.getKey()), Color.parseColor(formatData.getString(entry.getKey().toString())));
            }
            // 判断是否时路径字段
            // 排除按钮状态的背景logBtnBackgroundPath
            else if (
                    !String.valueOf(entry.getKey()).contains("logBtnBackgroundPath") &&
                            (String.valueOf(entry.getKey()).contains("path") || String.valueOf(entry.getKey()).contains("Path")) &&
                            !formatData.getString(entry.getKey().toString()).isEmpty() &&
                            !formatData.getString(entry.getKey().toString()).contains("http"))
            {
                formatData.put(String.valueOf(entry.getKey()), UtilTool.flutterToPath(formatData.getString(entry.getKey().toString())));
            }
        }

        return formatData;
    }


    /**
     * 对配置参数进行格式化并且转换
     * @param jsonObject
     * @return
     */
    private AuthUIConfig.Builder getFormatConfig(JSONObject jsonObject){
        AuthUIConfig.Builder config = JSON.parseObject(JSONObject.toJSONString(jsonObject), AuthUIConfig.Builder.class);

        // 设置按钮的背景
        if (jsonObject.getString("logBtnBackgroundPath") != null && jsonObject.getString("logBtnBackgroundPath").contains(",")) {
            config.setLogBtnBackgroundDrawable(UtilTool.getStateListDrawable(mContext, jsonObject.getString("logBtnBackgroundPath")));
        } else {
            config.setLoadingBackgroundPath(UtilTool.flutterToPath(jsonObject.getString("logBtnBackgroundPath")));
        }
        /**
         *  authPageActIn = var1;
         *  activityOut = var2;
         */
        if(UtilTool.dataStatus(jsonObject, "authPageActIn") && UtilTool.dataStatus(jsonObject, "activityOut")){
            config.setAuthPageActIn(jsonObject.getString("authPageActIn"), jsonObject.getString("activityOut"));
        }
        /**
         *  authPageActOut = var1;
         *  activityIn = var2;
         */
        if(UtilTool.dataStatus(jsonObject, "authPageActOut") && UtilTool.dataStatus(jsonObject, "activityIn")){
            config.setAuthPageActIn(jsonObject.getString("authPageActOut"), jsonObject.getString("activityIn"));
        }
        /**
         *  protocolOneName = var1;
         *  protocolOneURL = var2;
         */
        if(UtilTool.dataStatus(jsonObject, "protocolOneName") && UtilTool.dataStatus(jsonObject, "protocolOneURL")){
            config.setAppPrivacyOne(jsonObject.getString("protocolOneName"), jsonObject.getString("protocolOneURL"));
        }
        /**
         *  protocolTwoName = var1;
         *  protocolTwoURL = var2;
         */
        if(UtilTool.dataStatus(jsonObject, "protocolTwoName") && UtilTool.dataStatus(jsonObject, "protocolTwoURL")){
            config.setAppPrivacyTwo(jsonObject.getString("protocolTwoName"), jsonObject.getString("protocolTwoURL"));
        }
        /**
         *  protocolThreeName = var1;
         *  protocolThreeURL = var2;
         */
        if(UtilTool.dataStatus(jsonObject, "protocolThreeName") && UtilTool.dataStatus(jsonObject, "protocolThreeURL")){
            config.setAppPrivacyThree(jsonObject.getString("protocolThreeName"), jsonObject.getString("protocolThreeURL"));
        }
        /**
         *  protocolColor = var1;
         *  protocolOneColor = var2;
         *  protocolTwoColor = var2;
         *  protocolThreeColor = var2;
         */
        if(UtilTool.dataStatus(jsonObject, "protocolColor") && UtilTool.dataStatus(jsonObject, "protocolCustomColor")){
            config.setAppPrivacyColor(jsonObject.getIntValue("protocolColor"), jsonObject.getIntValue("protocolCustomColor"));
        }
        return config;
    }
}
