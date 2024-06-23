package com.sean.rao.ali_auth.common;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

import static android.os.FileUtils.copy;

/**
 * @ProjectName: android
 * @Package: com.sean.rao.ali_auth.common
 * @ClassName: DownloadFile
 * @Description: java类作用描述
 * @Author: liys
 * @CreateDate: 5/1/22 11:01 AM
 * @UpdateUser: 更新者
 * @UpdateDate: 5/1/22 11:01 AM
 * @UpdateRemark: 更新说明
 * @Version: 1.0
 */
class DownloadFile {
  public static InputStream getImageToInputStream(String path) { //连接远程网址
    InputStream inputStream = null;
    try {
      URL url = new URL(path);
      HttpURLConnection conn=(HttpURLConnection) url.openConnection();
      conn.setConnectTimeout(5000);
      conn.setRequestMethod("GET");
      if (conn.getResponseCode() == 200) {
        inputStream = conn.getInputStream();
      }
    } catch (IOException e) {
      e.fillInStackTrace();
    }

    return inputStream;
  }

  public static Bitmap getImageToBitmap(String path) { //连接远程网址
    Bitmap bitmap = null;
    try {
      URL url = new URL(path);
      HttpURLConnection conn=(HttpURLConnection) url.openConnection();
      conn.setConnectTimeout(5000);
      conn.setRequestMethod("GET");
      if (conn.getResponseCode() == 200) {
        InputStream inputStream = conn.getInputStream();
        final ByteArrayOutputStream dataStream = new ByteArrayOutputStream();
        OutputStream outputStream = new BufferedOutputStream(dataStream, 4 * 1024);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
          copy(inputStream,outputStream);
        }
        outputStream.flush();
        final byte[] data =dataStream.toByteArray();
        bitmap = BitmapFactory.decodeByteArray(data, 0, data.length);
      }
    } catch (IOException e) {
      e.fillInStackTrace();
    }

    return bitmap;
  }
}
