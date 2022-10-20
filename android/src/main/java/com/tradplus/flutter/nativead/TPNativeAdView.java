package com.tradplus.flutter.nativead;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.graphics.Color;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import com.tradplus.ads.open.nativead.TPNativeAdRender;
import com.tradplus.ads.common.util.ResourceUtils;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;


public class TPNativeAdView implements PlatformView {

    ViewGroup rootView;

    public TPNativeAdView(Context context, BinaryMessenger messenger, int viewID, Map<String, Object> args) {
        try {
            String adUnitId = (String) args.get("adUnitId");
            String layoutName = (String) args.get("layoutName");

            String adSceneId = (String) args.get("adSceneId");
            Map<String, Object> customAdInfo = (Map<String, Object>)args.get("customAdInfo");
            Map<String, Object> extraMap = (Map<String, Object>) args.get("extraMap");

            if (TextUtils.isEmpty(adUnitId)) {
                Log.i("TPNativeAdView", "adUnitId is empty");
                return;
            }

            // create containerView
            ViewGroup viewGroup = new FrameLayout(TradPlusSdk.getInstance().getActivity());

            if (!TextUtils.isEmpty(layoutName)) {
                int layoutId = TPUtils.getLayoutIdByName(TradPlusSdk.getInstance().getActivity(), layoutName);
                boolean isSuccess = TPNativeManager.getInstance().renderView(adUnitId, viewGroup, layoutId, adSceneId,customAdInfo);
                if (!isSuccess) {
                    Log.v("TradPlusLog", "Native render failed");

                }
            }

            if (extraMap != null && extraMap.containsKey("parent")) {
                TPNativeAdRender adRender = new TPFlutterAdRender(extraMap);
                boolean isSuccess = TPNativeManager.getInstance().renderView(adUnitId, viewGroup, adRender, adSceneId,customAdInfo);
                if (!isSuccess) {
                    Log.v("TradPlusLog", "Native render failed");

                }
            }

            rootView = viewGroup;
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }
    @Override
    public View getView() {
        return rootView;
    }

    @Override
    public void dispose() {

    }

}
