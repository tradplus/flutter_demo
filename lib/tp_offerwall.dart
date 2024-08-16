import 'package:tradplus_sdk/tradplus_sdk.dart';

final TPOfferWallManager = TPOfferwall();

class TPOfferwall {
  ///构建ExtraMap，isAutoLoad 是否开启自动记载 默认开启, customMap 流量分组等自定义数据
  Map createOfferwallExtraMap({
    Map? customMap, //流量分组Map
    Map? localParams, //客户设置特殊参数数据
    bool openAutoLoadCallback = false,
    double maxWaitTime = 0,
  }) {
    Map extraMap = {};
    if (localParams != null) {
      extraMap['localParams'] = localParams;
    }

    if (customMap != null) {
      extraMap['customMap'] = customMap;
    }
    extraMap['openAutoLoadCallback'] = openAutoLoadCallback;
    extraMap['maxWaitTime'] = maxWaitTime;
    return extraMap;
  }

  ///加载广告：adUnitId 广告位ID, extraMap = createOfferwallExtraMap
  Future<void> loadOfferwallAd(String adUnitId, {Map? extraMap}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if (extraMap != null) {
      arguments['extraMap'] = extraMap;
    }
    TradplusSdk.channel.invokeMethod('offerwall_load', arguments);
  }

  ///广告是否ready：adUnitId 广告位ID
  Future<bool> offerwallAdReady(String adUnitId) async {
    return await TradplusSdk.channel
        .invokeMethod('offerwall_ready', {'adUnitID': adUnitId});
  }

  ///展示广告：adUnitId 广告位ID ,sceneId 从Tradplus后台获取到到场景ID
  Future<void> showOfferwallAd(String adUnitId, {String? sceneId}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if (sceneId != null) {
      arguments['sceneId'] = sceneId;
    }
    TradplusSdk.channel.invokeMethod('offerwall_show', arguments);
  }

  ///进入广告场景：adUnitId 广告位ID ,sceneId 从Tradplus后台获取到到场景ID
  Future<void> entryOfferwallAdScenario(String adUnitId,
      {String? sceneId}) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if (sceneId != null) {
      arguments['sceneId'] = sceneId;
    }
    TradplusSdk.channel.invokeMethod('offerwall_entryAdScenario', arguments);
  }

  ///设置用户ID
  Future<void> setUserId(String adUnitId, String userId) async {
    TradplusSdk.channel.invokeMethod(
        'offerwall_setUserId', {'adUnitID': adUnitId, 'userId': userId});
  }

  ///查询当前用户积分墙积分：adUnitId 广告位ID
  Future<void> getCurrencyBalance(String adUnitId) async {
    TradplusSdk.channel
        .invokeMethod('offerwall_currency', {'adUnitID': adUnitId});
  }

  ///扣除用户积分墙积分：adUnitId 广告位ID,count 扣除的数量
  Future<void> spendBalance(String adUnitId, int count) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    arguments['count'] = count;
    TradplusSdk.channel.invokeMethod('offerwall_spend', arguments);
  }

  ///添加用户积分墙积分：adUnitId 广告位ID,count 添加的数量
  Future<void> awardBalance(String adUnitId, int count) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    arguments['count'] = count;
    TradplusSdk.channel.invokeMethod('offerwall_award', arguments);
  }

  ///开发者通过此接口在展示前设置透传信息，透传信息可以在广告展示后的相关回调的adInfo中获取
  Future<void> setCustomAdInfo(String adUnitId, Map customAdInfo) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    arguments['customAdInfo'] = customAdInfo;
    TradplusSdk.channel.invokeMethod('offerwall_setCustomAdInfo', arguments);
  }

  ///设置广告Listener：adUnitId 设置后只返回指定广告位相关回调（可选）
  setOfferwallListener(TPOfferwallAdListener listener, {String adUnitId = ""}) {
    if (adUnitId.isNotEmpty) {
      TPListenerManager.offerwallAdListenerMap[adUnitId] = listener;
    } else {
      TPListenerManager.offerwallAdListener = listener;
    }
  }

  callback(TPOfferwallAdListener listener, String adUnitId, String method,
      Map arguments) {
    Map adInfo = {};
    if (arguments.containsKey("adInfo")) {
      adInfo = arguments['adInfo'];
    }
    Map error = {};
    if (arguments.containsKey("adError")) {
      error = arguments['adError'];
    }
    if (method == 'offerwall_loaded') {
      listener.onAdLoaded(adUnitId, adInfo);
    } else if (method == 'offerwall_loadFailed') {
      listener.onAdLoadFailed(adUnitId, error);
    } else if (method == 'offerwall_impression') {
      listener.onAdImpression(adUnitId, adInfo);
    } else if (method == 'offerwall_showFailed') {
      listener.onAdShowFailed(adUnitId, adInfo, error);
    } else if (method == 'offerwall_clicked') {
      listener.onAdClicked(adUnitId, adInfo);
    } else if (method == 'offerwall_closed') {
      listener.onAdClosed(adUnitId, adInfo);
    } else if (method == 'offerwall_startLoad') {
      listener.onAdStartLoad!(adUnitId, adInfo);
    } else if (method == 'offerwall_oneLayerStartLoad') {
      listener.oneLayerStartLoad!(adUnitId, adInfo);
    } else if (method == 'offerwall_bidStart') {
      listener.onBiddingStart!(adUnitId, adInfo);
    } else if (method == 'offerwall_bidEnd') {
      listener.onBiddingEnd!(adUnitId, adInfo, error);
    } else if (method == 'offerwall_isLoading') {
      listener.onAdIsLoading!(adUnitId);
    } else if (method == 'offerwall_oneLayerLoaded') {
      listener.oneLayerLoaded!(adUnitId, adInfo);
    } else if (method == 'offerwall_oneLayerLoadedFail') {
      listener.oneLayerLoadFailed(adUnitId, adInfo, error);
    } else if (method == 'offerwall_allLoaded') {
      bool isSuccess = arguments["success"];
      listener.onAdAllLoaded!(adUnitId, isSuccess);
    } else if (method == 'offerwall_playStart') {
      listener.onVideoPlayStart!(adUnitId, adInfo);
    } else if (method == 'offerwall_playEnd') {
      listener.onVideoPlayEnd!(adUnitId, adInfo);
    } else if (method == 'offerwall_currency_success') {
      int amount = arguments["amount"];
      String msg = arguments["msg"];
      listener.currencyBalanceSuccess!(adUnitId, amount, msg);
    } else if (method == 'offerwall_currency_failed') {
      String msg = arguments["msg"];
      listener.currencyBalanceFailed!(adUnitId, msg);
    } else if (method == 'offerwall_spend_success') {
      int amount = arguments["amount"];
      String msg = arguments["msg"];
      listener.spendCurrencySuccess!(adUnitId, amount, msg);
    } else if (method == 'offerwall_spend_failed') {
      String msg = arguments["msg"];
      listener.spendCurrencyFailed!(adUnitId, msg);
    } else if (method == 'offerwall_award_success') {
      int amount = arguments["amount"];
      String msg = arguments["msg"];
      listener.awardCurrencySuccess!(adUnitId, amount, msg);
    } else if (method == 'offerwall_award_failed') {
      String msg = arguments["msg"];
      listener.awardCurrencyFailed!(adUnitId, msg);
    } else if (method == 'offerwall_setUserIdFinish') {
      bool isSuccess = arguments["success"];
      listener.setUserIdFinish!(adUnitId, isSuccess);
    }
  }
}

class TPOfferwallAdListener {
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
  final Function(String adUnitId, String msg)? awardCurrencyFailed;
  final Function(String adUnitId, int amount, String msg)? awardCurrencySuccess;
  final Function(String adUnitId, String msg)? spendCurrencyFailed;
  final Function(String adUnitId, int amount, String msg)? spendCurrencySuccess;
  final Function(String adUnitId, String msg)? currencyBalanceFailed;
  final Function(String adUnitId, int amount, String msg)?
      currencyBalanceSuccess;
  final Function(String adUnitId, bool isSuccess)? setUserIdFinish;
  const TPOfferwallAdListener({
    required this.onAdLoaded,
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
    this.onVideoPlayStart,
    this.onVideoPlayEnd,
    this.currencyBalanceSuccess,
    this.currencyBalanceFailed,
    this.spendCurrencySuccess,
    this.spendCurrencyFailed,
    this.awardCurrencySuccess,
    this.awardCurrencyFailed,
    this.setUserIdFinish,
  });
}
