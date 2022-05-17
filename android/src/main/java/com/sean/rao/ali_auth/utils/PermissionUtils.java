package com.sean.rao.ali_auth.utils;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import androidx.core.content.PermissionChecker;

import java.util.ArrayList;
import java.util.List;

public class PermissionUtils {
    @TargetApi(Build.VERSION_CODES.M)
    public static void checkAndRequestPermissions(Activity context, int requestCode,
                                                  String... permissions) {
        List<String> deniedPermissions = new ArrayList<>(permissions.length);
        for(String permission:permissions) {
            if(PermissionChecker.checkSelfPermission(context, permission) == PermissionChecker.PERMISSION_DENIED) {
                deniedPermissions.add(permission);
            }
        }
        if(!deniedPermissions.isEmpty()) {
            String[] ps = new String[deniedPermissions.size()];
            ps = deniedPermissions.toArray(ps);
            context.requestPermissions(ps, requestCode);
        }
    }
}
