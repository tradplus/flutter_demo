package com.tradplus.flutter.reward;

import android.util.Log;

import androidx.annotation.NonNull;

import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.util.SegmentUtils;
import com.tradplus.ads.common.util.LogUtil;
import com.tradplus.ads.open.DownloadListener;
import com.tradplus.ads.open.LoadAdEveryLayerListener;
import com.tradplus.ads.open.RewardAdExListener;
import com.tradplus.ads.open.reward.RewardAdListener;
import com.tradplus.ads.open.reward.TPReward;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;
import com.tradplus.ads.base.common.TPTaskManager;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TPRewardManager {
    private static TPRewardManager sInstance;

    private TPRewardManager() {
    }

    public synchronized static TPRewardManager getInstance() {
        if (sInstance == null) {
            sInstance = new TPRewardManager();
        }
        return sInstance;
    }
    // 保存广告位对象
    private Map<String, TPReward> mTPReward = new ConcurrentHashMap<>();

    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        // 第一级的参数，就一个广告位id
        String adUnitId = call.argument("adUnitID");
        // 其他参数都在params的map中
        Map<String, Object> params = call.argument("extraMap");

        if (adUnitId == null || adUnitId.length() <= 0) {
            Log.e("TradPlusLog", "adUnitId is null, please check");
            return;
        }
        TPReward tpReward = getOrCreateReward(adUnitId, params);

        if ("rewardVideo_load".equals(call.method)) {
            float time = getMaxWaitTime(params);
            Log.e("TradPlusLog", "time = "+time);

            tpReward.loadAd(time);

        } else if ("rewardVideo_entryAdScenario".equals(call.method)) {
            tpReward.entryAdScenario(call.argument("sceneId"));

        } else if ("rewardVideo_ready".equals(call.method)) {
            boolean isReady = tpReward.isReady();
            result.success(isReady);

        } else if ("rewardVideo_show".equals(call.method)) {
            tpReward.showAd(TradPlusSdk.getInstance().getActivity(), call.argument("sceneId"));

        } else if ("rewardVideo_setCustomAdInfo".equals(call.method)) {
            tpReward.setCustomShowData(call.argument("customAdInfo"));

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

    private TPReward getOrCreateReward(String adUnitId, Map<String, Object> params) {

        TPReward tpReward = mTPReward.get(adUnitId);
        if (tpReward == null) {
            tpReward = new TPReward(TradPlusSdk.getInstance().getActivity(), adUnitId);


            mTPReward.put(adUnitId, tpReward);
            tpReward.setAdListener(new TPRewardAdListener(adUnitId));
            tpReward.setAllAdLoadListener(new TPRewardAllAdListener(adUnitId));
            tpReward.setDownloadListener(new TPRewardDownloadListener(adUnitId));
            tpReward.setRewardAdExListener(new TPRewardExdListener(adUnitId));
            Log.v("TradPlus", "createReward adUnitId:" + adUnitId);

            // 只需要设置一次的在这里设置

        }
        LogUtil.ownShow("map params = "+params);
        // 同一个广告位每次load参数不一样，在下面设置
        if(params != null) {
            HashMap<String, Object> temp = new HashMap<>();
            if (params != null && params.containsKey("localParams")) {
                temp = (HashMap<String, Object>) params.get("localParams");
            }
            if (params != null && params.containsKey("customData")) {
                temp.put("custom_data", params.get("customData"));
            }
            if (params != null && params.containsKey("userId")) {
                temp.put("user_id", params.get("userId"));
            }

            if(params.containsKey("openAutoLoadCallback")) {
                boolean openAutoLoadCallback = (boolean) params.get("openAutoLoadCallback");
                tpReward.setAutoLoadCallback(openAutoLoadCallback);
            }


            Log.v("TradPlus","map params temp = "+temp);
            tpReward.setCustomParams(temp);

            if (params.containsKey("customMap")) {
                SegmentUtils.initPlacementCustomMap(adUnitId, (Map<String, String>) params.get("customMap"));
            }
        }

        return tpReward;
    }

    private class TPRewardExdListener implements RewardAdExListener {
        private String mAdUnitId;
        TPRewardExdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }
        @Override
        public void onAdAgainImpression(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdAgainImpression unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_playAgain_impression", paramsMap);
        }

        @Override
        public void onAdAgainVideoStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdAgainVideoStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_playAgain_playStart", paramsMap);
        }

        @Override
        public void onAdAgainVideoEnd(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdAgainVideoEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_playAgain_playEnd", paramsMap);
        }

        @Override
        public void onAdAgainVideoClicked(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdAgainVideoClicked unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_playAgain_clicked", paramsMap);
        }

        @Override
        public void onAdPlayAgainReward(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdPlayAgainReward unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_playAgain_rewarded", paramsMap);
        }
    }
    private class TPRewardDownloadListener implements DownloadListener {
        private String mAdUnitId;
        TPRewardDownloadListener(String adUnitId) {
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_downloadstart", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_downloadupdate", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_downloadpause", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_downloadfinish", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_downloadfail", paramsMap);
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
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_downloadinstall", paramsMap);
        }
    }
    private class TPRewardAllAdListener implements LoadAdEveryLayerListener {
        private String mAdUnitId;
        TPRewardAllAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }
        @Override
        public void onAdAllLoaded(boolean b) {
            Log.v("TradPlusSdk", "onAdAllLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("success", b);
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_allLoaded", paramsMap);
        }

        @Override
        public void oneLayerLoadFailed(TPAdError tpAdError, TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadFailed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_oneLayerLoadedFail", paramsMap);
        }

        @Override
        public void oneLayerLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_oneLayerLoaded", paramsMap);
        }

        @Override
        public void onAdStartLoad(String s) {
            Log.v("TradPlusSdk", "onAdStartLoad unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", s);
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_startLoad", paramsMap);
        }

        @Override
        public void oneLayerLoadStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_oneLayerStartLoad", paramsMap);
        }

        @Override
        public void onBiddingStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onBiddingStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_bidStart", paramsMap);
        }

        @Override
        public void onBiddingEnd(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onBiddingEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_bidEnd", paramsMap);
        }

        @Override
        public void onAdIsLoading(String s) {
            Log.v("TradPlusSdk", "onAdIsLoading unitid=" + mAdUnitId + "=======================");
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_isLoading", paramsMap);
                }
            });
        }
    }
    private class TPRewardAdListener implements RewardAdListener {
        private String mAdUnitId;
        TPRewardAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }
        @Override
        public void onAdLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "loaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_loaded", paramsMap);
        }

        @Override
        public void onAdClicked(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClicked unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_clicked", paramsMap);
        }

        @Override
        public void onAdClosed(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClosed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_closed", paramsMap);
        }

        @Override
        public void onAdReward(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdReward unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_rewarded", paramsMap);
        }

        @Override
        public void onAdImpression(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdImpression unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_impression", paramsMap);
        }

        @Override
        public void onAdFailed(TPAdError tpAdError) {
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_loadFailed", paramsMap);
        }

        @Override
        public void onAdVideoError(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onAdVideoError unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_showFailed", paramsMap);
        }

        @Override
        public void onAdVideoStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdVideoStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_playStart", paramsMap);
        }

        @Override
        public void onAdVideoEnd(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdVideoEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("rewardVideo_playEnd", paramsMap);
        }
    }
}
