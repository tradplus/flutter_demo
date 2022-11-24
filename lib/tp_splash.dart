import 'package:tradplus_sdk/tradplus_sdk.dart';

final TPSplashManager = TPSplash();

class TPSplash {
  ///构建ExtraMap： customMap 流量分组等自定义数据
  Map createSplashExtraMap({
    Map? customMap, //流量分组Map
    Map? localParams, //客户设置特殊参数数据
  }) {
    Map extraMap = {};
    if (localParams != null) {
      extraMap['localParams'] = localParams;
    }
    if (customMap != null) {
      extraMap['customMap'] = customMap;
    }
    return extraMap;
  }

  ///加载广告：adUnitId 广告位ID, extraMap = createRewardVideoExtraMap
  Future<void> loadSplashAd(String adUnitId, {Map? extraMap}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if (extraMap != null) {
      arguments['extraMap'] = extraMap;
    }
    TradplusSdk.channel.invokeMethod('splash_load', arguments);
  }

  ///广告是否ready：adUnitId 广告位ID
  Future<bool> splashAdReady(String adUnitId) async {
    return await TradplusSdk.channel
        .invokeMethod('splash_ready', {'adUnitID': adUnitId});
  }

  ///展示广告：adUnitId 广告位ID ,className 用户自定义模版名称  此接口仅支持iOS
  Future<void> showSplashAd(String adUnitId,{String className = ""}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    arguments['className'] = className;
    TradplusSdk.channel.invokeMethod('splash_show', arguments);
  }

  ///开发者通过此接口在展示前设置透传信息，透传信息可以在广告展示后的相关回调的adInfo中获取
  Future<void> setCustomAdInfo(String adUnitId,Map customAdInfo) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    arguments['customAdInfo'] = customAdInfo;
    TradplusSdk.channel.invokeMethod('splash_setCustomAdInfo', arguments);
  }

  ///设置广告Listener：adUnitId 设置后只返回指定广告位相关回调（可选）
  setSplashListener(TPSplashAdListener listener, {String adUnitId = ""}) {
    if (adUnitId.isNotEmpty) {
      TPListenerManager.splashAdListenerMap[adUnitId] = listener;
    } else {
      TPListenerManager.splashAdListener = listener;
    }
  }

  callback(TPSplashAdListener listener, String adUnitId, String method,
      Map arguments) {
    Map adInfo = {};
    if (arguments.containsKey("adInfo")) {
      adInfo = arguments['adInfo'];
    }
    Map error = {};
    if (arguments.containsKey("adError")) {
      error = arguments['adError'];
    }
    if (method == 'splash_loaded') {
      listener.onAdLoaded(adUnitId, adInfo);
    } else if (method == 'splash_loadFailed') {
      listener.onAdLoadFailed(adUnitId, error);
    } else if (method == 'splash_impression') {
      listener.onAdImpression(adUnitId, adInfo);
    } else if (method == 'splash_showFailed') {
      listener.onAdShowFailed(adUnitId, adInfo, error);
    } else if (method == 'splash_clicked') {
      listener.onAdClicked(adUnitId, adInfo);
    } else if (method == 'splash_closed') {
      listener.onAdClosed(adUnitId, adInfo);
    } else if (method == 'splash_startLoad') {
      listener.onAdStartLoad!(adUnitId, adInfo);
    } else if (method == 'splash_oneLayerStartLoad') {
      listener.oneLayerStartLoad!(adUnitId, adInfo);
    } else if (method == 'splash_bidStart') {
      listener.onBiddingStart!(adUnitId, adInfo);
    } else if (method == 'splash_bidEnd') {
      listener.onBiddingEnd!(adUnitId, adInfo, error);
    } else if (method == 'splash_oneLayerLoaded') {
      listener.oneLayerLoaded!(adUnitId, adInfo);
    } else if (method == 'splash_oneLayerLoadedFail') {
      listener.oneLayerLoadFailed(adUnitId, adInfo, error);
    } else if (method == 'splash_allLoaded') {
      bool isSuccess = arguments["success"];
      listener.onAdAllLoaded!(adUnitId, isSuccess);
    }else if (method == 'splash_onZoomOutStart') {
      listener.onZoomOutStart!(adUnitId, adInfo);
    }else if (method == 'splash_onZoomOutEnd') {
      listener.onZoomOutEnd!(adUnitId, adInfo);
    }else if (method == 'splash_onSkip') {
      listener.onSkip!(adUnitId, adInfo);
    } else if (method == 'splash_downloadstart') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadStart!(adUnitId, l, l1, s, s1);
    } else if (method == 'splash_downloadupdate') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      int i = arguments["p"];
      listener.onDownloadUpdate!(adUnitId, l, l1, s, s1, i);
    } else if (method == 'splash_downloadpause') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadPause!(adUnitId, l, l1, s, s1);
    } else if (method == 'splash_downloadfinish') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadFinish!(adUnitId, l, l1, s, s1);
    } else if (method == 'splash_downloadfail') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadFail!(adUnitId, l, l1, s, s1);
    } else if (method == 'splash_downloadinstall') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onInstall!(adUnitId, l, l1, s, s1);
    }
  }
}

class TPSplashAdListener {
  final Function(String adUnitId, Map adInfo) onAdLoaded;
  final Function(String adUnitId, Map error) onAdLoadFailed;
  final Function(String adUnitId, Map adInfo) onAdImpression;
  final Function(String adUnitId, Map adInfo, Map error) onAdShowFailed;
  final Function(String adUnitId, Map adInfo) onAdClicked;
  final Function(String adUnitId, Map adInfo) onAdClosed;
  final Function(String adUnitId, Map adInfo, Map error) oneLayerLoadFailed;
  final Function(String adUnitId, Map adInfo)? onAdStartLoad;
  final Function(String adUnitId, Map adInfo)? onBiddingStart;
  final Function(String adUnitId, Map adInfo, Map error)? onBiddingEnd;
  final Function(String adUnitId, Map adInfo)? oneLayerStartLoad;
  final Function(String adUnitId, Map adInfo)? oneLayerLoaded;
  final Function(String adUnitId, bool isSuccess)? onAdAllLoaded;

  final Function(String adUnitId, Map adInfo)? onZoomOutStart;
  final Function(String adUnitId, Map adInfo)? onZoomOutEnd;
  final Function(String adUnitId, Map adInfo)? onSkip;

  //android only 下载回调
  final Function(String adUnitId, num totalBytes, num currBytes,
      String fileName, String appName)? onDownloadStart;
  final Function(String adUnitId, num totalBytes, num currBytes,
      String fileName, String appName, int progress)? onDownloadUpdate;
  final Function(String adUnitId, num totalBytes, num currBytes,
      String fileName, String appName)? onDownloadPause;
  final Function(String adUnitId, num totalBytes, num currBytes,
      String fileName, String appName)? onDownloadFinish;
  final Function(String adUnitId, num totalBytes, num currBytes,
      String fileName, String appName)? onDownloadFail;
  final Function(String adUnitId, num totalBytes, num currBytes,
      String fileName, String appName)? onInstall;

  const TPSplashAdListener(
      {required this.onAdLoaded,
      required this.onAdLoadFailed,
      required this.onAdImpression,
      required this.onAdShowFailed,
      required this.onAdClicked,
      required this.onAdClosed,
      required this.oneLayerLoadFailed,
      this.onAdStartLoad,
      this.onBiddingStart,
      this.onBiddingEnd,
      this.oneLayerStartLoad,
      this.oneLayerLoaded,
      this.onAdAllLoaded,
      this.onDownloadStart,
      this.onDownloadUpdate,
      this.onDownloadPause,
      this.onDownloadFinish,
      this.onDownloadFail,
      this.onInstall,
      this.onZoomOutStart,
      this.onZoomOutEnd,
      this.onSkip
      });
}
