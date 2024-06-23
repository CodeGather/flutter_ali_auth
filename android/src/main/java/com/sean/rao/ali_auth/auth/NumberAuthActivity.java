package com.sean.rao.ali_auth.auth;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import org.jetbrains.annotations.Nullable;

import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.PreLoginResultListener;
import com.mobile.auth.gatewayauth.ResultCode;
import com.mobile.auth.gatewayauth.TokenResultListener;
import com.mobile.auth.gatewayauth.model.TokenRet;
import com.sean.rao.ali_auth.utils.ExecutorManager;

public class NumberAuthActivity extends Activity {
    private static final String TAG = NumberAuthActivity.class.getSimpleName();
    private PhoneNumberAuthHelper mAuthHelper;
    private TokenResultListener mVerifyListener;
    private Button mAuthButton;
    private EditText mNumberEt;
    private String phoneNumber;
    private ProgressDialog mProgressDialog;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_auth);
//        mAuthButton = findViewById(R.id.auth_btn);
//        mNumberEt = findViewById(R.id.et_number);
        mAuthButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                phoneNumber = mNumberEt.getText().toString();
                //判断手机号是否合法
                if (!TextUtils.isEmpty(phoneNumber)) {
                    showLoadingDialog("正在进行本机号码校验");
                    numberAuth(5000);
                }
            }
        });
        sdkInit();
        accelerateVerify(5000);
    }

    private void sdkInit() {
        mVerifyListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                Log.i(TAG, "获取token成功：" + s);
                try {
                    TokenRet pTokenRet = TokenRet.fromJson(s);
                    if (ResultCode.CODE_SUCCESS.equals(pTokenRet.getCode()) && !TextUtils.isEmpty(pTokenRet.getToken())) {
                        getResultWithToken(pTokenRet.getToken(), phoneNumber);
                    }
                    mAuthHelper.setAuthListener(null);
                } catch (Exception e) {
                    e.fillInStackTrace();
                }
            }

            @Override
            public void onTokenFailed(final String s) {
                Log.i(TAG, "获取token失败：" + s);
                NumberAuthActivity.this.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        hideLoadingDialog();
                        setResult(2);
                        finish();
                    }
                });
                mAuthHelper.setAuthListener(null);
            }
        };
        mAuthHelper = PhoneNumberAuthHelper.getInstance(getApplicationContext(), mVerifyListener);
    }

    /**
     * 加速校验
     * 进入输入手机号页面调用此接口，用户输入完手机号点击确定可以更快的获取token
     * @param timeout
     */
    public void accelerateVerify(int timeout) {
        mAuthHelper.accelerateVerify(timeout, new PreLoginResultListener() {
            @Override
            public void onTokenSuccess(String vendor) {
                //成功时返回运营商简称
                Log.i(TAG, "accelerateVerify：" + vendor);
            }

            @Override
            public void onTokenFailed(String vendor, String errorMsg) {
                Log.e(TAG, "accelerateVerify：" + vendor + "， " + errorMsg);
            }
        });
    }

    public void numberAuth(int timeout) {
        mAuthHelper.setAuthListener(mVerifyListener);
        mAuthHelper.getVerifyToken(timeout);
    }

    public void getResultWithToken(final String token, final String phoneNumber) {
        ExecutorManager.run(new Runnable() {
            @Override
            public void run() {
                // final String result = verifyNumber(token, phoneNumber);
                NumberAuthActivity.this.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        hideLoadingDialog();
                        Intent pIntent = new Intent();
                        pIntent.putExtra("result", phoneNumber);
                        setResult(1, pIntent);
                        finish();
                    }
                });
            }
        });
    }

    public void showLoadingDialog(String hint) {
        if (mProgressDialog == null) {
            mProgressDialog = new ProgressDialog(this);
            mProgressDialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        }
        mProgressDialog.setMessage(hint);
        mProgressDialog.setCancelable(true);
        mProgressDialog.show();
    }

    public void hideLoadingDialog() {
        if (mProgressDialog != null) {
            mProgressDialog.dismiss();
        }
    }
}
