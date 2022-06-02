package com.sean.rao.ali_auth;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.hjq.toast.CustomToast;
import com.hjq.toast.ToastStrategy;
import com.hjq.toast.ToastUtils;
import com.hjq.toast.config.IToast;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.sean.rao.ali_auth.login.OneKeyLoginPublic;

/** AliAuthPlugin */
public class AliAuthPlugin extends FlutterActivity implements FlutterPlugin, ActivityAware, MethodCallHandler, EventChannel.StreamHandler {
  private static final String TAG = "ali_auth 一键登录插件";

  private Context mContext;
  private Activity mActivity;
  /// The MethodChannel that will the communication between Flutter and native Android
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  private FlutterEngine flutterEngine;

  private FlutterEngineCache flutterEngineCache;

  public static EventChannel.EventSink _events;

  private static final String METHOD_CHANNEL = "ali_auth";
  private static final String EVENT_CHANNEL = "ali_auth/event";

  /**
   * 延时登录
   */
  private OneKeyLoginPublic oneKeyLoginPublic;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), METHOD_CHANNEL);

    // 原生通讯
    EventChannel eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), EVENT_CHANNEL);
    eventChannel.setStreamHandler(this);

//    // Activity
//    flutterView.getLookupKeyForAsset("images/ic_launcher.png");
//    // Fragment
//    (FlutterView) getView().getLookupKeyForAsset("images/ic_launcher.png");
//    // 通用
//    FlutterMain.getLookupKeyForAsset("images/ic_launcher.png");

    // 创建flutter发动机
    flutterEngineCache = FlutterEngineCache.getInstance();
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method){
      case "getPlatformVersion":
        result.success("当前Android信息：" + android.os.Build.VERSION.RELEASE);
        break;
      case "initSdk":
        if (_events == null) {
          result.error("500001", "请先对插件进行监听！", null);
        } else {
          boolean isDelay = (boolean) call.argument("isDelay");
          if (oneKeyLoginPublic == null || !isDelay) {
            oneKeyLoginPublic = new OneKeyLoginPublic(mActivity, _events, call.arguments);
          } else {
            oneKeyLoginPublic.getLoginToken(5000);
          }
          result.success("初始化插件成功！");
        }
        break;
      case "login":
        if (oneKeyLoginPublic != null) {
          oneKeyLoginPublic.startLogin((int) call.argument("timeout"));
        } else {
          result.error("500002", "该接口为延时登录接口，请先初始化后再次调用该接口！", null);
        }
        break;
      case "checkEnvAvailable":
        oneKeyLoginPublic.checkEnvAvailable(2);
        break;
      case "quitPage":
        oneKeyLoginPublic.quitPage();
        break;
      case "openPage":
        if (flutterEngine == null) {
          flutterEngine = new FlutterEngine(mContext);
        }
        //指定想要跳转的flutter页面 这里要和下图对应上 记住他
        flutterEngine.getNavigationChannel().setInitialRoute(call.argument("pageRoute"));
        flutterEngine.getDartExecutor().executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault());
        //这里做一个缓存 可以在适当的地方执行他 比如MyApp里 或者未跳转flutterr之前 在flutter页面执行前预加载
        //缓存可以缓存好多个 以不同的的id区分
        flutterEngineCache.put("default_engine_id", flutterEngine);
        //上面的代码一般在执行跳转操作之前调用 这样可以预加载页面 是的跳转的时候速度加快
        //跳转页面
        mActivity.startActivity(FlutterActivity.withCachedEngine("default_engine_id").build(mContext));
        result.success("调用成功！");
        break;
      default:
        result.notImplemented();
    }
  }

  @Override
  public void onListen(Object o, EventChannel.EventSink eventSink) {
    Log.d(TAG, "listen 初始化完毕！");
    String version = PhoneNumberAuthHelper.getVersion();
    eventSink.success(String.format("插件启动监听成功, 当前SDK版本: %s", version));
    if( _events == null ){
      _events = eventSink;
      // init();
      // implementation 'com.github.getActivity:ToastUtils:10.3'
      ToastUtils.init(mActivity.getApplication(), new ToastStrategy() {
        @Override
        public IToast createToast(Application application) {
          IToast toast = super.createToast(application);
          CustomToast customToast = ((CustomToast) toast);
          // 设置 Toast 动画效果
          //customToast.setAnimationsId(R.anim.xxx);
          // 设置短 Toast 的显示时长（默认是 2000 毫秒）
          customToast.setShortDuration(1000);
            // 设置长 Toast 的显示时长（默认是 3500 毫秒）
          customToast.setLongDuration(5000);
          toast.setMargin(toast.getHorizontalMargin(), 10);
          return toast;
        }
      });
    }
  }
  @Override
  public void onCancel(Object o) {
    if( _events != null){
      _events = null;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    mActivity = binding.getActivity();
    mContext = mActivity.getBaseContext();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
