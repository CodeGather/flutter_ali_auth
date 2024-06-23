package com.sean.rao.ali_auth.common;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Application;
import android.app.Application.ActivityLifecycleCallbacks;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Movie;
import android.graphics.SurfaceTexture;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.AudioManager;
import android.media.MediaMetadataRetriever;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnInfoListener;
import android.media.MediaPlayer.OnPreparedListener;
import android.media.MediaPlayer.OnVideoSizeChangedListener;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.Surface;
import android.view.TextureView;
import android.view.TextureView.SurfaceTextureListener;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.FrameLayout.LayoutParams;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;

import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.LoginAuthActivity;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.model.TokenRet;
import com.sean.rao.ali_auth.common.CacheManage;
import com.sean.rao.ali_auth.common.GifAnimationDrawable;
import com.sean.rao.ali_auth.utils.AppUtils;
import com.sean.rao.ali_auth.utils.UtilTool;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.util.concurrent.ExecutorService;

import io.flutter.plugin.common.EventChannel;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

/**
 * @Package: com.aliqin.mytel
 * @ClassName: NativeBackgroundAdapter
 * @Description: 类作用描述
 * @Author: liuqi
 * @CreateDate: 2021/4/29 4:53 PM
 * @Version: 1.0
 */
public class NativeBackgroundAdapter extends LoginParams{
    private volatile OnGifListener onGifListener;
    private volatile GifAnimationDrawable gifAnimationDrawable;
    private CacheManage mCacheManage;
    private ExecutorService mExecutorService;
    private String key, path;

    public NativeBackgroundAdapter(CacheManage cacheManage, ExecutorService executorService, String key) {
        this.key = key;
        this.path = jsonObject.getString("pageBackgroundPath");
        mCacheManage = cacheManage;
        mExecutorService = executorService;
        mCacheManage.checkAndCreateBitmapCache();

        if ("gifPath".equals(key)) {
            if (null == mCacheManage.getBitmap(path)) {
                getAssetGifFirstFrame(mContext, path);
            }
        }
        
        if ("videoPath".equals(key)) {
            if (null == mCacheManage.getBitmap(path)) {
                mExecutorService.execute(new Runnable() {
                    @Override
                    public void run() {
                        Bitmap bitmap = getAssetVideoCoverBitmap(mContext.getAssets(), path);
                        if(null!=bitmap) {
                            mCacheManage.cacheBitmap(path, bitmap);
                        }
                    }
                });
            }

        }
    }

    /**
     * 加载布局
     *
     * @param frameLayout     容器
     * @param backgroundColor 背景颜色
     */
    public void solveView(final FrameLayout frameLayout, String backgroundColor) {
        if ("imagePath".equals(key)) {
            ImageView imageView = new ImageView(frameLayout.getContext());
            LayoutParams params = new LayoutParams(MATCH_PARENT, MATCH_PARENT);
            imageView.setScaleType(ScaleType.CENTER_CROP);
            imageView.setImageDrawable(toDrawable(path, frameLayout.getContext()));
            frameLayout.addView(imageView, params);
            if (!TextUtils.isEmpty(backgroundColor)) {
                imageView.setBackgroundColor(Color.parseColor(backgroundColor));
            }
        } else if ("gifPath".equals(key)) {
            final ImageView imageView = new ImageView(frameLayout.getContext());
            LayoutParams params = new LayoutParams(MATCH_PARENT, MATCH_PARENT);
            imageView.setScaleType(ScaleType.CENTER_CROP);
            if (!TextUtils.isEmpty(backgroundColor)) {
                imageView.setBackgroundColor(Color.parseColor(backgroundColor));
            }
            frameLayout.addView(imageView, params);
            if (gifAnimationDrawable != null) {
                playGif(imageView, gifAnimationDrawable);
            } else {
                if (!TextUtils.isEmpty(backgroundColor)) {
                    imageView.setBackgroundColor(Color.parseColor(backgroundColor));
                }
                onGifListener = new OnGifListener() {
                    @Override
                    public void onGifDownloaded(final GifAnimationDrawable drawable) {
                        if (drawable != null && null != imageView) {
                            imageView.post(new Runnable() {
                                @Override
                                public void run() {
                                    gifAnimationDrawable = drawable;
                                    playGif(imageView, drawable);
                                }
                            });
                        }
                    }

                    @Override
                    public void onFirstFrame(final Bitmap bitmap) {
                        imageView.post(new Runnable() {
                            @Override
                            public void run() {
                                if (null == gifAnimationDrawable) {
                                    imageView.setImageBitmap(bitmap);
                                }
                            }
                        });

                    }
                };
                if (null != mCacheManage.getBitmap(path)) {
                    imageView.setImageBitmap(mCacheManage.getBitmap(path));
                }
                readGifAsset(frameLayout.getContext(), path);
            }
        } else if ("videoPath".equals(key)) {
            playVideo(frameLayout, path, backgroundColor);
        }

        // 构建关闭按钮
        createImageButton(frameLayout, path);
    }

    /**
     * 获取asset文件夹视频封面
     *
     * @param assetManager
     * @param videoPath
     * @return
     */
    public static Bitmap getAssetVideoCoverBitmap(AssetManager assetManager, String videoPath) {
        Bitmap bitmap = null;
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        try {
            AssetFileDescriptor afd = assetManager.openFd(videoPath);
            retriever.setDataSource(afd.getFileDescriptor(), afd.getStartOffset(), afd.getLength());
            //获得第一帧图片
            bitmap = retriever.getFrameAtTime();
            try {
                retriever.release();
            } catch (RuntimeException ex) {
                ex.printStackTrace();
            }
        } catch (IllegalArgumentException | IOException ex) {
            ex.printStackTrace();
            Log.e("NativeBackgroundAdapter", "getAssetVideoBitmap:" + ex.getMessage());
        }
        return bitmap;
    }

    /**
     * 获取本地gif第一帧
     *
     * @param path
     */
    public void getAssetGifFirstFrame(final Context context, final String path) {
        mExecutorService.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    InputStream inputStream = context.getAssets().open(path);
                    // InputStream inputStream = DownloadFile.getImageToInputStream(path);
                    Movie gif = Movie.decodeStream(inputStream);
                    final Bitmap firstFrame = Bitmap.createBitmap(gif.width(), gif.height(), Bitmap.Config.ARGB_8888);
                    Canvas canvas = new Canvas(firstFrame);
                    gif.draw(canvas, 0, 0);
                    canvas.save();
                    mCacheManage.cacheBitmap(path, firstFrame);
                    OnGifListener gifListener = onGifListener;
                    if (gifListener != null) {
                        gifListener.onFirstFrame(firstFrame);
                    }
                    inputStream.close();
                } catch (IOException e) {
                    Log.e("NativeBackgroundAdapter", "getGifFirstFrame:" + e.getMessage());
                }
            }
        });
    }

    /**
     * 播放视频
     *
     * @param frameLayout
     * @param path            url或者路径
     * @param backgroundColor
     */
    @TargetApi(VERSION_CODES.JELLY_BEAN)
    private void playVideo(final FrameLayout frameLayout, final String path, String backgroundColor) {
        final MediaPlayer[] mediaPlayer = {new MediaPlayer()};
        final TextureView textureView = new TextureView(frameLayout.getContext());
        LayoutParams params = new LayoutParams(MATCH_PARENT, MATCH_PARENT);
        frameLayout.addView(textureView, params);
        if (VERSION.SDK_INT >= VERSION_CODES.JELLY_BEAN) {
            textureView.setBackground(null);
        }
        final ImageView ivCover = new ImageView(frameLayout.getContext());
        LayoutParams paramsIv = new LayoutParams(MATCH_PARENT, MATCH_PARENT);
        ivCover.setScaleType(ScaleType.CENTER_CROP);
        if (null != mCacheManage.getBitmap(path)) {
            ivCover.setImageBitmap(mCacheManage.getBitmap(path));
        } else {
            if (!TextUtils.isEmpty(backgroundColor)) {
                frameLayout.setBackgroundColor(Color.parseColor(backgroundColor));
            }
        }
        frameLayout.addView(ivCover, paramsIv);
        final ActivityLifecycleCallbacks activityLifecycleCallbacks = new ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

            }
            @Override
            public void onActivityStarted(Activity activity) {

            }
            @Override
            public void onActivityResumed(Activity activity) {
                if (activity instanceof LoginAuthActivity) {
                    if (mediaPlayer[0] != null && !mediaPlayer[0].isPlaying()) {
                        mediaPlayer[0].start();
                    }
                }
            }
            @Override
            public void onActivityPaused(Activity activity) {
                if (activity instanceof LoginAuthActivity) {
                    if (mediaPlayer[0] != null && mediaPlayer[0].isPlaying()) {
                        mediaPlayer[0].pause();
                    }
                }
            }
            @Override
            public void onActivityStopped(Activity activity) {
            }
            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

            }
            @Override
            public void onActivityDestroyed(Activity activity) {
                if (activity instanceof LoginAuthActivity) {
                    if (mediaPlayer[0] != null && mediaPlayer[0].isPlaying()) {
                        mediaPlayer[0].stop();
                        mediaPlayer[0].release();
                        mediaPlayer[0] = null;
                    }
                    activity.getApplication().unregisterActivityLifecycleCallbacks(this);
                }
            }
        };
        ((Application)frameLayout.getContext()).registerActivityLifecycleCallbacks(
            activityLifecycleCallbacks);
        mediaPlayer[0].setAudioStreamType(AudioManager.STREAM_MUSIC);
        mediaPlayer[0].setLooping(true);
        mediaPlayer[0].setVolume(0, 0);
        AssetFileDescriptor afd;
        try {
            afd = frameLayout.getContext().getAssets().openFd(path);
            mediaPlayer[0].setDataSource(afd.getFileDescriptor(), afd.getStartOffset(),
                afd.getLength());
        } catch (Exception e) {
            Log.e("NativeBackgroundAdapter", "playVideo===readAssets:" + e.getMessage());
        }

        if (VERSION.SDK_INT >= VERSION_CODES.JELLY_BEAN) {
            mediaPlayer[0].setVideoScalingMode(MediaPlayer.VIDEO_SCALING_MODE_SCALE_TO_FIT_WITH_CROPPING);
        }
        try {
            mediaPlayer[0].setOnPreparedListener(new OnPreparedListener() {
                @Override
                public void onPrepared(MediaPlayer mp) {
                    mediaPlayer[0].setOnInfoListener(new OnInfoListener() {
                        @Override
                        public boolean onInfo(MediaPlayer mp, int what, int extra) {
                            if (what == MediaPlayer.MEDIA_INFO_BUFFERING_END) {

                                return true;
                            } else if (what == MediaPlayer.MEDIA_INFO_VIDEO_RENDERING_START) {
                                ivCover.setVisibility(View.GONE);
                            }
                            return false;
                        }
                    });
                    mediaPlayer[0].start();
                }
            });
            mediaPlayer[0].setOnVideoSizeChangedListener(new OnVideoSizeChangedListener() {
                @Override
                public void onVideoSizeChanged(MediaPlayer mp, int width, int height) {
                    int mVideoHeight = mediaPlayer[0].getVideoHeight();
                    int mVideoWidth = mediaPlayer[0].getVideoWidth();
                    updateTextureViewSizeCenter(textureView, mVideoWidth, mVideoHeight);
                }
            });
            mediaPlayer[0].prepareAsync();
            textureView.setSurfaceTextureListener(new SurfaceTextureListener() {
                @Override
                public void onSurfaceTextureAvailable(@NonNull SurfaceTexture surface, int width,
                                                      int height) {
                    Surface mSurface = new Surface(surface);
                    mediaPlayer[0].setSurface(mSurface);
                }
                @Override
                public void onSurfaceTextureSizeChanged(@NonNull SurfaceTexture surface, int width,
                                                        int height) {

                }
                @Override
                public boolean onSurfaceTextureDestroyed(@NonNull SurfaceTexture surface) {
                    if (mediaPlayer[0] != null && mediaPlayer[0].isPlaying()) {
                        mediaPlayer[0].pause();
                    }
                    return false;
                }
                @Override
                public void onSurfaceTextureUpdated(@NonNull SurfaceTexture surface) {

                }
            });
        } catch (Exception ignored) {

        }
    }

    /**
     * 设置视频适应模式为center_crop
     *
     * @param textureView
     * @param mVideoWidth
     * @param mVideoHeight
     */
    private void updateTextureViewSizeCenter(TextureView textureView, int mVideoWidth, int mVideoHeight) {

        float sx = (float)textureView.getWidth() / (float)mVideoWidth;
        float sy = (float)textureView.getHeight() / (float)mVideoHeight;

        Matrix matrix = new Matrix();
        float maxScale = Math.max(sx, sy);

        //第1步:把视频区移动到View区,使两者中心点重合.
        matrix.preTranslate((textureView.getWidth() - mVideoWidth) / 2, (textureView.getHeight() - mVideoHeight) / 2);

        //第2步:因为默认视频是fitXY的形式显示的,所以首先要缩放还原回来.
        matrix.preScale(mVideoWidth / (float)textureView.getWidth(), mVideoHeight / (float)textureView.getHeight());

        //第3步,等比例放大或缩小,直到视频区的一边超过View一边, 另一边与View的另一边相等. 因为超过的部分超出了View的范围,所以是不会显示的,相当于裁剪了.
        matrix.postScale(maxScale, maxScale, textureView.getWidth() / 2,
            textureView.getHeight() / 2);//后两个参数坐标是以整个View的坐标系以参考的
        textureView.setTransform(matrix);
        textureView.postInvalidate();
    }

    /**
     * 从本地读取gif
     *
     * @param path
     */
    private void readGifAsset(final Context context, final String path) {
        mExecutorService.execute(new Runnable() {
            @Override
            public void run() {
                AssetManager assetManager = context.getAssets();
                try {
                    InputStream inputStream = assetManager.open(
                        path);
                    final GifAnimationDrawable gifAnimationDrawable = new GifAnimationDrawable(inputStream);
                    if (onGifListener != null) {
                        onGifListener.onGifDownloaded(gifAnimationDrawable);
                    }
                } catch (IOException e) {
                    Log.e("NativeBackgroundAdapter", "read gif asset:" + e.getMessage());
                }
            }
        });
    }

    /**
     * 播放gif动画
     *
     * @param imageView
     * @param gifAnimationDrawable
     */
    private void playGif(final ImageView imageView, final GifAnimationDrawable gifAnimationDrawable) {
        Log.e("NativeBackgroundAdapter", "playGif asset");
        final ActivityLifecycleCallbacks activityLifecycleCallbacks = new ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

            }

            @Override
            public void onActivityStarted(Activity activity) {

            }

            @Override
            public void onActivityResumed(Activity activity) {
                if (activity instanceof LoginAuthActivity) {
                    if (gifAnimationDrawable != null && !gifAnimationDrawable.isRunning()) {
                        imageView.postDelayed(new Runnable() {
                            @Override
                            public void run() {
                                gifAnimationDrawable.start();
                            }
                        }, 50);

                    }
                }
            }

            @Override
            public void onActivityPaused(Activity activity) {
                if (activity instanceof LoginAuthActivity) {
                    if (gifAnimationDrawable != null && gifAnimationDrawable.isRunning()) {
                        gifAnimationDrawable.stop();
                    }
                }
            }

            @Override
            public void onActivityStopped(Activity activity) {
            }

            @Override
            public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

            }

            @Override
            public void onActivityDestroyed(Activity activity) {
                if (activity instanceof LoginAuthActivity) {
                    activity.getApplication().unregisterActivityLifecycleCallbacks(this);
                }

            }
        };
        ((Application)imageView.getContext()).registerActivityLifecycleCallbacks(
            activityLifecycleCallbacks);
        imageView.setImageDrawable(gifAnimationDrawable);
        gifAnimationDrawable.start();
    }

    public interface OnGifListener {
        /**
         * gif下载完成监听
         *
         * @param drawable
         */
        void onGifDownloaded(GifAnimationDrawable drawable);

        /**
         * 获取第一帧完成监听
         *
         * @param bitmap
         */
        void onFirstFrame(Bitmap bitmap);
    }

    /**
     * 创建图片按钮
     * @param frameLayout
     * @param path
     * @return
     */
    protected void createImageButton(final FrameLayout frameLayout, final String path){
        JSONObject customRetureBtn = jsonObject.getJSONObject("customReturnBtn");
        if (customRetureBtn != null) {
            try{
                LinearLayout linearLayout = new LinearLayout(frameLayout.getContext());
                /// 是否留出状态栏的高度
                // linearLayout.setFitsSystemWindows(false);
                LayoutParams linearLayoutParams = new LayoutParams(MATCH_PARENT, WRAP_CONTENT);
                ImageButton imageButton = new ImageButton(frameLayout.getContext());
                imageButton.setPadding(0, 0, 0, 0);
                imageButton.setBackgroundColor(Color.TRANSPARENT);
                imageButton.setScaleType(ScaleType.values()[customRetureBtn.getIntValue("imgScaleType")]);
                imageButton.setImageDrawable(UtilTool.getBitmapToBitmapDrawable(frameLayout.getContext(), UtilTool.flutterToPath(customRetureBtn.getString("imgPath"))));
                LayoutParams buttonParams = new LayoutParams(
                        AppUtils.dp2px(frameLayout.getContext(), customRetureBtn.getIntValue("width")),
                        AppUtils.dp2px(frameLayout.getContext(), customRetureBtn.getIntValue("height"))
                );
                buttonParams.setMargins(
                        AppUtils.dp2px(frameLayout.getContext(), customRetureBtn.getIntValue("left")),
                        AppUtils.dp2px(frameLayout.getContext(), customRetureBtn.getIntValue("top")),
                        AppUtils.dp2px(frameLayout.getContext(), customRetureBtn.getIntValue("right")),
                        AppUtils.dp2px(frameLayout.getContext(), customRetureBtn.getIntValue("bottom"))
                );
                imageButton.setOnClickListener(v -> {
                    eventSink.success(UtilTool.resultFormatData("700000", null, null));
                    mAuthHelper.quitLoginPage();
                });

                linearLayout.addView(imageButton, buttonParams);
                frameLayout.addView(linearLayout, linearLayoutParams);
            } catch (IOException e) {
                eventSink.success(UtilTool.resultFormatData("500000", null, e.getMessage()));
            }
        }
    }

    protected static Drawable toDrawable(String imgUrl, Context context) {
        Drawable drawable = null;
        Bitmap bitmap = null;
        InputStream inputStream = null;
        try {
            AssetManager assetManager = context.getAssets();
            inputStream = assetManager.open(imgUrl);
            bitmap = BitmapFactory.decodeStream(inputStream);
            drawable = new BitmapDrawable(context.getResources(), bitmap);
        } catch (Exception var6) {
            var6.printStackTrace();
            if (bitmap != null) {
                bitmap.recycle();
            }
            Log.e("AuthSDK", "e=" + var6.toString());
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return drawable;
    }
}
