package com.sean.rao.ali_auth.common;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.util.LruCache;

import com.nirvana.tools.core.CryptUtil;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @Package: com.aliqin.mytel
 * @ClassName: CacheManage
 * @Description: 类作用描述
 * @Author: liuqi
 * @CreateDate: 2021/5/13 9:55 AM
 * @Version: 1.0
 */
public class CacheManage {
    Context context;
    private LruCache<String, Bitmap> mBitmapLruCache = null;
    private ConcurrentHashMap<String, String> mFilePathCache = null;
    private final static String CACHE_FILE_DIR = "ALSDK_FILE_CACHE";
    private final static String CACHE_COVER_DIR = "ALSDK_COVER_CACHE";

    public CacheManage(Context context) {
        this.context = context;
        final File dir = new File(context.getCacheDir(), CACHE_FILE_DIR);
        if (dir.exists()) {
            mFilePathCache = new ConcurrentHashMap<String, String>();
            File[] listFiles = dir.listFiles();
            if (null != listFiles && listFiles.length > 0) {
                for (File file : listFiles) {
                    String fileName = file.getName();
                    String key = fileName.substring(0, fileName.lastIndexOf("."));
                    mFilePathCache.put(key, file.getAbsolutePath());
                }
            }
        }
    }

    /**
     * 创建缓存文件
     *
     * @param url
     * @param ext 文件后缀
     * @return
     */
    public File createCacheFile(String url, String ext) {
        final File dir = new File(context.getCacheDir(), CACHE_FILE_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        String key = url;
        try {
            key = CryptUtil.md5Hex(url);
        } catch (Exception e) {
            key = url;
        }
        return new File(dir, key + ext);
    }

    /**
     * 获取bitma内存缓存
     *
     * @return
     */
    public LruCache<String, Bitmap> getBitmapLruCache() {
        if (mBitmapLruCache == null) {
            long mTotalSize = Runtime.getRuntime().totalMemory();
            mBitmapLruCache = new LruCache<>((int)(mTotalSize / 5));
        }
        return mBitmapLruCache;
    }

    /**
     * 获取文件缓存
     *
     * @param url
     * @return
     */
    public String getCacheFilePath(String url) {
        String key = url;
        try {
            key = CryptUtil.md5Hex(url);
        } catch (Exception e) {
            key = url;
        }
        if (mFilePathCache == null) {
            return null;
        } else {
            return mFilePathCache.get(key);
        }
    }

    /**
     * 缓存bitmap到内存
     *
     * @param url
     * @param bitmap
     */
    public void cacheBitmap(String url, Bitmap bitmap) {
        String key = url;
        try {
            key = CryptUtil.md5Hex(url);
        } catch (Exception e) {
            key = url;
        }
        checkAndCreateBitmapCache();
        mBitmapLruCache.put(key, bitmap);
        SaveImageDisk(bitmap, key);
    }

    /**
     * 获取内存缓存的bitmap
     *
     * @param url
     * @return
     */
    public Bitmap getBitmap(String url) {
        String key = url;
        try {
            key = CryptUtil.md5Hex(url);
        } catch (Exception e) {
            key = url;
        }
        if (mBitmapLruCache == null) {
            return getBitmapFromDisk(key + ".jpg");
        } else {
            return mBitmapLruCache.get(key);
        }
    }

    /**
     * 检查和创建内存缓存
     */
    public void checkAndCreateBitmapCache() {
        if (mBitmapLruCache == null) {
            long mTotalSize = Runtime.getRuntime().totalMemory();
            mBitmapLruCache = new LruCache<>((int)(mTotalSize / 5));
            final File dir = new File(context.getCacheDir(), CACHE_COVER_DIR);
            if (dir.exists()) {
                File[] listFiles = dir.listFiles();
                if (null != listFiles && listFiles.length > 0) {
                    for (File file : listFiles) {
                        String fileName = file.getName();
                        fileName = fileName.substring(0, fileName.lastIndexOf("."));
                        String key = fileName;
                        mBitmapLruCache.put(key, getBitmapFromDisk(file.getAbsolutePath()));
                    }
                }
            }
        }
    }

    /**
     * 缓存图片到硬盘
     * @param image
     * @param url
     */
    public void SaveImageDisk(Bitmap image, String url) {
        final File dir = new File(context.getCacheDir(), CACHE_COVER_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        String key = url;
        try {
            key = CryptUtil.md5Hex(key);
        } catch (Exception e) {
            key = url;
        }
        File imageDir = new File(dir, key + ".jpg");
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(imageDir);
            image.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.flush();
            fos.close();
        } catch (FileNotFoundException e) {
            Log.e("CacheManage", "SaveImage:e" + e.getMessage());
        } catch (IOException e) {
            Log.e("CacheManage", "SaveImage:e" + e.getMessage());
        }
    }

    /**
     * 从硬盘读取文件
     * @param path
     * @return
     */
    public Bitmap getBitmapFromDisk(String path) {
        Bitmap bitmap = null;
        FileInputStream fis = null;
        File f = new File(path);
        if (!f.exists()) {
            return null;
        }
        try {
            fis = new FileInputStream(path);
            bitmap = BitmapFactory.decodeStream(fis);
        } catch (FileNotFoundException e) {
            Log.e("CacheManage", "getBitmap:e" + e.getMessage());
        }
        return bitmap;
    }
}
