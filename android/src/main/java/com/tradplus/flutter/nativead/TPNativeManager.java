package com.tradplus.flutter.nativead;

import android.util.Log;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.bean.TPBaseAd;
import com.tradplus.ads.base.util.SegmentUtils;
import com.tradplus.ads.common.util.LogUtil;
import com.tradplus.ads.mgr.nativead.TPCustomNativeAd;
import com.tradplus.ads.open.DownloadListener;
import com.tradplus.ads.open.LoadAdEveryLayerListener;
import com.tradplus.ads.open.nativead.NativeAdListener;
import com.tradplus.ads.open.nativead.TPNative;
import com.tradplus.ads.open.nativead.TPNativeAdRender;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * TradplusFlutterDemoPlugin
 */
public class TPNativeManager {
    private static TPNativeManager sInstance;

    private TPNativeManager() {
    }

    public synchronized static TPNativeManager getInstance() {
        if (sInstance == null) {
            sInstance = new TPNativeManager();
        }
        return sInstance;
    }

    // 保存广告位对象
    private Map<String, TPNative> mTPNatives = new ConcurrentHashMap<>();

    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        // 第一级的参数，就一个广告位id
        String adUnitId = call.argument("adUnitID");
        // 其他参数都在params的map中
        Map<String, Object> params = call.argument("extraMap");

        if (adUnitId == null || adUnitId.length() <= 0) {
            Log.e("TradPlusLog", "adUnitId is null, please check");
            return;
        }
        TPNative tpNative = getOrCreateNative(adUnitId, params);

        if ("native_load".equals(call.method)) {
            tpNative.loadAd(getMaxWaitTime(params));

        } else if ("native_ready".equals(call.method)) {
            boolean isReady = tpNative.isReady();
            result.success(isReady);
        } else if ("native_entryAdScenario".equals(call.method)) {
            tpNative.entryAdScenario(call.argument("sceneId"));
        } else if ("native_getLoadedCount".equals(call.method)) {
            result.success(tpNative.getLoadedCount());
        } else if ("native_setCustomAdInfo".equals(call.method)) {
            tpNative.setCustomShowData(call.argument("customAdInfo"));

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

    private TPNative getOrCreateNative(String adUnitId, Map<String, Object> params) {
        TPNative tpNative = mTPNatives.get(adUnitId);
        if (tpNative == null) {
            tpNative = new TPNative(TradPlusSdk.getInstance().getActivity(), adUnitId);
            mTPNatives.put(adUnitId, tpNative);
            tpNative.setAdListener(new TPNativeAdListener(adUnitId));
            tpNative.setAllAdLoadListener(new TPNativeAllAdListener(adUnitId));
            tpNative.setDownloadListener(new TPInterstitialDownloadListener(adUnitId));
            Log.v("TradPlus", "createNative adUnitId:" + adUnitId);

            // 只需要设置一次的在这里设置

        }

        if (params != null) {

            HashMap<String, Object> temp = new HashMap<>();
            if (params.containsKey("localParams")) {
                temp = (HashMap<String, Object>) params.get("localParams");
                Log.v("TradPlus", "map params temp = " + temp);
                tpNative.setCustomParams(temp);
            }

            if (params.containsKey("templateWidth") && params.containsKey("templateHeight")) {
                double width = (double) params.get("templateWidth");
                double height = (double) params.get("templateHeight");
                tpNative.setAdSize((int) width, (int) height);
            }


            LogUtil.ownShow("map params = " + params);
            // 同一个广告位每次load参数不一样，在下面设置
            if (params.containsKey("loadCount")) {
                tpNative.setCacheNumber((int) params.get("loadCount"));
                Log.v("TradPlus", "setLoadCount count:" + params.get("loadCount"));
            }
            if (params.containsKey("customMap")) {
                SegmentUtils.initPlacementCustomMap(adUnitId, (Map<String, String>) params.get("customMap"));
            }

            if(params.containsKey("openAutoLoadCallback")) {
                boolean openAutoLoadCallback = (boolean) params.get("openAutoLoadCallback");
                tpNative.setAutoLoadCallback(openAutoLoadCallback);
            }
        }
        return tpNative;
    }

    public boolean renderView(String adUnitId, ViewGroup viewContainer, int layoutId, String adSceneId,Map<String, Object> customAdInfo) {
        TPNative tpNative = mTPNatives.get(adUnitId);
        if (tpNative == null) {
            Log.v("TradPlusLog", "TPNaitve is null");

            return false;
        }

        TPCustomNativeAd nativeAd = tpNative.getNativeAd();
        nativeAd.setCustomShowData(customAdInfo);

        if (nativeAd == null) {
            Log.v("TradPlusLog", "TPCustom Ad is null");
            return false;
        }

        nativeAd.showAd(viewContainer, layoutId, adSceneId);
        if (viewContainer.getChildCount() <= 0) {
            return false;
        }
        return true;
    }

    public boolean renderView(String adUnitId, ViewGroup viewContainer, TPNativeAdRender adRender, String adSceneId,Map<String, Object> customAdInfo) {
        TPNative tpNative = mTPNatives.get(adUnitId);
        if (tpNative == null) {
            // print log
            return false;
        }


        TPCustomNativeAd nativeAd = tpNative.getNativeAd();
        if (nativeAd == null) {
            // print log
            return false;
        }
        nativeAd.setCustomShowData(customAdInfo);
        nativeAd.showAd(viewContainer, adRender, adSceneId);
        return true;
    }

    private class TPInterstitialDownloadListener implements DownloadListener {
        private String mAdUnitId;

        TPInterstitialDownloadListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void onDownloadStart(TPAdInfo tpAdInfo, long l, long l1, String s, String s1) {
            Log.v("TradPlusSdk", "onDownloadStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            paramsMap.put("l", l);
            paramsMap.put("l1", l1);
            paramsMap.put("s", s);
            paramsMap.put("s1", s1);
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_downloadstart", paramsMap);
        }

        @Override
        public void onDownloadUpdate(TPAdInfo tpAdInfo, long l, long l1, String s, String s1, int i) {
            Log.v("TradPlusSdk", "onDownloadUpdate unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            paramsMap.put("l", l);
            paramsMap.put("l1", l1);
            paramsMap.put("s", s);
            paramsMap.put("s1", s1);
            paramsMap.put("p", i);
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_downloadupdate", paramsMap);
        }

        @Override
        public void onDownloadPause(TPAdInfo tpAdInfo, long l, long l1, String s, String s1) {
            Log.v("TradPlusSdk", "onDownloadPause unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            paramsMap.put("l", l);
            paramsMap.put("l1", l1);
            paramsMap.put("s", s);
            paramsMap.put("s1", s1);
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_downloadpause", paramsMap);
        }

        @Override
        public void onDownloadFinish(TPAdInfo tpAdInfo, long l, long l1, String s, String s1) {
            Log.v("TradPlusSdk", "onDownloadFinish unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            paramsMap.put("l", l);
            paramsMap.put("l1", l1);
            paramsMap.put("s", s);
            paramsMap.put("s1", s1);
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_downloadfinish", paramsMap);
        }

        @Override
        public void onDownloadFail(TPAdInfo tpAdInfo, long l, long l1, String s, String s1) {
            Log.v("TradPlusSdk", "onDownloadFail unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            paramsMap.put("l", l);
            paramsMap.put("l1", l1);
            paramsMap.put("s", s);
            paramsMap.put("s1", s1);
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_downloadfail", paramsMap);
        }

        @Override
        public void onInstalled(TPAdInfo tpAdInfo, long l, long l1, String s, String s1) {
            Log.v("TradPlusSdk", "onInstalled unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            paramsMap.put("l", l);
            paramsMap.put("l1", l1);
            paramsMap.put("s", s);
            paramsMap.put("s1", s1);
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_downloadinstall", paramsMap);
        }
    }

    private class TPNativeAllAdListener implements LoadAdEveryLayerListener {
        private String mAdUnitId;

        TPNativeAllAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void onAdAllLoaded(boolean b) {
            Log.v("TradPlusSdk", "onAdAllLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("success", b);
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_allLoaded", paramsMap);
        }

        @Override
        public void oneLayerLoadFailed(TPAdError tpAdError, TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadFailed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_oneLayerLoadedFail", paramsMap);
        }

        @Override
        public void oneLayerLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_oneLayerLoaded", paramsMap);
        }

        @Override
        public void onAdStartLoad(String s) {
            Log.v("TradPlusSdk", "onAdStartLoad unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", s);
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_startLoad", paramsMap);
        }

        @Override
        public void oneLayerLoadStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_oneLayerStartLoad", paramsMap);
        }

        @Override
        public void onBiddingStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onBiddingStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_bidStart", paramsMap);
        }

        @Override
        public void onBiddingEnd(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onBiddingEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_bidEnd", paramsMap);
        }

        @Override
        public void onAdIsLoading(String s) {
            Log.v("TradPlusSdk", "onAdIsLoading unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_isLoading", paramsMap);
        }
    }

    private class TPNativeAdListener extends NativeAdListener {
        private String mAdUnitId;

        TPNativeAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void onAdLoaded(TPAdInfo tpAdInfo, TPBaseAd tpBaseAd) {
            Log.v("TradPlusSdk", "loaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_loaded", paramsMap);
        }

        @Override
        public void onAdClicked(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClicked unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_clicked", paramsMap);
        }

        @Override
        public void onAdClosed(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClosed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_closed", paramsMap);
        }

        @Override
        public void onAdImpression(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdImpression unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_impression", paramsMap);
        }

        @Override
        public void onAdLoadFailed(TPAdError tpAdError) {
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_loadFailed", paramsMap);
        }

        @Override
        public void onAdVideoStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdVideoStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_playStart", paramsMap);
        }

        @Override
        public void onAdVideoEnd(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdVideoEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("native_playEnd", paramsMap);
        }
    }
}
