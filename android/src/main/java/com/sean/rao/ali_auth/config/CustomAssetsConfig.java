package com.sean.rao.ali_auth.config;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;
import com.sean.rao.ali_auth.R;
import com.sean.rao.ali_auth.common.CacheManage;
import com.sean.rao.ali_auth.common.MediaFileUtil;
import com.sean.rao.ali_auth.common.NativeBackgroundAdapter;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import io.flutter.plugin.common.EventChannel;

import static com.nirvana.tools.core.AppUtils.dp2px;

/**
 * xml文件方便预览
 * 可以通过addAuthRegisterXmlConfig一次性统一添加授权页的所有自定义view
 */
public class CustomAssetsConfig extends BaseUIConfig {
    private CacheManage mCacheManage;
    private ExecutorService mThreadExecutor;
    private NativeBackgroundAdapter nativeBackgroundAdapter;
    public CustomAssetsConfig() {
        super();
        String fileType = "imagePath";
        if (jsonObject.getString("pageBackgroundPath") != null && !jsonObject.getString("pageBackgroundPath").isEmpty()) {
            if (MediaFileUtil.isImageGifFileType(jsonObject.getString("pageBackgroundPath"))) {
                fileType = "gifPath";
            } else if (MediaFileUtil.isVideoFileType(jsonObject.getString("pageBackgroundPath"))) {
                fileType = "videoPath";
            }
        }
        mCacheManage=new CacheManage(mActivity.getApplication());
        mThreadExecutor=new ThreadPoolExecutor(Runtime.getRuntime().availableProcessors(),
            Runtime.getRuntime().availableProcessors(),
            0, 
            TimeUnit.SECONDS,
            new ArrayBlockingQueue<Runnable>(10),
            new ThreadPoolExecutor.CallerRunsPolicy()
        );
        nativeBackgroundAdapter = new NativeBackgroundAdapter(mCacheManage, mThreadExecutor, fileType);
    }
    @Override
    public void configAuthPage() {
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);
        //sdk默认控件的区域是marginTop50dp
        int designHeight = mScreenHeightDp - 50;
        int unit = designHeight / 10;
        mAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
            .setLayout(R.layout.authsdk_widget_custom_layout, new AbstractPnsViewDelegate() {
                @Override
                public void onViewCreated(View view) {
                    final FrameLayout fly_container = view.findViewById(R.id.fly_container);
//                    final Button close = view.findViewById(R.id.close);
//                    fly_container.setOnApplyWindowInsetsListener();
                    nativeBackgroundAdapter.solveView(fly_container, "#3F51B5");
                }
            })
            .build());

        //添加自定义切换其他登录方式
        mAuthHelper.addAuthRegistViewConfig("switch_msg", new AuthRegisterViewConfig.Builder()
                .setView(initSwitchView(420))
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
                .build());

        mAuthHelper.setAuthUIConfig(config.setScreenOrientation(authPageOrientation).create());
    }
}
