package com.tradplus.flutter;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.tradplus.ads.base.TPPlatform;
import com.tradplus.ads.base.bean.TPAdInfo;
import com.tradplus.ads.base.common.TPPrivacyManager;
import com.tradplus.ads.base.common.TPTaskManager;
import com.tradplus.ads.base.util.SegmentUtils;
import com.tradplus.ads.core.GlobalImpressionManager;
import com.tradplus.flutter.banner.TPBannerManager;
import com.tradplus.flutter.banner.TPBannerViewFactory;
import com.tradplus.flutter.interstitial.TPInterstitialManager;
import com.tradplus.flutter.nativead.TPNativeManager;
import com.tradplus.flutter.nativead.TPNativeViewFactory;
import com.tradplus.flutter.offerwall.TPOfferWallManager;
import com.tradplus.flutter.reward.TPRewardManager;
import com.tradplus.flutter.splash.TPSplashManager;
import com.tradplus.flutter.splash.TPSplashViewFactory;
import com.tradplus.flutter.interactive.TPInteractiveManager;
import com.tradplus.flutter.interactive.TPInterActiveViewFactory;
import com.tradplus.meditaiton.utils.ImportSDKUtil;
import com.tradplus.flutter.TPUtils;
import com.tradplus.flutter.UID2Manager;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * TradplusFlutterDemoPlugin
 */
public class TradPlusSdk {
    private static TradPlusSdk sInstance;

    private TradPlusSdk() {
    }

    public synchronized static TradPlusSdk getInstance() {
        if (sInstance == null) {
            sInstance = new TradPlusSdk();
        }
        return sInstance;
    }

    private MethodChannel channel;

    public void initPlugin(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "tradplus_sdk");
        channel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
                try {
                    if (call.method.startsWith("native_")) {
                        TPNativeManager.getInstance().onMethodCall(call, result);
                    } else if (call.method.startsWith("interstitial_")) {
                        TPInterstitialManager.getInstance().onMethodCall(call, result);
                    } else if (call.method.startsWith("rewardVideo_")) {
                        TPRewardManager.getInstance().onMethodCall(call, result);
                    } else if (call.method.startsWith("offerwall_")) {
                        TPOfferWallManager.getInstance().onMethodCall(call, result);
                    } else if (call.method.startsWith("banner_")) {
                        TPBannerManager.getInstance().onMethodCall(call, result);
                    } else if (call.method.startsWith("splash_")) {
                        TPSplashManager.getInstance().onMethodCall(call, result);
                    } else if (call.method.startsWith("interactive_")) {
                        TPInteractiveManager.getInstance().onMethodCall(call, result);
                    } else if (call.method.equals("tp_version")) {
                        result.success(getSdkVersion());
                    } else if (call.method.equals("tp_init")) {
                        initMethonCall(call, result);
                    } else if (call.method.equals("tp_checkCurrentArea")) {
                        currentAreaMethonCall(call, result);
                    } else if (call.method.equals("tp_isEUTraffic")) {
                        result.success(com.tradplus.ads.open.TradPlusSdk.isEUTraffic(getApplicationContext()));
                    } else if (call.method.equals("tp_setGDPRDataCollection")) {
                        setGDPRMethonCall(call, result);
                    } else if (call.method.equals("tp_getGDPRDataCollection")) {
                        result.success(getGDPRMethonCall());
                    } else if (call.method.equals("tp_setLGPDConsent")) {
                        setLGPDMethonCall(call, result);
                    } else if (call.method.equals("tp_getLGPDConsent")) {
                        result.success(getLGPDMethonCall());
                    } else if (call.method.equals("tp_getCCPADoNotSell")) {
                        result.success(isCCPADoNotSell());
                    } else if (call.method.equals("tp_setCOPPAIsAgeRestrictedUser")) {
                        setCOPPAMethonCall(call, result);
                    } else if (call.method.equals("tp_getCOPPAIsAgeRestrictedUser")) {
                        result.success(isCOPPAAgeRestrictedUser());
                    } else if (call.method.equals("tp_setOpenPersonalizedAd")) {
                        setOpenPersonalizedAdMethonCall(call, result);
                    } else if (call.method.equals("tp_isOpenPersonalizedAd")) {
                        result.success(isOpenPersonalizedAd());
                    } else if (call.method.equals("tp_setFirstShowGDPR")) {
                        setFirstShowGDPR(call, result);
                    } else if (call.method.equals("tp_isFirstShowGDPR")) {
                        result.success(isFirstShowGDPR());
                    } else if (call.method.equals("tp_setCustomMap")) {
                        setSegmentMap(call, result);
                    }else if (call.method.equals("tp_setMaxDatabaseSize")) {
                        setMaxDatabaseSize(call, result);
                    } else if (call.method.equals("tp_clearCache")) {
                        clearCache(call, result);
                    } else if (call.method.equals("tp_isCalifornia")) {
                        result.success(com.tradplus.ads.open.TradPlusSdk.isCalifornia(getApplicationContext()));
                    } else if (call.method.equals("tp_isPrivacyUserAgree")) {
                        result.success(com.tradplus.ads.open.TradPlusSdk.isPrivacyUserAgree());
                    } else if (call.method.equals("tp_setPrivacyUserAgree")) {
                        setPrivacyUserAgreeMethonCall(call, result);
                    } else if (call.method.equals("tp_setOpenDelayLoadAds")) {
                        setOpenDelayLoadAds(call, result);
                    } else if (call.method.equals("tp_addGlobalAdImpressionListener")) {
                        setGlobalImpressionListener(call, result);
                    }else if (call.method.equals("tp_setSettingDataParam")) {
                        setSettingDataParam(call, result);
                    }else if (call.method.equals("tp_openTradPlusTool")) {
                        openTradPlusTool(call, result);
                    }else if (call.method.equals("uid2_start")) {
                        UID2Manager.getInstance().onMethodCall(call, result);
                    }else if (call.method.equals("uid2_reset")) {
                        UID2Manager.getInstance().onMethodCall(call, result);
                    }else if (call.method.equals("tp_setPlatformLimit")) {
                        setPlatformLimit(call, result);
                    } else {
                        Log.e("TradPlusLog", "unknown method");
                    }
                } catch (Throwable e) {
                    e.printStackTrace();
                }
            }
        });

        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("tp_native_view", new TPNativeViewFactory(flutterPluginBinding.getBinaryMessenger()));
        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("tp_banner_view", new TPBannerViewFactory(flutterPluginBinding.getBinaryMessenger()));
        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("tp_splash_view", new TPSplashViewFactory(flutterPluginBinding.getBinaryMessenger()));
        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("tp_interactive_view", new TPInterActiveViewFactory(flutterPluginBinding.getBinaryMessenger()));
    }

    private void clearCache(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String unitId = call.argument("adUnitId");
        com.tradplus.ads.open.TradPlusSdk.clearCache(unitId);
    }

    private void setSegmentMap(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Map<String, String> customMap = call.argument("customMap");
        Log.i("tradplus", "customMap = " + customMap);
        if (customMap != null) {

            SegmentUtils.initCustomMap(customMap);
        }
    }
    private void setSettingDataParam(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Map<String, Object> settingMap = call.argument("setting");
        Log.i("tradplus", "settingMap = " + settingMap);
        if (settingMap != null) {
            com.tradplus.ads.open.TradPlusSdk.setSettingDataParam(settingMap);
        }
    }

    private void setPlatformLimit(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        List<Map<String, Integer>> mapList = call.arguments();
        try {
            // 以防开发者使用错误的版本，低版本没有TPPlatform和setPlatformLimit API
            Log.i("tradplus", "Flutter setPlatformLimit mapList: " +mapList);
            ArrayList<TPPlatform> platforms = new ArrayList<>();
            if (mapList != null) {
                for (int i = 0; i < mapList.size(); i++) {
                    Map<String, Integer> platformList = mapList.get(i);
                    if (platformList != null && !platformList.isEmpty()) {
                        int platform = platformList.get("platform");
                        int num = platformList.get("num");
                        platforms.add(new TPPlatform(String.valueOf(platform),String.valueOf(num)));
                    }
                }
            }
            com.tradplus.ads.open.TradPlusSdk.setPlatformLimit(platforms.isEmpty() ? null : platforms);
        }catch (Throwable e) {

        }

    }

    public void setGlobalImpressionListener(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        com.tradplus.ads.open.TradPlusSdk.setGlobalImpressionListener(new GlobalImpressionManager.GlobalImpressionListener() {
            @Override
            public void onImpressionSuccess(TPAdInfo tpAdInfo) {
                final Map<String, Object> paramsMap = new HashMap<>();
                paramsMap.put("adInfo", TPUtils.tpAdInfoToMap(tpAdInfo));
                TradPlusSdk.getInstance().sendCallBackToFlutter("tp_globalAdImpression", paramsMap);
            }
        });
    }

    public void setFirstShowGDPR(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean first = call.argument("first");

        com.tradplus.ads.open.TradPlusSdk.setIsFirstShowGDPR(getApplicationContext(), first);

    }

    public boolean isFirstShowGDPR() {
        return com.tradplus.ads.open.TradPlusSdk.isFirstShowGDPR(getApplicationContext());
    }

    public void setPrivacyUserAgreeMethonCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean open = call.argument("open");

        com.tradplus.ads.open.TradPlusSdk.setPrivacyUserAgree(open);

    }

    public void setOpenPersonalizedAdMethonCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean open = call.argument("open");

        com.tradplus.ads.open.TradPlusSdk.setOpenPersonalizedAd(open);

    }

    public boolean isOpenPersonalizedAd() {
        return com.tradplus.ads.open.TradPlusSdk.isOpenPersonalizedAd();
    }

    public void setMaxDatabaseSize(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        long size = call.argument("size");
        com.tradplus.ads.open.TradPlusSdk.setMaxDatabaseSize(size);
    }

    public void currentAreaMethonCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        com.tradplus.ads.open.TradPlusSdk.checkCurrentArea(getApplicationContext(), new TPPrivacyManager.OnPrivacyRegionListener() {
            @Override
            public void onSuccess(boolean b, boolean i, boolean b1) {
                TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        final Map<String, Object> paramsMap = new HashMap<>();
                        paramsMap.put("iseu", b);
                        paramsMap.put("iscn", i);
                        paramsMap.put("isca", b1);

                        TradPlusSdk.getInstance().sendCallBackToFlutter("tp_currentarea_success", paramsMap);
                    }
                });

            }

            @Override
            public void onFailed() {
                TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        final Map<String, Object> paramsMap = new HashMap<>();
                        TradPlusSdk.getInstance().sendCallBackToFlutter("tp_currentarea_failed", paramsMap);
                    }
                });

            }

        });

    }

    public void initMethonCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String appId = call.argument("appId");

        if (appId == null || appId.length() <= 0) {
            Log.e("TradPlusLog", "appId is null, please check");
            return;
        }

        com.tradplus.ads.open.TradPlusSdk.setTradPlusInitListener(new com.tradplus.ads.open.TradPlusSdk.TradPlusInitListener() {
            @Override
            public void onInitSuccess() {
                TPTaskManager.getInstance().runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        final Map<String, Object> paramsMap = new HashMap<>();
                        paramsMap.put("success", true);
                        TradPlusSdk.getInstance().sendCallBackToFlutter("tp_initFinish", paramsMap);
                    }
                });

            }
        });
        com.tradplus.ads.open.TradPlusSdk.initSdk(getApplicationContext(), appId);

    }

    public void setCOPPAMethonCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean isChild = call.argument("isChild");
        com.tradplus.ads.open.TradPlusSdk.setCOPPAIsAgeRestrictedUser(getApplicationContext(), isChild);
    }

    public int isCOPPAAgeRestrictedUser() {
        return com.tradplus.ads.open.TradPlusSdk.isCOPPAAgeRestrictedUser(getApplicationContext()) == 1 ? 0 : 1;
    }

    public void setCCPAMethonCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean canDataCollection = call.argument("canDataCollection");
        com.tradplus.ads.open.TradPlusSdk.setCCPADoNotSell(getApplicationContext(), canDataCollection);
    }

    public int isCCPADoNotSell() {
        return com.tradplus.ads.open.TradPlusSdk.isCCPADoNotSell(getApplicationContext()) == 1 ? 0 : 1;
    }

    public void setGDPRMethonCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean canDataCollection = call.argument("canDataCollection");
        com.tradplus.ads.open.TradPlusSdk.setGDPRDataCollection(getApplicationContext(), canDataCollection ? 0 : 1);
    }

    public int getGDPRMethonCall() {
        return com.tradplus.ads.open.TradPlusSdk.getGDPRDataCollection(getApplicationContext());
    }

    public void setLGPDMethonCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean canDataCollection = call.argument("canDataCollection");
        com.tradplus.ads.open.TradPlusSdk.setLGPDConsent(getApplicationContext(), canDataCollection ? 0 : 1);
    }

    public int getLGPDMethonCall() {
        return com.tradplus.ads.open.TradPlusSdk.getLGPDConsent(getApplicationContext());
    }

    private String getSdkVersion() {
        return com.tradplus.ads.open.TradPlusSdk.getSdkVersion();
    }

    public void sendCallBackToFlutter(final String callName, final Map<String, Object> paramsMap) {
        try {
            channel.invokeMethod(callName, paramsMap);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    public void setOpenDelayLoadAds(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        boolean isOpen = call.argument("isOpen");
        com.tradplus.ads.open.TradPlusSdk.setOpenDelayLoadAds(isOpen);
    }

    private Activity mainAtivity;

    public void setActivity(Activity activity) {
        mainAtivity = activity;
    }

    public Activity getActivity() {
        return mainAtivity;
    }

    public Context getApplicationContext() {
        return mainAtivity.getApplicationContext();
    }

    public void openTradPlusTool(@NonNull MethodCall call, @NonNull MethodChannel.Result result){
        String appid = call.argument("appId");

        try{
            ImportSDKUtil.getInstance().showTestTools(getActivity(), appid);

        }catch (Throwable throwable){
            throwable.printStackTrace();
        }

    }
}
