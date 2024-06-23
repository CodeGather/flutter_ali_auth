package com.sean.rao.ali_auth.common;

import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.graphics.Shader;
import android.graphics.drawable.Drawable;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class CustomRoundedDrawable extends Drawable {

    private final Bitmap mBitmap;
    private final Paint mPaint;
    private final RectF mRectF;
    private final float mRadius;

    public CustomRoundedDrawable(Bitmap bitmap, float radius) {
        mBitmap = bitmap;
        mRadius = radius;

        BitmapShader shader = new BitmapShader(bitmap, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);
        mPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        mPaint.setShader(shader);

        mRectF = new RectF();
    }

    @Override
    public void draw(@NonNull Canvas canvas) {
        mRectF.set(getBounds());
        // 只对左上角和右上角设置圆角
        float[] radii = {mRadius, 0, 0, mRadius, 0f, 0f, 0f, 0f};
//        canvas.drawRoundRect(mRectF, mRadius, mRadius, mPaint);
//        canvas.drawRoundRect(mRectF, radii, mPaint);
        Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
//        paint.setColor(0xFF0000FF);
        Path path = new Path();
        path.addRoundRect(mRectF, radii, Path.Direction.CW);

        canvas.drawPath(path, paint); // 绘制具有四个不同圆角的矩形
    }

    @Override
    public void setAlpha(int alpha) {
        mPaint.setAlpha(alpha);
    }

    @Override
    public void setColorFilter(@Nullable ColorFilter colorFilter) {
        mPaint.setColorFilter(colorFilter);
    }

    @Override
    public int getOpacity() {
        return mPaint.getAlpha();
    }

    @Override
    public int getIntrinsicWidth() {
        return mBitmap.getWidth();
    }

    @Override
    public int getIntrinsicHeight() {
        return mBitmap.getHeight();
    }
}
