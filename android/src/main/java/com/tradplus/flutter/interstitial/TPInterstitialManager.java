package com.tradplus.flutter.interstitial;

import android.util.Log;

import androidx.annotation.NonNull;

import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.util.SegmentUtils;
import com.tradplus.ads.common.util.LogUtil;
import com.tradplus.ads.open.DownloadListener;
import com.tradplus.ads.open.LoadAdEveryLayerListener;
import com.tradplus.ads.open.interstitial.InterstitialAdListener;
import com.tradplus.ads.open.interstitial.TPInterstitial;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;
import com.tradplus.ads.base.common.TPTaskManager;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.Result;

/** TradplusFlutterDemoPlugin */
public class TPInterstitialManager {
    private static TPInterstitialManager sInstance;

    private TPInterstitialManager() {
    }

    public synchronized static TPInterstitialManager getInstance() {
        if (sInstance == null) {
            sInstance = new TPInterstitialManager();
        }
        return sInstance;
    }
    // 保存广告位对象
    private Map<String, TPInterstitial> mTPInterstitals = new ConcurrentHashMap<>();

    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        // 第一级的参数，就一个广告位id
        String adUnitId = call.argument("adUnitID");
        // 其他参数都在params的map中
        Map<String, Object> params = call.argument("extraMap");

        if (adUnitId == null || adUnitId.length() <= 0) {
            Log.e("TradPlusLog", "adUnitId is null, please check");
            return;
        }
        TPInterstitial tpInterstitial = getOrCreateInterstitial(adUnitId, params);

        if ("interstitial_load".equals(call.method)) {
            tpInterstitial.loadAd(getMaxWaitTime(params));

        } else if ("interstitial_entryAdScenario".equals(call.method)) {
            tpInterstitial.entryAdScenario(call.argument("sceneId"));

        } else if ("interstitial_ready".equals(call.method)) {
            boolean isReady = tpInterstitial.isReady();
            result.success(isReady);

        } else if ("interstitial_show".equals(call.method)) {
            tpInterstitial.showAd(TradPlusSdk.getInstance().getActivity(), call.argument("sceneId"));

        } else if ("interstitial_setCustomAdInfo".equals(call.method)) {
            tpInterstitial.setCustomShowData(call.argument("customAdInfo"));

        } else {
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

    private TPInterstitial getOrCreateInterstitial(String adUnitId, Map<String, Object> params) {

        TPInterstitial tpInterstitial = mTPInterstitals.get(adUnitId);
        if (tpInterstitial == null) {
            tpInterstitial = new TPInterstitial(TradPlusSdk.getInstance().getActivity(), adUnitId);
            mTPInterstitals.put(adUnitId, tpInterstitial);
            tpInterstitial.setAdListener(new TPInterstitialAdListener(adUnitId));
            tpInterstitial.setAllAdLoadListener(new TPInterstitialAllAdListener(adUnitId));
            tpInterstitial.setDownloadListener(new TPInterstitialDownloadListener(adUnitId));
            Log.v("TradPlus", "createInterstitial adUnitId:" + adUnitId);

            // 只需要设置一次的在这里设置

        }
        LogUtil.ownShow("map params = "+params);
        // 同一个广告位每次load参数不一样，在下面设置

        if(params != null) {
            if ( params.containsKey("localParams")) {
                HashMap<String, Object> temp = new HashMap<>();
                temp = (HashMap<String, Object>) params.get("localParams");
                Log.v("TradPlus","map params temp = "+temp);
                tpInterstitial.setCustomParams(temp);
            }

            if ( params.containsKey("customMap")) {
                SegmentUtils.initPlacementCustomMap(adUnitId, (Map<String, String>) params.get("customMap"));
            }

            if(params.containsKey("openAutoLoadCallback")) {
                boolean openAutoLoadCallback = (boolean) params.get("openAutoLoadCallback");
                tpInterstitial.setAutoLoadCallback(openAutoLoadCallback);
            }
        }


        return tpInterstitial;
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_downloadstart", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_downloadupdate", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_downloadpause", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_downloadfinish", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_downloadfail", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_downloadinstall", paramsMap);
        }
    }
    private class TPInterstitialAllAdListener implements LoadAdEveryLayerListener {
        private String mAdUnitId;
        TPInterstitialAllAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }
        @Override
        public void onAdAllLoaded(boolean b) {
            Log.v("TradPlusSdk", "onAdAllLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("success", b);
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_allLoaded", paramsMap);
        }

        @Override
        public void oneLayerLoadFailed(TPAdError tpAdError, TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadFailed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_oneLayerLoadedFail", paramsMap);
        }

        @Override
        public void oneLayerLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_oneLayerLoaded", paramsMap);
        }

        @Override
        public void onAdStartLoad(String s) {
            Log.v("TradPlusSdk", "onAdStartLoad unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", s);
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_startLoad", paramsMap);
        }

        @Override
        public void oneLayerLoadStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_oneLayerStartLoad", paramsMap);
        }

        @Override
        public void onBiddingStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onBiddingStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_bidStart", paramsMap);
        }

        @Override
        public void onBiddingEnd(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onBiddingEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_bidEnd", paramsMap);
        }

        @Override
        public void onAdIsLoading(String s) {
            Log.v("TradPlusSdk", "onAdIsLoading unitid=" + mAdUnitId + "=======================");
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_isLoading", paramsMap);
                }
            });

        }
    }
    private class TPInterstitialAdListener implements InterstitialAdListener {
        private String mAdUnitId;
        TPInterstitialAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }
        @Override
        public void onAdLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "loaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_loaded", paramsMap);
        }

        @Override
        public void onAdClicked(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClicked unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_clicked", paramsMap);
        }

        @Override
        public void onAdClosed(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClosed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_closed", paramsMap);
        }

        @Override
        public void onAdImpression(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdImpression unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_impression", paramsMap);
        }

        @Override
        public void onAdFailed(TPAdError tpAdError) {
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_loadFailed", paramsMap);
        }

        @Override
        public void onAdVideoError(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onAdVideoError unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_showFailed", paramsMap);
        }

        @Override
        public void onAdVideoStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdVideoStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_playStart", paramsMap);
        }

        @Override
        public void onAdVideoEnd(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdVideoEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("interstitial_playEnd", paramsMap);
        }
    }
}
