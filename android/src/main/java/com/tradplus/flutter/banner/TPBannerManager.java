package com.tradplus.flutter.banner;

import android.util.Log;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.bean.TPBaseAd;
import com.tradplus.ads.base.config.ConfigLoadManager;
import com.tradplus.ads.common.serialization.JSON;
import com.tradplus.ads.common.util.LogUtil;
import com.tradplus.ads.core.AdCacheManager;
import com.tradplus.ads.core.AdMediationManager;
import com.tradplus.ads.mgr.nativead.TPCustomNativeAd;
import com.tradplus.ads.mobileads.util.SegmentUtils;
import com.tradplus.ads.network.response.ConfigResponse;
import com.tradplus.ads.open.DownloadListener;
import com.tradplus.ads.open.LoadAdEveryLayerListener;
import com.tradplus.ads.open.banner.BannerAdListener;
import com.tradplus.ads.open.banner.TPBanner;
import com.tradplus.ads.open.nativead.NativeAdListener;
import com.tradplus.ads.open.nativead.TPNative;
import com.tradplus.ads.open.nativead.TPNativeAdRender;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;
import com.tradplus.flutter.nativead.TPNativeManager;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TPBannerManager {

    private static TPBannerManager sInstance;

    private TPBannerManager() {
    }

    public synchronized static TPBannerManager getInstance() {
        if (sInstance == null) {
            sInstance = new TPBannerManager();
        }
        return sInstance;
    }

    // 保存广告位对象
    private Map<String, TPBanner> mTPBanners = new ConcurrentHashMap<>();

    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        // 第一级的参数，就一个广告位id
        String adUnitId = call.argument("adUnitID");
        // 其他参数都在params的map中
        Map<String, Object> params = call.argument("extraMap");

        if (adUnitId == null || adUnitId.length() <= 0) {
            Log.e("TradPlusLog", "adUnitId is null, please check");
            return;
        }
        TPBanner tpBanner = getOrCreateBanner(adUnitId, params);

        if ("banner_load".equals(call.method)) {
            String sceneId = (String) params.get("sceneId");
            tpBanner.loadAd(adUnitId, sceneId);

        } else if ("banner_entryAdScenario".equals(call.method)) {
            tpBanner.entryAdScenario(call.argument("sceneId"));
        } else if ("banner_ready".equals(call.method)) {
            result.success(isReadyByBanner(adUnitId));
        } else if ("banner_setCustomAdInfo".equals(call.method)) {
            tpBanner.setCustomShowData(call.argument("customAdInfo"));

        }else {
            Log.e("TradPlusLog", "unknown method");
        }

    }

    private TPBanner getOrCreateBanner(String adUnitId, Map<String, Object> params) {
        TPBanner tpBanner = mTPBanners.get(adUnitId);
        if (tpBanner == null) {
            tpBanner = new TPBanner(TradPlusSdk.getInstance().getActivity());
            mTPBanners.put(adUnitId, tpBanner);
            tpBanner.closeAutoShow();
            tpBanner.setAdListener(new TPBannerManager.TPBannerAdListener(adUnitId));
            tpBanner.setAllAdLoadListener(new TPBannerManager.TPBannerAllAdListener(adUnitId));
            tpBanner.setDownloadListener(new TPBannerManager.TPBannerDownloadListener(adUnitId));
            Log.v("TradPlus", "createBanner adUnitId:" + adUnitId);

            // 只需要设置一次的在这里设置

        }

        LogUtil.ownShow("map params = "+params);
        if(params != null) {
            if (params.containsKey("localParams")) {
                HashMap<String, Object> temp = new HashMap<>();
                temp = (HashMap<String, Object>) params.get("localParams");
                Log.v("TradPlus","map params temp = "+temp);
                tpBanner.setCustomParams(temp);
            }

            if (params.containsKey("customMap")) {
                SegmentUtils.initPlacementCustomMap(adUnitId, (Map<String, String>) params.get("customMap"));
            }
        }



        return tpBanner;
    }

    public boolean renderView(String adUnitId, ViewGroup viewContainer, String adSceneId,TPNativeAdRender tpNativeAdRender) {
        TPBanner tpBanner = mTPBanners.get(adUnitId);

        if(tpBanner == null){
            Log.v("TradPlusLog", "TPBanner is null");
            return false;
        }

        if(viewContainer == null){
            Log.v("TradPlusLog", "viewContainer is null");
            return false;
        }

        if (tpBanner.getParent() != null) {
            ((ViewGroup) tpBanner.getParent()).removeView(tpBanner);
        }

        if(tpNativeAdRender != null){
            tpBanner.setNativeAdRender(tpNativeAdRender);
        }

        viewContainer.addView(tpBanner);
        if(isReady(adUnitId)) {
            tpBanner.showAd(adSceneId);
        }

        if (viewContainer.getChildCount() <= 0) {
            return false;
        }
        return true;
    }

    private boolean isReady(String adUnitId){
        return AdCacheManager.getInstance().getReadyAdNum(adUnitId) > 0;
    }

    private boolean isReadyByBanner(String adUnitId){
        boolean isReadyNum = AdCacheManager.getInstance().getReadyAdNum(adUnitId) > 0;
        TPBanner tpBanner = mTPBanners.get(adUnitId);
        boolean isShown = false;

        if(tpBanner == null){
            isShown = false;
        }else{
            if(tpBanner.getChildCount() > 0){
                isShown = true;
            }
        }

        if(isOpenRefresh(adUnitId) && (isShown || isReadyNum) ){
            return true;
        }
        return isReadyNum;
    }

    private boolean isOpenRefresh(String adUnitId){
        long refreshTime = 0;
        ConfigResponse configResponse = ConfigLoadManager.getInstance().getLocalConfigResponse(adUnitId);
        if (configResponse != null) {
            refreshTime = configResponse.getRefreshTime() * 1000;
        }

        if (refreshTime <= 0) {
            return false;
        }

        return true;
    }


    private class TPBannerDownloadListener implements DownloadListener {
        private String mAdUnitId;

        TPBannerDownloadListener(String adUnitId) {
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_downloadstart", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_downloadupdate", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_downloadpause", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_downloadfinish", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_downloadfail", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_downloadinstall", paramsMap);
        }
    }

    private class TPBannerAllAdListener implements LoadAdEveryLayerListener {
        private String mAdUnitId;

        TPBannerAllAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void onAdAllLoaded(boolean b) {
            Log.v("TradPlusSdk", "onAdAllLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("success", b);
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_allLoaded", paramsMap);
        }

        @Override
        public void oneLayerLoadFailed(TPAdError tpAdError, TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadFailed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_oneLayerLoadedFail", paramsMap);
        }

        @Override
        public void oneLayerLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_oneLayerLoaded", paramsMap);
        }

        @Override
        public void onAdStartLoad(String s) {
            Log.v("TradPlusSdk", "onAdStartLoad unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", s);
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_startLoad", paramsMap);
        }

        @Override
        public void oneLayerLoadStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_oneLayerStartLoad", paramsMap);
        }

        @Override
        public void onBiddingStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onBiddingStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_bidStart", paramsMap);
        }

        @Override
        public void onBiddingEnd(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onBiddingEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_bidEnd", paramsMap);
        }
    }

    private class TPBannerAdListener extends BannerAdListener {
        private String mAdUnitId;

        TPBannerAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void onAdLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "loaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_loaded", paramsMap);
        }

        @Override
        public void onAdClicked(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClicked unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_clicked", paramsMap);
        }

        @Override
        public void onAdClosed(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClosed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_closed", paramsMap);
        }

        @Override
        public void onAdImpression(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdImpression unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_impression", paramsMap);
        }

        @Override
        public void onAdLoadFailed(TPAdError tpAdError) {
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            TradPlusSdk.getInstance().sendCallBackToFlutter("banner_loadFailed", paramsMap);
        }


    }
}
