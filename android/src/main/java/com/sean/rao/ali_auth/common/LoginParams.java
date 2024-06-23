package com.sean.rao.ali_auth.common;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;

import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.TokenResultListener;
import com.sean.rao.ali_auth.config.BaseUIConfig;
import com.sean.rao.ali_auth.utils.StatusAll;
import com.sean.rao.ali_auth.utils.UtilTool;

import org.jetbrains.annotations.Nullable;

import io.flutter.plugin.common.EventChannel;

public class LoginParams {
    public static Activity mActivity;

    public static Context mContext;

    public static BaseUIConfig mUIConfig;

    public static JSONObject jsonObject;

    public static AuthUIConfig.Builder config;
    public static boolean sdkAvailable = true;
    public static EventChannel.EventSink eventSink;
    public static TokenResultListener mTokenResultListener;
    public static Boolean isChecked;

    public static PhoneNumberAuthHelper mAuthHelper;

    public void showResult(String code, String message, Object data){
        if (eventSink != null) {
            JSONObject result = resultFormatData(code, message, data);
            result.put("isChecked", isChecked);
            eventSink.success(result);
        }
    }

    /**
     * 返回数据封装
     * @param code
     * @param msg
     * @param jsonDataObj
     * @return
     */
    public static JSONObject resultFormatData(String code, @Nullable String msg, @Nullable Object jsonDataObj){
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("code", code);
        jsonObj.put("msg", msg != null && !msg.isEmpty() ? msg : StatusAll.getName(code));
        jsonObj.put("data", jsonDataObj != null ? jsonDataObj : "");
        jsonObj.put("isChecked", jsonObject.getBooleanValue("privacyState", false));
        return jsonObj;
    }
}
