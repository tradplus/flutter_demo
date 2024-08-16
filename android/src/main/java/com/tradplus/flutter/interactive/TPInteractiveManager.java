package com.tradplus.flutter.interactive;

import  android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.bean.TPBaseAd;
import com.tradplus.ads.base.util.SegmentUtils;
import com.tradplus.ads.common.util.LogUtil;
import com.tradplus.ads.mgr.interactive.InterActiveMgr;
import com.tradplus.ads.open.LoadAdEveryLayerListener;
import com.tradplus.ads.open.banner.TPBanner;
import com.tradplus.ads.open.interactive.InterActiveAdListener;
import com.tradplus.ads.open.interactive.TPInterActive;
import com.tradplus.ads.open.nativead.TPNativeAdRender;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;
import com.tradplus.flutter.interactive.TPInteractiveManager;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

public class TPInteractiveManager {
    private static TPInteractiveManager sInstance;

    private TPInteractiveManager() {
    }

    public synchronized static TPInteractiveManager getInstance() {
        if (sInstance == null) {
            sInstance = new TPInteractiveManager();
        }
        return sInstance;
    }

    // 保存广告位对象
    private Map<String, TPInterActive> mTPInterActives = new ConcurrentHashMap<>();

    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        // 第一级的参数，就一个广告位id
        String adUnitId = call.argument("adUnitID");
        // 其他参数都在params的map中
        Map<String, Object> params = call.argument("extraMap");

        if (adUnitId == null || adUnitId.length() <= 0) {
            Log.e("TradPlusLog", "adUnitId is null, please check");
            return;
        }
        TPInterActive tpInterActive = getOrCreateInteractive(adUnitId, params);

        if ("interactive_load".equals(call.method)) {
            tpInterActive.loadAd(getMaxWaitTime(params));
        } else if ("interactive_ready".equals(call.method)) {
            boolean isReady = tpInterActive.isReady();
            result.success(isReady);
        } else if ("interactive_setCustomAdInfo".equals(call.method)) {
            tpInterActive.setCustomShowData(call.argument("customAdInfo"));

        }else {
            Log.e("TradPlusLog", "unknown method");
        }

    }

    private float getMaxWaitTime(Map<String, Object> params){
        try {
            if(params.containsKey("maxWaitTime")) {
                return  new Double((double) params.get("maxWaitTime")).floatValue();
            }
        }catch (Throwable throwable){
            return 0;
        }

        return 0;
    }

    private TPInterActive getOrCreateInteractive(String adUnitId, Map<String, Object> params) {
        TPInterActive tpInterActive = mTPInterActives.get(adUnitId);
        if (tpInterActive == null) {
            tpInterActive = new TPInterActive(TradPlusSdk.getInstance().getActivity(), adUnitId);
            mTPInterActives.put(adUnitId, tpInterActive);
            tpInterActive.setAdListener(new TPInterActiveAdListener(adUnitId));
            tpInterActive.setAllAdLoadListener(new TPInterActiveAllAdListener(adUnitId));
            Log.v("TradPlus", "createInterActive adUnitId:" + adUnitId);
        }

        if (params != null) {

            HashMap<String, Object> temp = new HashMap<>();
            if (params.containsKey("localParams")) {
                temp = (HashMap<String, Object>) params.get("localParams");
                Log.v("TradPlus", "map params temp = " + temp);
                tpInterActive.setCustomParams(temp);
            }


            LogUtil.ownShow("map params = " + params);

            if (params.containsKey("customMap")) {
                SegmentUtils.initPlacementCustomMap(adUnitId, (Map<String, String>) params.get("customMap"));
            }

            if(params.containsKey("openAutoLoadCallback")) {
                boolean openAutoLoadCallback = (boolean) params.get("openAutoLoadCallback");
                tpInterActive.setAutoLoadCallback(openAutoLoadCallback);
            }
        }
        return tpInterActive;
    }

    public boolean renderView(String adUnitId, ViewGroup viewContainer, String adSceneId, Map<String, Object> customAdInfo) {
        TPInterActive tpInterActive = mTPInterActives.get(adUnitId);
        if (tpInterActive == null) {
            Log.v("TradPlusLog", "TPInterActive is null");

            return false;
        }

        if(viewContainer == null){
            Log.v("TradPlusLog", "viewContainer is null");
            return false;
        }

        View interActiveAd = tpInterActive.getInterActiveAd();
        if(interActiveAd == null){
            Log.v("TradPlusLog", "InterActiveAdView is null");
            return false;
        }

        if (interActiveAd.getParent() != null) {
            ((ViewGroup) interActiveAd.getParent()).removeView(interActiveAd);
        }
        viewContainer.addView(interActiveAd);

        tpInterActive.setCustomShowData(customAdInfo);
        tpInterActive.showAd(adSceneId);
        if (viewContainer.getChildCount() <= 0) {
            return false;
        }
        return true;
    }

    private boolean isReady(String adUnitId){
        TPInterActive tpInterActive = mTPInterActives.get(adUnitId);
        if(tpInterActive != null) {
            return tpInterActive.isReady();
        }

        return false;
    }


    private class TPInterActiveAllAdListener implements LoadAdEveryLayerListener {
        private String mAdUnitId;

        TPInterActiveAllAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void onAdAllLoaded(boolean b) {
            Log.v("TradPlusSdk", "onAdAllLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("success", b);
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_allLoaded", paramsMap);
        }

        @Override
        public void oneLayerLoadFailed(TPAdError tpAdError, TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadFailed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_oneLayerLoadedFail", paramsMap);
        }

        @Override
        public void oneLayerLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_oneLayerLoaded", paramsMap);
        }

        @Override
        public void onAdStartLoad(String s) {
            Log.v("TradPlusSdk", "onAdStartLoad unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", s);
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_startLoad", paramsMap);
        }

        @Override
        public void oneLayerLoadStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_oneLayerStartLoad", paramsMap);
        }

        @Override
        public void onBiddingStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onBiddingStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_bidStart", paramsMap);
        }

        @Override
        public void onBiddingEnd(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onBiddingEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_bidEnd", paramsMap);
        }

        @Override
        public void onAdIsLoading(String s) {
            Log.v("TradPlusSdk", "onAdIsLoading unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_isLoading", paramsMap);
        }
    }

    private class TPInterActiveAdListener implements InterActiveAdListener {
        private String mAdUnitId;

        TPInterActiveAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void onAdLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "loaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_loaded", paramsMap);
        }

        @Override
        public void onAdClicked(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClicked unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_clicked", paramsMap);
        }

        @Override
        public void onAdClosed(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClosed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_closed", paramsMap);
        }

        @Override
        public void onAdVideoError(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onAdVideoError unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_playEnd", paramsMap);
        }

        @Override
        public void onAdFailed(TPAdError tpAdError) {
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_onAdFailed", paramsMap);
        }

        @Override
        public void onAdImpression(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdImpression unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_impression", paramsMap);
        }

        @Override
        public void onAdVideoStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdVideoStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_playStart", paramsMap);
        }

        @Override
        public void onAdVideoEnd(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdVideoEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interactive_playEnd", paramsMap);
        }
    }
}

