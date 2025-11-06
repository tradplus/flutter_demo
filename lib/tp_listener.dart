import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'package:flutter/services.dart';

final TPListenerManager = TPListenerCenter();

class TPListenerCenter {
  TPInterActiveAdListener? interActiveAdListener;
  final Map interActiveAdListenerMap = {};

  TPNativeAdListener? nativeAdListener;
  final Map nativeAdListenerMap = {};

  TPInterstitialAdListener? interstitialAdListener;
  final Map interstitialAdListenerMap = {};

  TPRewardVideoAdListener? rewardVideoAdListener;
  final Map rewardVideoAdListenerMap = {};

  TPOfferwallAdListener? offerwallAdListener;
  final Map offerwallAdListenerMap = {};

  TPSplashAdListener? splashAdListener;
  final Map splashAdListenerMap = {};

  TPBannerAdListener? bannerAdListener;
  final Map bannerAdListenerMap = {};

  TPInitListener? initListener;

  TTDUID2Listener? uid2Listener;

  TPGlobalAdImpressionListener? globalAdImpressionListener;

  TPListenerCenter() {
    TradplusSdk.eventChannel.receiveBroadcastStream().listen((event) {
      // 处理来自原生的事件
      String method = event["method"];
      Map data = event["data"];
      print('Received event: $method,data=$data');
      tpMethodCall(method, data);
    });
    TradplusSdk.channel.setMethodCallHandler((MethodCall call) async {
      String method = call.method;
      tpMethodCall(method, call.arguments);
    });
  }

  tpMethodCall(String method, dynamic map) {
    if (method == 'tp_globalAdImpression') {
      globalAdImpressionCallBack(method, map);
    } else if (method.startsWith("uid2_")) {
      uid2CallBack(method, map);
    } else if (method.startsWith("tp_")) {
      //SDK相关
      tpCallBack(method, map);
    } else if (method.startsWith("native_")) {
      nativeCallBack(method, map);
    } else if (method.startsWith("interstitial_")) {
      interstitialCallBack(method, map);
    } else if (method.startsWith("rewardVideo_")) {
      rewardVideoCallBack(method, map);
    } else if (method.startsWith("banner_")) {
      bannerCallBack(method, map);
    } else if (method.startsWith("splash_")) {
      splashCallBack(method, map);
    } else if (method.startsWith("offerwall_")) {
      offerwallCallBack(method, map);
    } else if (method.startsWith("interactive_")) {
      interActiveCallBack(method, map);
    } else {
      print("unkown method");
    }
  }

  globalAdImpressionCallBack(String method, dynamic arguments) {
    if (globalAdImpressionListener == null) {
      print("not set globalAdImpressionListener");
      return;
    }
    TPSDKManager.globalAdImpressionCallback(
        globalAdImpressionListener!, method, arguments);
  }

  tpCallBack(String method, dynamic arguments) {
    if (initListener == null) {
      print("not set initListener");
      return;
    }
    TPSDKManager.callback(initListener!, method, arguments);
  }

  uid2CallBack(String method, dynamic arguments) {
    if (uid2Listener == null) {
      print("not set initListener");
      return;
    }
    ttdUID2Manager.callback(uid2Listener!, method, arguments);
  }

  offerwallCallBack(String method, dynamic arguments) {
    String adUnitId = "";
    if (arguments.containsKey("adUnitID")) {
      adUnitId = arguments["adUnitID"];
    }
    TPOfferwallAdListener? callBackListener;
    if (adUnitId.isNotEmpty && offerwallAdListenerMap.containsKey(adUnitId)) {
      callBackListener = offerwallAdListenerMap[adUnitId];
    } else {
      callBackListener = offerwallAdListener;
    }
    if (callBackListener == null) {
      print("not any offerwallAdListener");
      return;
    }
    TPOfferWallManager.callback(callBackListener, adUnitId, method, arguments);
  }

  splashCallBack(String method, dynamic arguments) {
    String adUnitId = "";
    if (arguments.containsKey("adUnitID")) {
      adUnitId = arguments["adUnitID"];
    }
    TPSplashAdListener? callBackListener;
    if (adUnitId.isNotEmpty && splashAdListenerMap.containsKey(adUnitId)) {
      callBackListener = splashAdListenerMap[adUnitId];
    } else {
      callBackListener = splashAdListener;
    }
    if (callBackListener == null) {
      print("not any splashAdListener");
      return;
    }
    TPSplashManager.callback(callBackListener, adUnitId, method, arguments);
  }

  bannerCallBack(String method, dynamic arguments) {
    String adUnitId = "";
    if (arguments.containsKey("adUnitID")) {
      adUnitId = arguments["adUnitID"];
    }
    TPBannerAdListener? callBackListener;
    if (adUnitId.isNotEmpty && bannerAdListenerMap.containsKey(adUnitId)) {
      callBackListener = bannerAdListenerMap[adUnitId];
    } else {
      callBackListener = bannerAdListener;
    }
    if (callBackListener == null) {
      print("not any bannerAdListener");
      return;
    }
    TPBannerManager.callback(callBackListener, adUnitId, method, arguments);
  }

  interActiveCallBack(String method, dynamic arguments) {
    String adUnitId = "";
    if (arguments.containsKey("adUnitID")) {
      adUnitId = arguments["adUnitID"];
    }
    TPInterActiveAdListener? callBackListener;
    if (adUnitId.isNotEmpty && interActiveAdListenerMap.containsKey(adUnitId)) {
      callBackListener = interActiveAdListenerMap[adUnitId];
    } else {
      callBackListener = interActiveAdListener;
    }
    if (callBackListener == null) {
      print("not anyinterActiveAdListener");
      return;
    }
    TPInteractiveManager.callback(
        callBackListener, adUnitId, method, arguments);
  }

  rewardVideoCallBack(String method, dynamic arguments) {
    String adUnitId = "";
    if (arguments.containsKey("adUnitID")) {
      adUnitId = arguments["adUnitID"];
    }
    TPRewardVideoAdListener? callBackListener;
    if (adUnitId.isNotEmpty && rewardVideoAdListenerMap.containsKey(adUnitId)) {
      callBackListener = rewardVideoAdListenerMap[adUnitId];
    } else {
      callBackListener = rewardVideoAdListener;
    }
    if (callBackListener == null) {
      print("not any rewardVideoAdListener");
      return;
    }
    TPRewardVideoManager.callback(
        callBackListener, adUnitId, method, arguments);
  }

  interstitialCallBack(String method, dynamic arguments) {
    String adUnitId = "";
    if (arguments.containsKey("adUnitID")) {
      adUnitId = arguments["adUnitID"];
    }
    TPInterstitialAdListener? callBackListener;
    if (adUnitId.isNotEmpty &&
        interstitialAdListenerMap.containsKey(adUnitId)) {
      callBackListener = interstitialAdListenerMap[adUnitId];
    } else {
      callBackListener = interstitialAdListener;
    }
    if (callBackListener == null) {
      print("not any interstitialAdListener");
      return;
    }
    TPInterstitialManager.callback(
        callBackListener, adUnitId, method, arguments);
  }

  nativeCallBack(String method, dynamic arguments) {
    String adUnitId = "";
    if (arguments.containsKey("adUnitID")) {
      adUnitId = arguments["adUnitID"];
    }
    TPNativeAdListener? callBackListener;
    if (adUnitId.isNotEmpty && nativeAdListenerMap.containsKey(adUnitId)) {
      callBackListener = nativeAdListenerMap[adUnitId];
    } else {
      callBackListener = nativeAdListener;
    }
    if (callBackListener == null) {
      print("not any nativeAdListener");
      return;
    }
    TPNativeManager.callback(callBackListener, adUnitId, method, arguments);
  }
}
