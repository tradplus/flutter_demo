package com.tradplus.flutter.splash;

import android.util.Log;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.bean.TPBaseAd;
import com.tradplus.ads.base.util.SegmentUtils;
import com.tradplus.ads.common.util.LogUtil;
import com.tradplus.ads.open.DownloadListener;
import com.tradplus.ads.open.LoadAdEveryLayerListener;
import com.tradplus.ads.open.nativead.TPNativeAdRender;
import com.tradplus.ads.open.splash.SplashAdListener;
import com.tradplus.ads.open.splash.TPSplash;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TPSplashManager  {
    private static TPSplashManager sInstance;

    private TPSplashManager() {
    }

    public synchronized static TPSplashManager getInstance() {
        if (sInstance == null) {
            sInstance = new TPSplashManager();
        }
        return sInstance;
    }
    // 保存广告位对象
    private Map<String, TPSplash> mTPSplashs = new ConcurrentHashMap<>();

    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        // 第一级的参数，就一个广告位id
        String adUnitId = call.argument("adUnitID");
        // 其他参数都在params的map中
        Map<String, Object> params = call.argument("extraMap");

        if (adUnitId == null || adUnitId.length() <= 0) {
            Log.e("TradPlusLog", "adUnitId is null, please check");
            return;
        }
        TPSplash tpSplash = getOrCreateSplash(adUnitId, params);

        if ("splash_load".equals(call.method)) {
            tpSplash.loadAd(null);

        }  else if ("splash_ready".equals(call.method)) {
            boolean isReady = tpSplash.isReady();
            result.success(isReady);

        } else if ("splash_show".equals(call.method)) {
            Log.i("TradPlusLog","please create the Widget to show Splash View");

        } else if ("splash_setCustomAdInfo".equals(call.method)) {
            tpSplash.setCustomShowData(call.argument("customAdInfo"));

        }else {
            Log.e("TradPlusLog", "unknown method");
        }

    }

    private TPSplash getOrCreateSplash(String adUnitId, Map<String, Object> params) {
        TPSplash tpSplash = mTPSplashs.get(adUnitId);
        if (tpSplash == null) {
            tpSplash = new TPSplash(TradPlusSdk.getInstance().getActivity(), adUnitId);
            mTPSplashs.put(adUnitId, tpSplash);
            tpSplash.setAdListener(new TPSplashManager.TPSplashAdListener(adUnitId));
            tpSplash.setAllAdLoadListener(new TPSplashManager.TPSplashAllAdListener(adUnitId));
            tpSplash.setDownloadListener(new TPSplashManager.TPSplashDownloadListener(adUnitId));
            Log.v("TradPlus", "createSplash adUnitId:" + adUnitId);

            // 只需要设置一次的在这里设置

        }

        // 同一个广告位每次load参数不一样，在下面设置
        LogUtil.ownShow("map params = "+params);
        if(params != null) {
            if (params.containsKey("localParams")) {
                HashMap<String, Object> temp = new HashMap<>();
                temp = (HashMap<String, Object>) params.get("localParams");
                Log.v("TradPlus","map params temp = "+temp);
                tpSplash.setCustomParams(temp);
            }

            if (params.containsKey("customMap")) {
                SegmentUtils.initPlacementCustomMap(adUnitId, (Map<String, String>) params.get("customMap"));
            }
        }


        return tpSplash;
    }

    public boolean renderView(String adUnitId, ViewGroup viewContainer, String adSceneId, TPNativeAdRender tpNativeAdRender) {
        TPSplash tpSplash = mTPSplashs.get(adUnitId);

        if(tpSplash == null){
            Log.v("TradPlusLog", "TPSplash is null");
            return false;
        }

        if(viewContainer == null){
            Log.v("TradPlusLog", "viewContainer is null");
            return false;
        }

        if(tpNativeAdRender != null) {
            tpSplash.setNativeAdRender(tpNativeAdRender);
        }

        tpSplash.showAd(viewContainer);

        if(viewContainer.getChildCount() <= 0) {
            return false;
        }
        return true;
    }


    private class TPSplashDownloadListener implements DownloadListener {
        private String mAdUnitId;
        TPSplashDownloadListener(String adUnitId) {
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_downloadstart", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_downloadupdate", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_downloadpause", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_downloadfinish", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_downloadfail", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_downloadinstall", paramsMap);
        }
    }
    private class TPSplashAllAdListener implements LoadAdEveryLayerListener {
        private String mAdUnitId;
        TPSplashAllAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }
        @Override
        public void onAdAllLoaded(boolean b) {
            Log.v("TradPlusSdk", "onAdAllLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("success", b);
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_allLoaded", paramsMap);
        }

        @Override
        public void oneLayerLoadFailed(TPAdError tpAdError, TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadFailed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_oneLayerLoadedFail", paramsMap);
        }

        @Override
        public void oneLayerLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_oneLayerLoaded", paramsMap);
        }

        @Override
        public void onAdStartLoad(String s) {
            Log.v("TradPlusSdk", "onAdStartLoad unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", s);
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_startLoad", paramsMap);
        }

        @Override
        public void oneLayerLoadStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_oneLayerStartLoad", paramsMap);
        }

        @Override
        public void onBiddingStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onBiddingStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_bidStart", paramsMap);
        }

        @Override
        public void onBiddingEnd(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onBiddingEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_bidEnd", paramsMap);
        }

        @Override
        public void onAdIsLoading(String s) {
            Log.v("TradPlusSdk", "onAdIsLoading unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_isLoading", paramsMap);
        }
    }
    private class TPSplashAdListener extends SplashAdListener {
        private String mAdUnitId;
        TPSplashAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }
        @Override
        public void onAdLoaded(TPAdInfo tpAdInfo, TPBaseAd tpBaseAd) {
            Log.v("TradPlusSdk", "loaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_loaded", paramsMap);
        }

        @Override
        public void onAdClicked(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClicked unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_clicked", paramsMap);
        }

        @Override
        public void onAdClosed(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClosed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_closed", paramsMap);
        }

        @Override
        public void onAdImpression(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdImpression unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_impression", paramsMap);
        }

        @Override
        public void onAdLoadFailed(TPAdError tpAdError) {
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            TradPlusSdk.getInstance().sendCallBackToFlutter("splash_loadFailed", paramsMap);
        }

    }
}
