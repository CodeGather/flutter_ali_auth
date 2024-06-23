package com.sean.rao.ali_auth.common;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.fastjson2.JSONException;
import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.AuthUIControlClickListener;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ResultCode;
import com.sean.rao.ali_auth.utils.StatusAll;
import com.sean.rao.ali_auth.utils.UtilTool;

import io.flutter.plugin.common.EventChannel;

/**
 * @ProjectName: android
 * @Package: com.sean.rao.ali_auth.common
 * @ClassName: CUstomAuthUIControlClickListener
 * @Description: java类作用描述
 * @Author: liys
 * @CreateDate: 5/12/22 5:26 PM
 * @UpdateUser: 更新者
 * @UpdateDate: 5/12/22 5:26 PM
 * @UpdateRemark: 更新说明
 * @Version: 1.0
 */
public class CustomAuthUIControlClickListener extends LoginParams implements AuthUIControlClickListener {
  private final String TAG = "CustomAuth: ";

  public CustomAuthUIControlClickListener() {
  }

  @Override
  public void onClick(String code, Context context, String jsonString) {
    JSONObject jsonDataObj = new JSONObject();
    if(!TextUtils.isEmpty(jsonString)) {
      jsonDataObj = JSONObject.parseObject(jsonString);
    }

    switch (code) {
      //点击授权页默认样式的返回按钮
      case ResultCode.CODE_ERROR_USER_CANCEL:
        Log.e(TAG, "点击了授权页默认返回按钮");
        mAuthHelper.quitLoginPage();
        break;
      //点击授权页默认样式的切换其他登录方式 会关闭授权页
      //如果不希望关闭授权页那就setSwitchAccHidden(true)隐藏默认的  通过自定义view添加自己的
      case ResultCode.CODE_ERROR_USER_SWITCH:
        mAuthHelper.quitLoginPage();
        Log.e(TAG, "点击了授权页默认切换其他登录方式");
        break;
      //点击一键登录按钮会发出此回调
      //当协议栏没有勾选时 点击按钮会有默认toast 如果不需要或者希望自定义内容 setLogBtnToastHidden(true)隐藏默认Toast
      //通过此回调自己设置toast
      case ResultCode.CODE_ERROR_USER_LOGIN_BTN:
        break;
      //checkbox状态改变触发此回调
      case ResultCode.CODE_ERROR_USER_CHECKBOX:
        isChecked = jsonDataObj.getBooleanValue("isChecked");
        Log.e(TAG, "checkbox状态变为" + jsonDataObj.getBooleanValue("isChecked"));
        jsonDataObj = null;
        break;
      //点击协议栏触发此回调
      case ResultCode.CODE_ERROR_USER_PROTOCOL_CONTROL:
        Log.e(TAG, "点击协议，" + "name: " + jsonDataObj.getString("name") + ", url: " + jsonDataObj.getString("url"));
        break;
      default:
        break;
    }
    showResult(code, null, jsonDataObj);
  }
}
