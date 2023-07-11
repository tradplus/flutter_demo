package com.tradplus.flutter.interactive;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.tradplus.ads.common.util.ResourceUtils;
import com.tradplus.flutter.TradPlusSdk;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class TPInterActiveAdView implements PlatformView {

    ViewGroup rootView;

    public TPInterActiveAdView(Context context, BinaryMessenger messenger, Map<String, Object> args) {
        try {

            String adUnitId = (String) args.get("adUnitId");
            String adSceneId = (String) args.get("adSceneId");
            Map<String, Object> customAdInfo = (Map<String, Object>) args.get("customAdInfo");
            Log.i("TPInterActiveAdView", "adUnitId = " + adUnitId + " adSceneId = " + adSceneId);

            if (TextUtils.isEmpty(adUnitId)) {
                Log.i("TPInterActiveAdView", "adUnitId is empty");
                return;
            }

            // create containerView
            ViewGroup viewGroup = new FrameLayout(TradPlusSdk.getInstance().getActivity());
            Log.i("TPInterActiveAdView", "adUnitId1 = " + adUnitId + " adSceneId1 = " + adSceneId);

            boolean isSuccess = TPInteractiveManager.getInstance().renderView(adUnitId, viewGroup, adSceneId, customAdInfo);

            if (isSuccess) {
                Log.v("TradPlusLog", "InterActive render success");
            } else {
                Log.v("TradPlusLog", "InterActive render failed");

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
