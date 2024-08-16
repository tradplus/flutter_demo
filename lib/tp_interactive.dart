import 'package:tradplus_sdk/tradplus_sdk.dart';

final TPInteractiveManager = TPInterActive();

class TPInterActive {
  Map createInterActiveExtraMap({
    double height = 0, //高度
    double width = 0, //宽度
    Map? customMap, //流量分组Map
    String? sceneId, //场景ID
    Map? localParams, //客户设置特殊参数数据
    bool openAutoLoadCallback = false,
    double maxWaitTime = 0,
  }) {
    Map extraMap = {};
    extraMap['height'] = height;
    extraMap['width'] = width;
    if (localParams != null) {
      extraMap['localParams'] = localParams;
    }
    if (customMap != null) {
      extraMap['customMap'] = customMap;
    }
    if (sceneId != null) {
      extraMap['sceneId'] = sceneId;
    }
    extraMap['openAutoLoadCallback'] = openAutoLoadCallback;
    extraMap['maxWaitTime'] = maxWaitTime;
    return extraMap;
  }

  ///加载广告：adUnitId 广告位ID, extraMap = createNativeExtraMap
  Future<void> loadInterActiveAd(String adUnitId, {Map? extraMap}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if (extraMap != null) {
      arguments['extraMap'] = extraMap;
    }
    TradplusSdk.channel.invokeMethod('interactive_load', arguments);
  }

  ///广告是否ready：adUnitId 广告位ID
  Future<bool> interActiveAdReady(String adUnitId) async {
    return await TradplusSdk.channel
        .invokeMethod('interactive_ready', {'adUnitID': adUnitId});
  }

  ///开发者通过此接口在展示前设置透传信息，透传信息可以在广告展示后的相关回调的adInfo中获取
  Future<void> setCustomAdInfo(String adUnitId, Map customAdInfo) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    arguments['customAdInfo'] = customAdInfo;
    TradplusSdk.channel.invokeMethod('interactive_setCustomAdInfo', arguments);
  }

  ///设置广告Listener：adUnitId 设置后只返回指定广告位相关回调（可选）
  setInterActiveAdListener(TPInterActiveAdListener listener,
      {String adUnitId = ""}) {
    if (adUnitId.isNotEmpty) {
      TPListenerManager.interActiveAdListenerMap[adUnitId] = listener;
    } else {
      TPListenerManager.interActiveAdListener = listener;
    }
  }

  callback(TPInterActiveAdListener listener, String adUnitId, String method,
      Map arguments) {
    Map adInfo = {};
    if (arguments.containsKey("adInfo")) {
      adInfo = arguments['adInfo'];
    }
    Map error = {};
    if (arguments.containsKey("adError")) {
      error = arguments['adError'];
    }
    if (method == 'interactive_loaded') {
      listener.onAdLoaded(adUnitId, adInfo);
    } else if (method == 'interactive_loadFailed') {
      listener.onAdLoadFailed(adUnitId, error);
    } else if (method == 'interactive_impression') {
      listener.onAdImpression(adUnitId, adInfo);
    } else if (method == 'interactive_showFailed') {
      listener.onAdShowFailed(adUnitId, adInfo, error);
    } else if (method == 'interactive_clicked') {
      listener.onAdClicked(adUnitId, adInfo);
    } else if (method == 'interactive_closed') {
      listener.onAdClosed(adUnitId, adInfo);
    } else if (method == 'interactive_startLoad') {
      listener.onAdStartLoad!(adUnitId, adInfo);
    } else if (method == 'interactive_oneLayerStartLoad') {
      listener.oneLayerStartLoad!(adUnitId, adInfo);
    } else if (method == 'interactive_bidStart') {
      listener.onBiddingStart!(adUnitId, adInfo);
    } else if (method == 'interactive_bidEnd') {
      listener.onBiddingEnd!(adUnitId, adInfo, error);
    } else if (method == 'interactive_isLoading') {
      listener.onAdIsLoading!(adUnitId);
    } else if (method == 'interactive_oneLayerLoaded') {
      listener.oneLayerLoaded!(adUnitId, adInfo);
    } else if (method == 'interactive_oneLayerLoadedFail') {
      listener.oneLayerLoadFailed(adUnitId, adInfo, error);
    } else if (method == 'interactive_allLoaded') {
      bool isSuccess = arguments["success"];
      listener.onAdAllLoaded!(adUnitId, isSuccess);
    } else if (method == 'interactive_playStart') {
      listener.onVideoPlayStart!(adUnitId, adInfo);
    } else if (method == 'interactive_playEnd') {
      listener.onVideoPlayEnd!(adUnitId, adInfo);
    }
  }
}

class TPInterActiveAdListener {
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

  const TPInterActiveAdListener(
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
      this.onVideoPlayEnd});
}
