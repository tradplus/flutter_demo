import 'package:tradplus_sdk/tradplus_sdk.dart';

final TPBannerManager = TPBanner();

class TPBanner {
  ///构建ExtraMap：height 高度，width 宽度，customMap 流量分组等自定义数据，sceneId 场景ID
  ///contentMode 居中模式 仅iOS支持 0 = 顶部水平居中；1 = 垂直居中并水平居中； 2 = 底边水平居中；其他 = 0
  ///closeAutoDestroy 是否关闭自动destroy 仅安卓支持
  ///backgroundColor 背景色 例:#FFFFFF
  Map createBannerExtraMap({
    double height = 0, //高度
    double width = 0, //宽度
    Map? customMap, //流量分组Map
    String? sceneId, //场景ID
    Map? localParams, //客户设置特殊参数数据
    bool? closeAutoDestroy = false, //是否关闭自动destroy（仅安卓支持）
    //仅iOS支持 居中模式
    // 0 = 顶部水平居中；1 = 垂直居中并水平居中； 2 = 底边水平居中；其他 = 0
    int contentMode = 0,
    bool openAutoLoadCallback = false,
    double maxWaitTime = 0,
    String? backgroundColor, //背景色 例:#FFFFFF
  }) {
    Map extraMap = {};
    extraMap['height'] = height;
    extraMap['width'] = width;
    extraMap['closeAutoDestroy'] = closeAutoDestroy;
    extraMap['contentMode'] = contentMode;
    if (localParams != null) {
      extraMap['localParams'] = localParams;
    }
    if (customMap != null) {
      extraMap['customMap'] = customMap;
    }
    if (sceneId != null) {
      extraMap['sceneId'] = sceneId;
    }
    if (backgroundColor != null && backgroundColor.isNotEmpty) {
      extraMap['backgroundColor'] = backgroundColor;
    }
    extraMap['openAutoLoadCallback'] = openAutoLoadCallback;
    extraMap['maxWaitTime'] = maxWaitTime;
    return extraMap;
  }

  ///加载广告：adUnitId 广告位ID, extraMap = createBannerExtraMap
  Future<void> loadBannerAd(String adUnitId, {Map? extraMap}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if (extraMap != null) {
      arguments['extraMap'] = extraMap;
    }
    TradplusSdk.channel.invokeMethod('banner_load', arguments);
  }

  ///广告位是否ready：adUnitId 广告位ID
  Future<bool> bannerAdReady(String adUnitId) async {
    return await TradplusSdk.channel
        .invokeMethod('banner_ready', {'adUnitID': adUnitId});
  }

  ///进入广告场景：adUnitId 广告位ID ,sceneId 从Tradplus后台获取到到场景ID
  Future<void> entryBannerAdScenario(String adUnitId, {String? sceneId}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if (sceneId != null) {
      arguments['sceneId'] = sceneId;
    }
    TradplusSdk.channel.invokeMethod('banner_entryAdScenario', arguments);
  }

  ///开发者通过此接口在展示前设置透传信息，透传信息可以在广告展示后的相关回调的adInfo中获取
  Future<void> setCustomAdInfo(String adUnitId, Map customAdInfo) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    arguments['customAdInfo'] = customAdInfo;
    TradplusSdk.channel.invokeMethod('banner_setCustomAdInfo', arguments);
  }

  ///设置广告Listener：adUnitId 设置后只返回指定广告位相关回调（可选）
  setBannerListener(TPBannerAdListener listener, {String adUnitId = ""}) {
    if (adUnitId.isNotEmpty) {
      TPListenerManager.bannerAdListenerMap[adUnitId] = listener;
    } else {
      TPListenerManager.bannerAdListener = listener;
    }
  }

  callback(TPBannerAdListener listener, String adUnitId, String method,
      Map arguments) {
    Map adInfo = {};
    if (arguments.containsKey("adInfo")) {
      adInfo = arguments['adInfo'];
    }
    Map error = {};
    if (arguments.containsKey("adError")) {
      error = arguments['adError'];
    }
    if (method == 'banner_loaded') {
      listener.onAdLoaded(adUnitId, adInfo);
    } else if (method == 'banner_loadFailed') {
      listener.onAdLoadFailed(adUnitId, error);
    } else if (method == 'banner_impression') {
      listener.onAdImpression(adUnitId, adInfo);
    } else if (method == 'banner_showFailed') {
      listener.onAdShowFailed(adUnitId, adInfo, error);
    } else if (method == 'banner_clicked') {
      listener.onAdClicked(adUnitId, adInfo);
    } else if (method == 'banner_closed') {
      listener.onAdClosed(adUnitId, adInfo);
    } else if (method == 'banner_startLoad') {
      listener.onAdStartLoad!(adUnitId, adInfo);
    } else if (method == 'banner_oneLayerStartLoad') {
      listener.oneLayerStartLoad!(adUnitId, adInfo);
    } else if (method == 'banner_bidStart') {
      listener.onBiddingStart!(adUnitId, adInfo);
    } else if (method == 'banner_bidEnd') {
      listener.onBiddingEnd!(adUnitId, adInfo, error);
    } else if (method == 'banner_isLoading') {
      listener.onAdIsLoading!(adUnitId);
    } else if (method == 'banner_oneLayerLoaded') {
      listener.oneLayerLoaded!(adUnitId, adInfo);
    } else if (method == 'banner_oneLayerLoadedFail') {
      listener.oneLayerLoadFailed(adUnitId, adInfo, error);
    } else if (method == 'banner_allLoaded') {
      bool isSuccess = arguments["success"];
      listener.onAdAllLoaded!(adUnitId, isSuccess);
    } else if (method == 'banner_downloadstart') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadStart!(adUnitId, l, l1, s, s1);
    } else if (method == 'banner_downloadupdate') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      int i = arguments["p"];
      listener.onDownloadUpdate!(adUnitId, l, l1, s, s1, i);
    } else if (method == 'banner_downloadpause') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadPause!(adUnitId, l, l1, s, s1);
    } else if (method == 'banner_downloadfinish') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadFinish!(adUnitId, l, l1, s, s1);
    } else if (method == 'banner_downloadfail') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadFail!(adUnitId, l, l1, s, s1);
    } else if (method == 'banner_downloadinstall') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onInstall!(adUnitId, l, l1, s, s1);
    }
  }
}

class TPBannerAdListener {
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
  final Function(String adUnitId)? onAdIsLoading;
  final Function(String adUnitId, Map adInfo)? oneLayerStartLoad;
  final Function(String adUnitId, Map adInfo)? oneLayerLoaded;
  final Function(String adUnitId, bool isSuccess)? onAdAllLoaded;
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
  const TPBannerAdListener(
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
      this.onAdIsLoading,
      this.oneLayerStartLoad,
      this.oneLayerLoaded,
      this.onAdAllLoaded,
      this.onDownloadStart,
      this.onDownloadUpdate,
      this.onDownloadPause,
      this.onDownloadFinish,
      this.onDownloadFail,
      this.onInstall});
}
