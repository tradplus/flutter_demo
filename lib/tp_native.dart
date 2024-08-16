import 'package:tradplus_sdk/tradplus_sdk.dart';

final TPNativeManager = TPNative();

class TPNative {
  ///自定义模版参数
  Map createNativeSubViewAttribute(double width, double height,
      {double x = 0,
      double y = 0,
      String backgroundColorStr = '#FFFFFF',
      String textColorStr = '#000000',
      double textSize = 15,
      bool isCustomClick = true}) {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'backgroundColorStr': backgroundColorStr,
      'textColorStr': textColorStr,
      'textSize': textSize,
      'isCustomClick': isCustomClick,
    };
  }

  ///构建ExtraMap： isAutoLoad 是否开启自动记载 默认开启, customMap 流量分组等自定义数据
  ///templateWidth 原生模版类型预设宽度 ,templateWidth 原生模版类型预设高度
  Map createNativeExtraMap({
    double templateWidth = 320, //模版类型预设宽度
    double templateHeight = 250, //模版类型预设高度
    num? loadCount,
    Map? customMap,
    Map? localParams, //客户设置特殊参数数据
    bool openAutoLoadCallback = false,
    double maxWaitTime = 0,
  }) {
    Map extraMap = {};
    if (localParams != null) {
      extraMap['localParams'] = localParams;
    }
    extraMap['templateWidth'] = templateWidth;
    extraMap['templateHeight'] = templateHeight;
    if (loadCount != null) {
      extraMap['loadCount'] = loadCount;
    }
    if (customMap != null) {
      extraMap['customMap'] = customMap;
    }
    extraMap['openAutoLoadCallback'] = openAutoLoadCallback;
    extraMap['maxWaitTime'] = maxWaitTime;
    return extraMap;
  }

  ///加载广告：adUnitId 广告位ID, extraMap = createNativeExtraMap
  Future<void> loadNativeAd(String adUnitId, {Map? extraMap}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if (extraMap != null) {
      arguments['extraMap'] = extraMap;
    }
    TradplusSdk.channel.invokeMethod('native_load', arguments);
  }

  ///广告是否ready：adUnitId 广告位ID
  Future<bool> nativeAdReady(String adUnitId) async {
    return await TradplusSdk.channel
        .invokeMethod('native_ready', {'adUnitID': adUnitId});
  }

  ///获取已缓存广告数量
  Future<int> nativeLoadedCount(String adUnitId) async {
    return await TradplusSdk.channel
        .invokeMethod('native_getLoadedCount', {'adUnitID': adUnitId});
  }

  ///进入广告场景：adUnitId 广告位ID ,sceneId 从Tradplus后台获取到到场景ID
  Future<void> entryNativeAdScenario(String adUnitId, {String? sceneId}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if (sceneId != null) {
      arguments['sceneId'] = sceneId;
    }
    TradplusSdk.channel.invokeMethod('native_entryAdScenario', arguments);
  }

  ///开发者通过此接口在展示前设置透传信息，透传信息可以在广告展示后的相关回调的adInfo中获取
  Future<void> setCustomAdInfo(String adUnitId, Map customAdInfo) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    arguments['customAdInfo'] = customAdInfo;
    TradplusSdk.channel.invokeMethod('native_setCustomAdInfo', arguments);
  }

  ///设置广告Listener：adUnitId 设置后只返回指定广告位相关回调（可选）
  setNativeAdListener(TPNativeAdListener listener, {String adUnitId = ""}) {
    if (adUnitId.isNotEmpty) {
      TPListenerManager.nativeAdListenerMap[adUnitId] = listener;
    } else {
      TPListenerManager.nativeAdListener = listener;
    }
  }

  callback(TPNativeAdListener listener, String adUnitId, String method,
      Map arguments) {
    Map adInfo = {};
    if (arguments.containsKey("adInfo")) {
      adInfo = arguments['adInfo'];
    }
    Map error = {};
    if (arguments.containsKey("adError")) {
      error = arguments['adError'];
    }
    if (method == 'native_loaded') {
      listener.onAdLoaded(adUnitId, adInfo);
    } else if (method == 'native_loadFailed') {
      listener.onAdLoadFailed(adUnitId, error);
    } else if (method == 'native_impression') {
      listener.onAdImpression(adUnitId, adInfo);
    } else if (method == 'native_showFailed') {
      listener.onAdShowFailed(adUnitId, adInfo, error);
    } else if (method == 'native_clicked') {
      listener.onAdClicked(adUnitId, adInfo);
    } else if (method == 'native_closed') {
      listener.onAdClosed(adUnitId, adInfo);
    } else if (method == 'native_startLoad') {
      listener.onAdStartLoad!(adUnitId, adInfo);
    } else if (method == 'native_oneLayerStartLoad') {
      listener.oneLayerStartLoad!(adUnitId, adInfo);
    } else if (method == 'native_bidStart') {
      listener.onBiddingStart!(adUnitId, adInfo);
    } else if (method == 'native_bidEnd') {
      listener.onBiddingEnd!(adUnitId, adInfo, error);
    } else if (method == 'native_isLoading') {
      listener.onAdIsLoading!(adUnitId);
    } else if (method == 'native_oneLayerLoaded') {
      listener.oneLayerLoaded!(adUnitId, adInfo);
    } else if (method == 'native_oneLayerLoadedFail') {
      listener.oneLayerLoadFailed(adUnitId, adInfo, error);
    } else if (method == 'native_allLoaded') {
      bool isSuccess = arguments["success"];
      listener.onAdAllLoaded!(adUnitId, isSuccess);
    } else if (method == 'native_playStart') {
      listener.onVideoPlayStart!(adUnitId, adInfo);
    } else if (method == 'native_playEnd') {
      listener.onVideoPlayEnd!(adUnitId, adInfo);
    } else if (method == 'native_downloadstart') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadStart!(adUnitId, l, l1, s, s1);
    } else if (method == 'native_downloadupdate') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      int i = arguments["p"];
      listener.onDownloadUpdate!(adUnitId, l, l1, s, s1, i);
    } else if (method == 'native_downloadpause') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadPause!(adUnitId, l, l1, s, s1);
    } else if (method == 'native_downloadfinish') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadFinish!(adUnitId, l, l1, s, s1);
    } else if (method == 'native_downloadfail') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadFail!(adUnitId, l, l1, s, s1);
    } else if (method == 'native_downloadinstall') {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onInstall!(adUnitId, l, l1, s, s1);
    }
  }
}

class TPNativeAdListener {
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
  final Function(String adUnitId, Map adInfo)? onVideoPlayStart;
  final Function(String adUnitId, Map adInfo)? onVideoPlayEnd;
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
  const TPNativeAdListener(
      {required this.onAdLoaded,
      required this.onAdLoadFailed,
      required this.onAdClicked,
      required this.onAdClosed,
      required this.oneLayerLoadFailed,
      required this.onAdImpression,
      required this.onAdShowFailed,
      this.onAdStartLoad,
      this.onBiddingStart,
      this.onBiddingEnd,
      this.onAdIsLoading,
      this.oneLayerStartLoad,
      this.oneLayerLoaded,
      this.onAdAllLoaded,
      this.onVideoPlayStart,
      this.onVideoPlayEnd,
      this.onDownloadStart,
      this.onDownloadUpdate,
      this.onDownloadPause,
      this.onDownloadFinish,
      this.onDownloadFail,
      this.onInstall});
}
