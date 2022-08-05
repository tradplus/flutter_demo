package com.tradplus.flutter.splash;

import android.content.Context;
import android.graphics.Color;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.tradplus.flutter.TradPlusSdk;
import com.tradplus.flutter.banner.TPBannerManager;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class TPSplashAdView implements PlatformView {

    ViewGroup rootView;

    public TPSplashAdView(Context context, BinaryMessenger messenger, Map<String, Object> args) {
        try {

            String adUnitId = (String) args.get("adUnitId");
            String adSceneId = (String) args.get("adSceneId");
            Map<String, Object> extraMap = (Map<String, Object>) args.get("extraMap");
            Log.i("TPSplashAdView", "adUnitId = " + adUnitId + " adSceneId = " + adSceneId);

            if (TextUtils.isEmpty(adUnitId)) {
                Log.i("TPSplashAdView", "adUnitId is empty");

                return;
            }

            // create containerView
            ViewGroup viewGroup = new FrameLayout(TradPlusSdk.getInstance().getActivity());

            viewGroup.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.MATCH_PARENT));
            Log.i("TPSplashAdView", "adUnitId1 = " + adUnitId + " adSceneId1 = " + adSceneId);
            boolean isSuccess = TPSplashManager.getInstance().renderView(adUnitId, viewGroup, adSceneId);
            if(!isSuccess){
                Log.v("TradPlusLog", "Splash render failed");

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
