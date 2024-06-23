package com.sean.rao.ali_auth.common;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.drawable.Animatable;
import android.graphics.drawable.Drawable;
import android.os.SystemClock;
import android.util.Log;
import android.view.Gravity;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.BufferUnderflowException;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.util.ArrayList;

public class GifAnimationDrawable extends Drawable implements Runnable, Animatable {
    private static final String TAG = "GifAnimationDrawable";
    private static final int DEFAULT_PAINT_FLAGS = Paint.FILTER_BITMAP_FLAG | Paint.DITHER_FLAG;

    private int mCurFrame = -1;

    private int mLoop = 0;
    private boolean mMutated;
    private GifDecoder decoder;
    private boolean mOneShot;
    private final Rect mDstRect = new Rect();
    private boolean mApplyGravity;
    private Paint mPaint = new Paint(DEFAULT_PAINT_FLAGS);
    private int mGravity = Gravity.FILL;
    private Bitmap mBitmap;

    @Override
    protected void onBoundsChange(@NonNull Rect bounds) {
        super.onBoundsChange(bounds);
        mApplyGravity = true;
    }

    public final Paint getPaint() {
        return mPaint;
    }

    public void setAntiAlias(boolean aa) {
        mPaint.setAntiAlias(aa);
    }

    @Override
    public void setFilterBitmap(boolean filter) {
        mPaint.setFilterBitmap(filter);
    }

    @Override
    public void setDither(boolean dither) {
        mPaint.setDither(dither);
    }

    public void setGravity(int gravity) {
        mGravity = gravity;
        mApplyGravity = true;
    }

    @Override
    public void draw(@NonNull Canvas canvas) {
        if (mBitmap == null) {
            Log.e(TAG, "bmp is invalid");
            return;
        }

        if (mApplyGravity) {
            Gravity.apply(mGravity, decoder.getWidth(), decoder.getHeight(), getBounds(), mDstRect);
            mApplyGravity = false;
        }
        canvas.drawBitmap(mBitmap, null, mDstRect, mPaint);
    }

    @Override
    public boolean setVisible(boolean visible, boolean restart) {
        boolean changed = super.setVisible(visible, restart);
        if (visible) {
            if (changed || restart) {
                setFrame(0, true, false);
            }
        } else {
            unscheduleSelf(this);
        }
        return changed;
    }

    @Override
    public int getOpacity() {
        if (mGravity != Gravity.FILL) {
            return PixelFormat.TRANSLUCENT;
        }

        Bitmap bm = mBitmap;
        return (bm == null || bm.hasAlpha() || mPaint.getAlpha() < 255) ?
            PixelFormat.TRANSLUCENT : PixelFormat.OPAQUE;
    }

    /**
     * @return current loop number, this value is not resets
     */
    public int getLoop() {
        return mLoop;
    }

    /**
     * <p>Starts the animation, looping if necessary. This method has no effect
     * if the animation is running.</p>
     *
     * @see #isRunning()
     * @see #stop()
     */
    @Override
    public void start() {
        if (!isRunning()) {
            run();
        }
    }

    /**
     * <p>Stops the animation. This method has no effect if the animation is
     * not running.</p>
     *
     * @see #isRunning()
     * @see #start()
     */
    @Override
    public void stop() {
        if (isRunning()) {
            unscheduleSelf(this);
        }
    }

    /**
     * <p>Indicates whether the animation is currently running or not.</p>
     *
     * @return true if the animation is running, false otherwise
     */
    @Override
    public boolean isRunning() {
        return mCurFrame > -1;
    }

    /**
     * <p>This method exists for implementation purpose only and should not be
     * called directly. Invoke {@link #start()} instead.</p>
     *
     * @see #start()
     */
    @Override
    public void run() {
        nextFrame(false);
    }

    public void preloadFirstFrame() {
        if (!isRunning()) {
            mBitmap = decoder.getFirstFrame();
        }
    }

    @Override
    public void unscheduleSelf(@NonNull Runnable what) {
        mCurFrame = -1;
        preloadFirstFrame();
        super.unscheduleSelf(what);
    }

    @Override
    public void setAlpha(int alpha) {
        mPaint.setAlpha(alpha);
    }

    @Override
    public void setColorFilter(ColorFilter colorFilter) {
        mPaint.setColorFilter(colorFilter);
    }

    /**
     * @return The number of frames in the animation
     */
    public int getNumberOfFrames() {
        return decoder.getFrameCount();
    }

    /**
     * @return The duration in milliseconds of the frame at the
     * specified index
     */
    public int getDuration(int i) {
        return decoder.getDelay(i);
    }

    /**
     * @return True of the animation will play once, false otherwise
     */
    public boolean isOneShot() {
        return mOneShot;
    }

    /**
     * Sets whether the animation should play once or repeat.
     *
     * @param oneShot Pass true if the animation should only play once
     */
    public void setOneShot(boolean oneShot) {
        mOneShot = oneShot;
    }

    private void nextFrame(boolean unschedule) {
        int next = mCurFrame + 1;
        final int N = decoder.getFrameCount();
        if (next >= N) {
            mLoop++;
            next = 0;
        }
        // assert next == decoder.getFramePointer();
        setFrame(next, unschedule, !mOneShot || next < (N - 1));
    }

    private void setFrame(int frame, boolean unschedule, boolean animate) {
        if (frame >= decoder.getFrameCount()) {
            return;
        }
        mCurFrame = frame;
        //selectDrawable(frame);
        decoder.advance();
        mBitmap = decoder.getNextFrame();
        invalidateSelf();
        if (unschedule) {
            unscheduleSelf(this);
        }
        if (animate) {
            scheduleSelf(this, SystemClock.uptimeMillis() + decoder.getNextDelay());
        }
    }

    @Override
    public int getIntrinsicHeight() {
        return decoder.getHeight();
    }

    @Override
    public int getIntrinsicWidth() {
        return decoder.getWidth();
    }

    @Override
    public Drawable mutate() {
        if (!mMutated && super.mutate() == this) {
            mMutated = true;
        }
        return this;
    }

    public GifAnimationDrawable(InputStream in) {
        decoder = new GifDecoder();
        decoder.read(in, 0);
    }

    public GifAnimationDrawable(String string) throws IOException {
        FileInputStream fis = new FileInputStream(string);
        try {
            decoder = new GifDecoder();
            decoder.read(fis, fis.available());
            decoder.advance();
        } finally {
            fis.close();
        }
    }

    /**
     * Copyright (c) 2013 Xcellent Creations, Inc.
     *
     * Permission is hereby granted, free of charge, to any person obtaining
     * a copy of this software and associated documentation files (the
     * "Software"), to deal in the Software without restriction, including
     * without limitation the rights to use, copy, modify, merge, publish,
     * distribute, sublicense, and/or sell copies of the Software, and to
     * permit persons to whom the Software is furnished to do so, subject to
     * the following conditions:
     *
     * The above copyright notice and this permission notice shall be
     * included in all copies or substantial portions of the Software.
     *
     * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
     * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
     * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
     * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
     * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
     * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
     * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
     */

    /**
     * Reads frame data from a GIF image source and decodes it into individual frames
     * for animation purposes.  Image data can be read from either and InputStream source
     * or a byte[].
     *
     * This class is optimized for running animations with the frames, there
     * are no methods to get individual frame images, only to decode the next frame in the
     * animation sequence.  Instead, it lowers its memory footprint by only housing the minimum
     * data necessary to decode the next frame in the animation sequence.
     *
     * The animation must be manually moved forward using {@link #advance()} before requesting the next
     * frame.  This method must also be called before you request the first frame or an error will
     * occur.
     *
     * Implementation adapted from sample code published in Lyons. (2004). <em>Java for Programmers</em>,
     * republished under the MIT Open Source License
     */
    private static class GifDecoder {
        private static final String TAG = "GifDecoder";

        /**
         * File read status: No errors.
         */
        public static final int STATUS_OK = 0;
        /**
         * File read status: Error decoding file (may be partially decoded)
         */
        public static final int STATUS_FORMAT_ERROR = 1;
        /**
         * File read status: Unable to open source.
         */
        public static final int STATUS_OPEN_ERROR = 2;
        /**
         * max decoder pixel stack size
         */
        protected static final int MAX_STACK_SIZE = 4096;

        /**
         * GIF Disposal Method meaning take no action
         */
        private static final int DISPOSAL_UNSPECIFIED = 0;
        /**
         * GIF Disposal Method meaning leave canvas from previous frame
         */
        private static final int DISPOSAL_NONE = 1;
        /**
         * GIF Disposal Method meaning clear canvas to background color
         */
        private static final int DISPOSAL_BACKGROUND = 2;
        /**
         * GIF Disposal Method meaning clear canvas to frame before last
         */
        private static final int DISPOSAL_PREVIOUS = 3;
        private static final int MIN_DELAY = 60; // 60 milliseconds

        /**
         * Global status code of GIF data parsing
         */
        protected int status;

        public int getWidth() {
            return width;
        }

        public int getHeight() {
            return height;
        }

        //Global File Header values and parsing flags
        protected int width; // full image width
        protected int height; // full image height
        protected boolean gctFlag; // global color table used
        protected int gctSize; // size of global color table
        protected int loopCount = 1; // iterations; 0 = repeat forever
        protected int[] gct; // global color table
        protected int[] act; // active color table
        protected int bgIndex; // background color index
        protected int bgColor; // background color
        protected int pixelAspect; // pixel aspect ratio
        protected boolean lctFlag; // local color table flag
        protected int lctSize; // local color table size

        // Raw GIF data from input source
        protected ByteBuffer rawData;

        // Raw data read working array
        protected byte[] block = new byte[256]; // current data block
        protected int blockSize = 0; // block size last graphic control extension info

        // LZW decoder working arrays
        protected short[] prefix;
        protected byte[] suffix;
        protected byte[] pixelStack;
        protected byte[] mainPixels;
        protected int[] mainScratch, copyScratch;

        protected ArrayList<GifFrame> frames; // frames read from current file
        protected GifFrame currentFrame;
        protected Bitmap previousImage, currentImage;

        public int getFramePointer() {
            return framePointer;
        }

        protected int framePointer;
        protected int frameCount;

        public void reset() {
            framePointer = -1;
        }

        /**
         * Inner model class housing metadata for each frame
         */
        private static class GifFrame {
            public int ix, iy, iw, ih;
            /* Control Flags */
            public boolean interlace;
            public boolean transparency;
            /* Disposal Method */
            public int dispose;
            /* Transparency Index */
            public int transIndex;
            /* Delay, in ms, to next frame */
            public int delay;
            /* Index in the raw buffer where we need to start reading to decode */
            public int bufferFrameStart;
            /* Local Color Table */
            public int[] lct;
        }

        /**
         * Move the animation frame counter forward
         */
        public void advance() {
            framePointer = (framePointer + 1) % frameCount;
        }

        /**
         * Gets display duration for specified frame.
         *
         * @param n int index of frame
         * @return delay in milliseconds
         */
        public int getDelay(int n) {
            int delay = -1;
            if ((n >= 0) && (n < frameCount)) {
                delay = frames.get(n).delay;
            }
            return delay;
        }

        /**
         * Gets display duration for the upcoming frame
         */
        public int getNextDelay() {
            if (frameCount <= 0 || framePointer < 0) {
                return -1;
            }

            return getDelay(framePointer);
        }

        /**
         * Gets the number of frames read from file.
         *
         * @return frame count
         */
        public int getFrameCount() {
            return frameCount;
        }

        /**
         * Gets the current index of the animation frame, or -1 if animation hasn't not yet started
         *
         * @return frame index
         */
        public int getCurrentFrameIndex() {
            return framePointer;
        }

        /**
         * Gets the "Netscape" iteration count, if any. A count of 0 means repeat indefinitiely.
         *
         * @return iteration count if one was specified, else 1.
         */
        public int getLoopCount() {
            return loopCount;
        }

        /**
         *
         */
        public Bitmap getFirstFrame() {
            if (frameCount <= 0) {
                return null;
            }
            framePointer = 0;
            Bitmap ret = getNextFrame();
            framePointer = -1;
            return ret;
        }

        /**
         * Get the next frame in the animation sequence.
         *
         * @return Bitmap representation of frame
         */
        public Bitmap getNextFrame() {
            if (frameCount <= 0 || framePointer < 0 || currentImage == null) {
                return null;
            }

            GifFrame frame = frames.get(framePointer);

            //Set the appropriate color table
            if (frame.lct == null) {
                act = gct;
            } else {
                act = frame.lct;
                if (bgIndex == frame.transIndex) {
                    bgColor = 0;
                }
            }

            int save = 0;
            if (frame.transparency) {
                save = act[frame.transIndex];
                act[frame.transIndex] = 0; // set transparent color if specified
            }
            if (act == null) {
                Log.w(TAG, "No Valid Color Table");
                status = STATUS_FORMAT_ERROR; // no color table defined
                return null;
            }

            setPixels(framePointer); // transfer pixel data to image

            // Reset the transparent pixel in the color table
            if (frame.transparency) {
                act[frame.transIndex] = save;
            }

            return currentImage;
        }

        /**
         * Reads GIF image from stream
         *
         * @param is containing GIF file.
         * @return read status code (0 = no errors)
         */
        public int read(InputStream is, int contentLength) {
            if (is != null) {
                Log.v(TAG, "read start");
                try {
                    int capacity = (contentLength > 0) ? (contentLength + 4096) : 4096;
                    ByteArrayOutputStream buffer = new ByteArrayOutputStream(capacity);
                    int nRead;
                    byte[] data = new byte[16384];
                    while ((nRead = is.read(data, 0, data.length)) != -1) {
                        buffer.write(data, 0, nRead);
                    }
                    buffer.flush();

                    Log.v(TAG, "buffer ready");
                    read(buffer.toByteArray());
                } catch (IOException e) {
                    Log.w(TAG, "Error reading data from stream", e);
                } finally {
                    try {
                        is.close();
                    } catch (Exception e) {
                        Log.w(TAG, "Error closing stream", e);
                    }
                }
            } else {
                status = STATUS_OPEN_ERROR;
            }
            Log.v(TAG, "read2 finished");
            return status;
        }

        /**
         * Reads GIF image from byte array
         *
         * @param data containing GIF file.
         * @return read status code (0 = no errors)
         */
        public int read(byte[] data) {
            init();
            if (data != null) {
                //Initiliaze the raw data buffer
                rawData = ByteBuffer.wrap(data);
                rawData.rewind();
                rawData.order(ByteOrder.LITTLE_ENDIAN);
                Log.v(TAG, "read Header start");
                readHeader();
                if (!err()) {
                    Log.v(TAG, "read Contents start");
                    readContents();
                    if (frameCount < 0) {
                        status = STATUS_FORMAT_ERROR;
                    }
                }
            } else {
                status = STATUS_OPEN_ERROR;
            }
            Log.v(TAG, "read finished");

            return status;
        }

        /**
         * Creates new frame image from current data (and previous frames as specified by their disposition codes).
         */
        protected void setPixels(int frameIndex) {
            GifFrame currentFrame = frames.get(frameIndex);
            GifFrame previousFrame = null;
            int previousIndex = frameIndex - 1;
            if (previousIndex >= 0) {
                previousFrame = frames.get(previousIndex);
            }

            // final location of blended pixels
            final int[] dest = mainScratch;

            // fill in starting image contents based on last image's dispose code
            if (previousFrame != null && previousFrame.dispose > DISPOSAL_UNSPECIFIED) {
                if (previousFrame.dispose == DISPOSAL_NONE && currentImage != null) {
                    // Start with the current image
                    currentImage.getPixels(dest, 0, width, 0, 0, width, height);
                }
                if (previousFrame.dispose == DISPOSAL_BACKGROUND) {
                    // Start with a canvas filled with the background color
                    int c = 0;
                    if (!currentFrame.transparency) {
                        c = bgColor;
                    }
                    for (int i = 0; i < previousFrame.ih; i++) {
                        int n1 = (previousFrame.iy + i) * width + previousFrame.ix;
                        int n2 = n1 + previousFrame.iw;
                        for (int k = n1; k < n2; k++) {
                            dest[k] = c;
                        }
                    }
                }
                if (previousFrame.dispose == DISPOSAL_PREVIOUS && previousImage != null) {
                    // Start with the previous frame
                    previousImage.getPixels(dest, 0, width, 0, 0, width, height);
                }
            }

            //Decode pixels for this frame  into the global pixels[] scratch
            decodeBitmapData(currentFrame, mainPixels); // decode pixel data

            // copy each source line to the appropriate place in the destination
            int pass = 1;
            int inc = 8;
            int iline = 0;
            for (int i = 0; i < currentFrame.ih; i++) {
                int line = i;
                if (currentFrame.interlace) {
                    if (iline >= currentFrame.ih) {
                        pass++;
                        switch (pass) {
                            case 2:
                                iline = 4;
                                break;
                            case 3:
                                iline = 2;
                                inc = 4;
                                break;
                            case 4:
                                iline = 1;
                                inc = 2;
                                break;
                            default:
                                break;
                        }
                    }
                    line = iline;
                    iline += inc;
                }
                line += currentFrame.iy;
                if (line < height) {
                    int k = line * width;
                    int dx = k + currentFrame.ix; // start of line in dest
                    int dlim = dx + currentFrame.iw; // end of dest line
                    if ((k + width) < dlim) {
                        dlim = k + width; // past dest edge
                    }
                    int sx = i * currentFrame.iw; // start of line in source
                    while (dx < dlim) {
                        // map color and insert in destination
                        int index = ((int)mainPixels[sx++]) & 0xff;
                        int c = act[index];
                        if (c != 0) {
                            dest[dx] = c;
                        }
                        dx++;
                    }
                }
            }

            //Copy pixels into previous image
            currentImage.getPixels(copyScratch, 0, width, 0, 0, width, height);
            previousImage.setPixels(copyScratch, 0, width, 0, 0, width, height);
            //Set pixels for current image
            currentImage.setPixels(dest, 0, width, 0, 0, width, height);
        }

        /**
         * Decodes LZW image data into pixel array. Adapted from John Cristy's BitmapMagick.
         */
        protected void decodeBitmapData(GifFrame frame, byte[] dstPixels) {
            if (frame != null) {
                //Jump to the frame start position
                rawData.position(frame.bufferFrameStart);
            }

            int nullCode = -1;
            int npix = (frame == null) ? width * height : frame.iw * frame.ih;
            int available, clear, code_mask, code_size, end_of_information, in_code, old_code, bits, code, count, i,
                datum, data_size, first, top, bi, pi;

            if (dstPixels == null || dstPixels.length < npix) {
                dstPixels = new byte[npix]; // allocate new pixel array
            }
            if (prefix == null) {
                prefix = new short[MAX_STACK_SIZE];
            }
            if (suffix == null) {
                suffix = new byte[MAX_STACK_SIZE];
            }
            if (pixelStack == null) {
                pixelStack = new byte[MAX_STACK_SIZE + 1];
            }

            // Initialize GIF data stream decoder.
            data_size = read();
            clear = 1 << data_size;
            end_of_information = clear + 1;
            available = clear + 2;
            old_code = nullCode;
            code_size = data_size + 1;
            code_mask = (1 << code_size) - 1;
            for (code = 0; code < clear; code++) {
                prefix[code] = 0; // XXX ArrayIndexOutOfBoundsException
                suffix[code] = (byte)code;
            }

            // Decode GIF pixel stream.
            datum = bits = count = first = top = pi = bi = 0;
            for (i = 0; i < npix; ) {
                if (top == 0) {
                    if (bits < code_size) {
                        // Load bytes until there are enough bits for a code.
                        if (count == 0) {
                            // Read a new data block.
                            count = readBlock();
                            if (count <= 0) {
                                break;
                            }
                            bi = 0;
                        }
                        datum += (((int)block[bi]) & 0xff) << bits;
                        bits += 8;
                        bi++;
                        count--;
                        continue;
                    }
                    // Get the next code.
                    code = datum & code_mask;
                    datum >>= code_size;
                    bits -= code_size;
                    // Interpret the code
                    if ((code > available) || (code == end_of_information)) {
                        break;
                    }
                    if (code == clear) {
                        // Reset decoder.
                        code_size = data_size + 1;
                        code_mask = (1 << code_size) - 1;
                        available = clear + 2;
                        old_code = nullCode;
                        continue;
                    }
                    if (old_code == nullCode) {
                        pixelStack[top++] = suffix[code];
                        old_code = code;
                        first = code;
                        continue;
                    }
                    in_code = code;
                    if (code == available) {
                        pixelStack[top++] = (byte)first;
                        code = old_code;
                    }
                    while (code > clear) {
                        pixelStack[top++] = suffix[code];
                        code = prefix[code];
                    }
                    first = ((int)suffix[code]) & 0xff;
                    // Add a new string to the string table,
                    if (available >= MAX_STACK_SIZE) {
                        break;
                    }
                    pixelStack[top++] = (byte)first;
                    prefix[available] = (short)old_code;
                    suffix[available] = (byte)first;
                    available++;
                    if (((available & code_mask) == 0) && (available < MAX_STACK_SIZE)) {
                        code_size++;
                        code_mask += available;
                    }
                    old_code = in_code;
                }
                // Pop a pixel off the pixel stack.
                top--;
                dstPixels[pi++] = pixelStack[top];
                i++;
            }

            for (i = pi; i < npix; i++) {
                dstPixels[i] = 0; // clear missing pixels
            }
        }

        /**
         * Returns true if an error was encountered during reading/decoding
         */
        protected boolean err() {
            return status != STATUS_OK;
        }

        /**
         * Initializes or re-initializes reader
         */
        protected void init() {
            status = STATUS_OK;
            frameCount = 0;
            frames = new ArrayList<GifFrame>();
            reset();
            gct = null;
        }

        /**
         * Reads a single byte from the input stream.
         */
        protected int read() {
            int curByte = 0;
            try {
                curByte = (rawData.get() & 0xFF);
            } catch (Exception e) {
                status = STATUS_FORMAT_ERROR;
            }
            return curByte;
        }

        /**
         * Reads next variable length block from input.
         *
         * @return number of bytes stored in "buffer"
         */
        protected int readBlock() {
            blockSize = read();
            int n = 0;
            if (blockSize > 0) {
                try {
                    int count;
                    while (n < blockSize) {
                        count = blockSize - n;
                        rawData.get(block, n, count);

                        n += count;
                    }
                } catch (Exception e) {
                    Log.w(TAG, "Error Reading Block", e);
                    status = STATUS_FORMAT_ERROR;
                }
            }
            return n;
        }

        /**
         * Reads color table as 256 RGB integer values
         *
         * @param ncolors int number of colors to read
         * @return int array containing 256 colors (packed ARGB with full alpha)
         */
        protected int[] readColorTable(int ncolors) {
            int nbytes = 3 * ncolors;
            int[] tab = null;
            byte[] c = new byte[nbytes];

            try {
                rawData.get(c);

                tab = new int[256]; // max size to avoid bounds checks
                int i = 0;
                int j = 0;
                while (i < ncolors) {
                    int r = ((int)c[j++]) & 0xff;
                    int g = ((int)c[j++]) & 0xff;
                    int b = ((int)c[j++]) & 0xff;
                    tab[i++] = 0xff000000 | (r << 16) | (g << 8) | b;
                }
            } catch (BufferUnderflowException e) {
                Log.w(TAG, "Format Error Reading Color Table", e);
                status = STATUS_FORMAT_ERROR;
            }

            return tab;
        }

        /**
         * Main file parser. Reads GIF content blocks.
         */
        protected void readContents() {
            // read GIF file content blocks
            boolean done = false;
            while (!(done || err())) {
                int code = read();
                switch (code) {
                    case 0x2C: // image separator
                        readBitmap();
                        break;
                    case 0x21: // extension
                        code = read();
                        switch (code) {
                            case 0xf9: // graphics control extension
                                //Start a new frame
                                currentFrame = new GifFrame();
                                readGraphicControlExt();
                                break;
                            case 0xff: // application extension
                                readBlock();
                                String app = "";
                                for (int i = 0; i < 11; i++) {
                                    app += (char)block[i];
                                }
                                if (("NETSCAPE2.0").equals(app)) {
                                    readNetscapeExt();
                                } else {
                                    skip(); // don't care
                                }
                                break;
                            case 0xfe:// comment extension
                                skip();
                                break;
                            case 0x01:// plain text extension
                                skip();
                                break;
                            default: // uninteresting extension
                                skip();
                        }
                        break;
                    case 0x3b: // terminator
                        done = true;
                        break;
                    case 0x00: // bad byte, but keep going and see what happens break;
                    default:
                        status = STATUS_FORMAT_ERROR;
                }
            }
        }

        /**
         * Reads GIF file header information.
         */
        protected void readHeader() {
            String id = "";
            for (int i = 0; i < 6; i++) {
                id += (char)read();
            }
            if (!id.startsWith("GIF")) {
                status = STATUS_FORMAT_ERROR;
                return;
            }
            readLSD();
            if (gctFlag && !err()) {
                gct = readColorTable(gctSize);
                bgColor = gct[bgIndex];
            }
        }

        /**
         * Reads Graphics Control Extension values
         */
        protected void readGraphicControlExt() {
            read(); // block size
            int packed = read(); // packed fields
            currentFrame.dispose = (packed & 0x1c) >> 2; // disposal method
            if (currentFrame.dispose == 0) {
                currentFrame.dispose = 1; // elect to keep old image if discretionary
            }
            currentFrame.transparency = (packed & 1) != 0;
            currentFrame.delay = Math.max(MIN_DELAY, readShort() * 10); // delay in milliseconds
            currentFrame.transIndex = read(); // transparent color index
            read(); // block terminator
        }

        /**
         * Reads next frame image
         */
        protected void readBitmap() {
            currentFrame.ix = readShort(); // (sub)image position & size
            currentFrame.iy = readShort();
            currentFrame.iw = readShort();
            currentFrame.ih = readShort();

            int packed = read();
            lctFlag = (packed & 0x80) != 0; // 1 - local color table flag interlace
            lctSize = (int) Math.pow(2, (packed & 0x07) + 1);
            // 3 - sort flag
            // 4-5 - reserved lctSize = 2 << (packed & 7); // 6-8 - local color
            // table size
            currentFrame.interlace = (packed & 0x40) != 0;
            if (lctFlag) {
                currentFrame.lct = readColorTable(lctSize); // read table
            } else {
                currentFrame.lct = null; //No local color table
            }

            currentFrame.bufferFrameStart = rawData.position(); //Save this as the decoding position pointer

            decodeBitmapData(null, mainPixels); // false decode pixel data to advance buffer
            skip();
            if (err()) {
                return;
            }

            frameCount++;
            frames.add(currentFrame); // add image to frame
        }

        /**
         * Reads Logical Screen Descriptor
         */
        protected void readLSD() {
            // logical screen size
            width = readShort();
            height = readShort();
            // packed fields
            int packed = read();
            gctFlag = (packed & 0x80) != 0; // 1 : global color table flag
            // 2-4 : color resolution
            // 5 : gct sort flag
            gctSize = 2 << (packed & 7); // 6-8 : gct size
            bgIndex = read(); // background color index
            pixelAspect = read(); // pixel aspect ratio

            //Now that we know the size, init scratch arrays
            mainPixels = new byte[width * height];
            mainScratch = new int[width * height];
            copyScratch = new int[width * height];

            previousImage = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
            currentImage = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
        }

        /**
         * Reads Netscape extenstion to obtain iteration count
         */
        protected void readNetscapeExt() {
            do {
                readBlock();
                if (block[0] == 1) {
                    // loop count sub-block
                    int b1 = ((int)block[1]) & 0xff;
                    int b2 = ((int)block[2]) & 0xff;
                    loopCount = (b2 << 8) | b1;
                }
            } while ((blockSize > 0) && !err());
        }

        /**
         * Reads next 16-bit value, LSB first
         */
        protected int readShort() {
            // read 16-bit value
            return rawData.getShort();
        }

        /**
         * Skips variable length blocks up to and including next zero length block.
         */
        protected void skip() {
            do {
                readBlock();
            } while ((blockSize > 0) && !err());
        }
    }
}
