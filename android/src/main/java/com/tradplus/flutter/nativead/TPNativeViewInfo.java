package com.tradplus.flutter.nativead;

import android.app.Activity;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.tradplus.flutter.Const;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;

import java.util.Map;

public class TPNativeViewInfo {


    public static boolean addToParentView(final FrameLayout view, final View childView, final Map<String, Object> map, final int gravity) {
        if (view == null || map == null) {
            return false;
        }

        int width = TPUtils.dip2px(childView.getContext(), (double) map.get(Const.WIDTH));
        int height = TPUtils.dip2px(childView.getContext(), (double) map.get(Const.HEIGHT));
        int x = TPUtils.dip2px(childView.getContext(), (double) map.get(Const.X));
        int y = TPUtils.dip2px(childView.getContext(), (double) map.get(Const.Y));
        String bgcolor = (String) map.get(Const.BACKGROUND_COLOR);


        if (childView == null || width < 0 ||  (height < 0 && height != ViewGroup.LayoutParams.WRAP_CONTENT)) {
            Log.e("TradPlusLog", "Native config error ,show error !");
            return false;
        }


        FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(width, height);
        layoutParams.leftMargin = x;
        layoutParams.topMargin = y;
        if (gravity > 0) {
            layoutParams.gravity = gravity;
        } else {
            layoutParams.gravity = 51;
        }


        childView.setLayoutParams(layoutParams);
        try {
            if (!TextUtils.isEmpty(bgcolor)) {
                childView.setBackgroundColor(Color.parseColor(bgcolor));

            } else {
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        view.addView(childView, layoutParams);


        return (boolean) map.get(Const.CUSTOM_CLICK);
    }

}
