package com.tradplus.flutter.offerwall;

import android.util.Log;

import androidx.annotation.NonNull;

import com.tradplus.ads.base.bean.TPAdError;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.common.TPTaskManager;
import com.tradplus.ads.base.util.SegmentUtils;
import com.tradplus.ads.common.util.LogUtil;
import com.tradplus.ads.open.LoadAdEveryLayerListener;
import com.tradplus.ads.open.offerwall.OffWallBalanceListener;
import com.tradplus.ads.open.offerwall.OfferWallAdListener;
import com.tradplus.ads.open.offerwall.TPOfferWall;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.TradPlusSdk;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TPOfferWallManager {
    private static TPOfferWallManager sInstance;

    private TPOfferWallManager() {
    }

    public synchronized static TPOfferWallManager getInstance() {
        if (sInstance == null) {
            sInstance = new TPOfferWallManager();
        }
        return sInstance;
    }

    // 保存广告位对象
    private Map<String, TPOfferWall> mTPOfferWall = new ConcurrentHashMap<>();

    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        // 第一级的参数，就一个广告位id
        String adUnitId = call.argument("adUnitID");
        // 其他参数都在params的map中
        Map<String, Object> params = call.argument("extraMap");

        if (adUnitId == null || adUnitId.length() <= 0) {
            Log.e("TradPlusLog", "adUnitId is null, please check");
            return;
        }
        TPOfferWall tpOfferWall = getOrCreateOfferWall(adUnitId, params);

        if ("offerwall_load".equals(call.method)) {
            tpOfferWall.loadAd(getMaxWaitTime(params));

        } else if ("offerwall_entryAdScenario".equals(call.method)) {
            tpOfferWall.entryAdScenario(call.argument("sceneId"));

        } else if ("offerwall_ready".equals(call.method)) {
            boolean isReady = tpOfferWall.isReady();
            result.success(isReady);

        } else if ("offerwall_currency".equals(call.method)) {
            tpOfferWall.getCurrencyBalance();

        } else if ("offerwall_spend".equals(call.method)) {
            tpOfferWall.spendCurrency(call.argument("count"));

        } else if ("offerwall_award".equals(call.method)) {
            tpOfferWall.awardCurrency(call.argument("count"));

        } else if ("offerwall_show".equals(call.method)) {
            tpOfferWall.showAd(TradPlusSdk.getInstance().getActivity(), call.argument("sceneId"));

        }else if ("offerwall_setUserId".equals(call.method)) {
            tpOfferWall.setUserId( call.argument("userId"));

        } else if ("offerwall_setCustomAdInfo".equals(call.method)) {
            tpOfferWall.setCustomShowData(call.argument("customAdInfo"));

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

    private TPOfferWall getOrCreateOfferWall(String adUnitId, Map<String, Object> params) {
        TPOfferWall tpOfferWall = mTPOfferWall.get(adUnitId);
        if (tpOfferWall == null) {
            tpOfferWall = new TPOfferWall(TradPlusSdk.getInstance().getActivity(), adUnitId);
            mTPOfferWall.put(adUnitId, tpOfferWall);
            tpOfferWall.setAdListener(new TPOfferWallManager.TPOfferWallAdListener(adUnitId));
            tpOfferWall.setAllAdLoadListener(new TPOfferWallManager.TPOfferWallAllAdListener(adUnitId));
            tpOfferWall.setOffWallBalanceListener(new TPOfferWallBalanceAdListener(adUnitId));
            Log.v("TradPlus", "createOfferWall adUnitId:" + adUnitId);

            // 只需要设置一次的在这里设置

        }
        // 同一个广告位每次load参数不一样，在下面设置
        LogUtil.ownShow("map params = "+params);

        if(params != null) {
            if (params != null && params.containsKey("localParams")) {
                HashMap<String, Object> temp = new HashMap<>();
                temp = (HashMap<String, Object>) params.get("localParams");
                tpOfferWall.setCustomParams(temp);
            }

            if (params.containsKey("customMap")) {
                SegmentUtils.initPlacementCustomMap(adUnitId, (Map<String, String>) params.get("customMap"));
            }

            if(params.containsKey("openAutoLoadCallback")) {
                boolean openAutoLoadCallback = (boolean) params.get("openAutoLoadCallback");
                tpOfferWall.setAutoLoadCallback(openAutoLoadCallback);
            }

        }

        return tpOfferWall;
    }



    private class TPOfferWallBalanceAdListener implements OffWallBalanceListener {
        private String mAdUnitId;

        TPOfferWallBalanceAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void currencyBalanceSuccess(int i, String s) {
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    Log.v("TradPlusSdk", "currencyBalanceSuccess unitid=" + mAdUnitId + "=======================");
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    paramsMap.put("amount", i);
                    paramsMap.put("msg", s);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_currency_success", paramsMap);
                }
            });

        }

        @Override
        public void currencyBalanceFailed(String s) {
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    Log.v("TradPlusSdk", "currencyBalanceFailed unitid=" + mAdUnitId + "=======================");
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    paramsMap.put("msg", s);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_currency_failed", paramsMap);
                }
            });
        }

        @Override
        public void spendCurrencySuccess(int i, String s) {
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {

                    Log.v("TradPlusSdk", "spendCurrencySuccess unitid=" + mAdUnitId + "=======================");
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    paramsMap.put("amount", i);
                    paramsMap.put("msg", s);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_spend_success", paramsMap);
                }
            });
        }

        @Override
        public void spendCurrencyFailed(String s) {
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {

                    Log.v("TradPlusSdk", "spendCurrencyFailed unitid=" + mAdUnitId + "=======================");
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    paramsMap.put("msg", s);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_spend_failed", paramsMap);
                }
            });
        }

        @Override
        public void awardCurrencySuccess(int i, String s) {
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {

                    Log.v("TradPlusSdk", "awardCurrencySuccess unitid=" + mAdUnitId + "=======================");
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    paramsMap.put("amount", i);
                    paramsMap.put("msg", s);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_award_success", paramsMap);
                }
            });
        }

        @Override
        public void awardCurrencyFailed(String s) {
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {

                    Log.v("TradPlusSdk", "awardCurrencyFailed unitid=" + mAdUnitId + "=======================");
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    paramsMap.put("msg", s);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_award_failed", paramsMap);
                }
            });

        }

        @Override
        public void setUserIdSuccess() {
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    Log.v("TradPlusSdk", "setUserIdSuccess unitid=" + mAdUnitId + "=======================");
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    paramsMap.put("success", true);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_setUserIdFinish", paramsMap);
                    Log.i("TradPlusSdk", "setUserIdSuccess: ");
                }
            });

        }

        @Override
        public void setUserIdFailed(String s) {
            TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                @Override
                public void run() {
                    Log.v("TradPlusSdk", "setUserIdFailed unitid=" + mAdUnitId + "=======================");
                    final Map<String, Object> paramsMap = new HashMap<>();
                    paramsMap.put("adUnitID", mAdUnitId);
                    paramsMap.put("success", false);
                    TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_setUserIdFinish", paramsMap);
                    Log.i("TradPlusSdk", "setUserIdSuccess: ");
                    Log.i("TradPlusSdk", "setUserIdFailed: " + s);
                }
            });

        }
    }

    private class TPOfferWallAllAdListener implements LoadAdEveryLayerListener {
        private String mAdUnitId;

        TPOfferWallAllAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void onAdAllLoaded(boolean b) {
            Log.v("TradPlusSdk", "onAdAllLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("success", b);
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_allLoaded", paramsMap);
        }

        @Override
        public void oneLayerLoadFailed(TPAdError tpAdError, TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadFailed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_oneLayerLoadedFail", paramsMap);
        }

        @Override
        public void oneLayerLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_oneLayerLoaded", paramsMap);
        }

        @Override
        public void onAdStartLoad(String s) {
            Log.v("TradPlusSdk", "onAdStartLoad unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", s);
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_startLoad", paramsMap);
        }

        @Override
        public void oneLayerLoadStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "oneLayerLoadStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_oneLayerStartLoad", paramsMap);
        }

        @Override
        public void onBiddingStart(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onBiddingStart unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_bidStart", paramsMap);
        }

        @Override
        public void onBiddingEnd(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onBiddingEnd unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_bidEnd", paramsMap);
        }

        @Override
        public void onAdIsLoading(String s) {
            Log.v("TradPlusSdk", "onAdIsLoading unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_isLoading", paramsMap);
        }
    }

    private class TPOfferWallAdListener implements OfferWallAdListener {
        private String mAdUnitId;

        TPOfferWallAdListener(String adUnitId) {
            mAdUnitId = adUnitId;
        }

        @Override
        public void onAdLoaded(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "loaded unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_loaded", paramsMap);
        }

        @Override
        public void onAdClicked(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClicked unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_clicked", paramsMap);
        }

        @Override
        public void onAdClosed(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdClosed unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_closed", paramsMap);
        }

        @Override
        public void onAdReward(TPAdInfo tpAdInfo) {

        }

        @Override
        public void onAdVideoError(TPAdInfo tpAdInfo, TPAdError tpAdError) {
            Log.v("TradPlusSdk", "onAdVideoError unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_videoerror", paramsMap);
        }

        @Override
        public void onAdImpression(TPAdInfo tpAdInfo) {
            Log.v("TradPlusSdk", "onAdImpression unitid=" + mAdUnitId + "=======================");
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_impression", paramsMap);
        }

        @Override
        public void onAdFailed(TPAdError tpAdError) {
            final Map<String, Object> paramsMap = new HashMap<>();
            paramsMap.put("adUnitID", mAdUnitId);
            paramsMap.put("adError", TPUtils.tpErrorToMap(tpAdError));
            TradPlusSdk.getInstance().sendCallBackToFlutter("offerwall_loadFailed", paramsMap);
        }


    }
}
