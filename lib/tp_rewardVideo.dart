import 'package:tradplus_sdk/tradplus_sdk.dart';


final TPRewardVideoManager = TPRewardVideo();

class TPRewardVideo
{
  ///构建ExtraMap：isAutoLoad 是否开启自动记载 默认开启, customMap 流量分组等自定义数据
  ///userId customData 服务器奖励验证参数， 使用服务器奖励验证时 userId 必填
  Map createRewardVideoExtraMap({
        String? userId, //服务器奖励验证参数，如使用服务器奖励验证时此参数必填
        String? customData,//服务器奖励验证参数
        Map? localParams,//客户设置特殊参数数据
        Map? customMap,//流量分组Map
   }) {

    Map extraMap = {};
    if(localParams != null) {
      extraMap['localParams'] = localParams;
    }

    if(userId != null)
    {
      extraMap['userId'] = userId;
    }

    if(customData != null)
    {
      extraMap['customData'] = customData;
    }

    if(customMap != null)
    {
      extraMap['customMap'] = customMap;
    }
    return extraMap;
  }

  ///加载广告：adUnitId 广告位ID, extraMap = createRewardVideoExtraMap
  Future<void> loadRewardVideoAd(String adUnitId,{Map? extraMap}) async{
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if(extraMap != null)
    {
      arguments['extraMap'] = extraMap;
    }
    TradplusSdk.channel.invokeMethod('rewardVideo_load', arguments);
  }

  ///广告是否ready：adUnitId 广告位ID
  Future<bool> rewardVideoAdReady(String adUnitId) async{
    return await TradplusSdk.channel.invokeMethod('rewardVideo_ready', {
      'adUnitID': adUnitId
    });
  }

  ///展示广告：adUnitId 广告位ID ,sceneId 从Tradplus后台获取到到场景ID
  Future<void> showRewardVideoAd(String adUnitId,{String? sceneId}) async{
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if(sceneId != null)
    {
      arguments['sceneId'] = sceneId;
    }
    TradplusSdk.channel.invokeMethod('rewardVideo_show', arguments);
  }

  ///进入广告场景：adUnitId 广告位ID ,sceneId 从Tradplus后台获取到到场景ID
  Future<void> entryRewardVideoAdScenario(String adUnitId,{String? sceneId}) async{
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    if(sceneId != null)
    {
      arguments['sceneId'] = sceneId;
    }
    TradplusSdk.channel.invokeMethod('rewardVideo_entryAdScenario', arguments);
  }

  ///开发者通过此接口在展示前设置透传信息，透传信息可以在广告展示后的相关回调的adInfo中获取
  Future<void> setCustomAdInfo(String adUnitId,Map customAdInfo) async {
    Map arguments = {};
    arguments['adUnitID'] = adUnitId;
    arguments['customAdInfo'] = customAdInfo;
    TradplusSdk.channel.invokeMethod('rewardVideo_setCustomAdInfo', arguments);
  }

  ///设置广告Listener：adUnitId 设置后只返回指定广告位相关回调（可选）
  setRewardVideoListener(TPRewardVideoAdListener listener,{String adUnitId = ""})
  {
    if(adUnitId.isNotEmpty)
    {
      TPListenerManager.rewardVideoAdListenerMap[adUnitId] = listener;
    }
    else
    {
      TPListenerManager.rewardVideoAdListener = listener;
    }
  }

  callback(TPRewardVideoAdListener listener,String adUnitId,String method,Map arguments)
  {
    Map adInfo = {};
    if(arguments.containsKey("adInfo"))
    {
      adInfo = arguments['adInfo'];
    }
    Map error = {};
    if(arguments.containsKey("adError"))
    {
      error = arguments['adError'];
    }
    if(method == 'rewardVideo_loaded')
    {
      listener.onAdLoaded(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_loadFailed')
    {
      listener.onAdLoadFailed(adUnitId,error);
    }
    else if(method == 'rewardVideo_impression')
    {
      listener.onAdImpression(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_showFailed')
    {
      listener.onAdShowFailed(adUnitId,adInfo,error);
    }
    else if(method == 'rewardVideo_clicked')
    {
      listener.onAdClicked(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_closed')
    {
      listener.onAdClosed(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_startLoad')
    {
      listener.onAdStartLoad!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_oneLayerStartLoad')
    {
      listener.oneLayerStartLoad!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_bidStart')
    {
      listener.onBiddingStart!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_bidEnd')
    {
      listener.onBiddingEnd!(adUnitId,adInfo,error);
    }
    else if(method == 'rewardVideo_isLoading')
    {
      listener.onAdIsLoading!(adUnitId);
    }
    else if(method == 'rewardVideo_oneLayerLoaded')
    {
      listener.oneLayerLoaded!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_oneLayerLoadedFail')
    {
      listener.oneLayerLoadFailed(adUnitId,adInfo,error);
    }
    else if(method == 'rewardVideo_rewarded')
    {
      listener.onAdReward(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_allLoaded')
    {
      bool isSuccess = arguments["success"];
      listener.onAdAllLoaded!(adUnitId,isSuccess);
    }
    else if(method == 'rewardVideo_playStart')
    {
      listener.onVideoPlayStart!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_playEnd')
    {
      listener.onVideoPlayEnd!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_playAgain_impression')
    {
      listener.onPlayAgainImpression!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_playAgain_clicked')
    {
      listener.onPlayAgainClicked!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_playAgain_rewarded')
    {
      listener.onPlayAgainReward!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_playAgain_playStart')
    {
      listener.onPlayAgainVideoPlayStart!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_playAgain_playEnd')
    {
      listener.onPlayAgainVideoPlayEnd!(adUnitId,adInfo);
    }
    else if(method == 'rewardVideo_downloadstart')
    {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadStart!(adUnitId,l,l1,s,s1);
    }
    else if(method == 'rewardVideo_downloadupdate')
    {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      int i = arguments["p"];
      listener.onDownloadUpdate!(adUnitId,l,l1,s,s1,i);
    }
    else if(method == 'rewardVideo_downloadpause')
    {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadPause!(adUnitId,l,l1,s,s1);
    }
    else if(method == 'rewardVideo_downloadfinish')
    {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadFinish!(adUnitId,l,l1,s,s1);
    }
    else if(method == 'rewardVideo_downloadfail')
    {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onDownloadFail!(adUnitId,l,l1,s,s1);
    }
    else if(method == 'rewardVideo_downloadinstall')
    {
      num l = arguments["l"];
      num l1 = arguments["l1"];
      String s = arguments["s"];
      String s1 = arguments["s1"];
      listener.onInstall!(adUnitId,l,l1,s,s1);
    }
    //playAgain_clicked
  }
}

class TPRewardVideoAdListener
{
  final Function(String adUnitId, Map adInfo) onAdLoaded;
  final Function(String adUnitId, Map error) onAdLoadFailed;
  final Function(String adUnitId, Map adInfo) onAdImpression;
  final Function(String adUnitId, Map adInfo,Map error) onAdShowFailed;
  final Function(String adUnitId, Map adInfo) onAdClicked;
  final Function(String adUnitId, Map adInfo) onAdClosed;
  final Function(String adUnitId, Map adInfo) onAdReward;
  final Function(String adUnitId, Map adInfo,Map error) oneLayerLoadFailed;
  final Function(String adUnitId, Map adInfo)? onAdStartLoad;
  final Function(String adUnitId, Map adInfo)? onBiddingStart;
  final Function(String adUnitId, Map adInfo,Map error)? onBiddingEnd;
  final Function(String adUnitId)? onAdIsLoading;
  final Function(String adUnitId, Map adInfo)? oneLayerStartLoad;
  final Function(String adUnitId, Map adInfo)? oneLayerLoaded;
  final Function(String adUnitId, Map adInfo)? onVideoPlayStart;
  final Function(String adUnitId, Map adInfo)? onVideoPlayEnd;
  final Function(String adUnitId, bool isSuccess)? onAdAllLoaded;
  //国内再看一个 回调
  final Function(String adUnitId, Map adInfo)? onPlayAgainImpression;
  final Function(String adUnitId, Map adInfo)? onPlayAgainReward;
  final Function(String adUnitId, Map adInfo)? onPlayAgainClicked;
  final Function(String adUnitId, Map adInfo)? onPlayAgainVideoPlayStart;
  final Function(String adUnitId, Map adInfo)? onPlayAgainVideoPlayEnd;
  //android only 下载回调
  final Function(String adUnitId, num totalBytes,num currBytes,String fileName,String appName)? onDownloadStart;
  final Function(String adUnitId, num totalBytes,num currBytes,String fileName,String appName,int progress)? onDownloadUpdate;
  final Function(String adUnitId, num totalBytes,num currBytes,String fileName,String appName)? onDownloadPause;
  final Function(String adUnitId, num totalBytes,num currBytes,String fileName,String appName)? onDownloadFinish;
  final Function(String adUnitId, num totalBytes,num currBytes,String fileName,String appName)? onDownloadFail;
  final Function(String adUnitId, num totalBytes,num currBytes,String fileName,String appName)? onInstall;
  const TPRewardVideoAdListener({
    required this.onAdLoaded,
    required this.onAdLoadFailed,
    required this.onAdImpression,
    required this.onAdShowFailed,
    required this.onAdClicked,
    required this.onAdClosed,
    required this.onAdReward,
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
    this.onPlayAgainImpression,
    this.onPlayAgainReward,
    this.onPlayAgainClicked,
    this.onPlayAgainVideoPlayStart,
    this.onPlayAgainVideoPlayEnd,
    this.onDownloadStart,
    this.onDownloadUpdate,
    this.onDownloadPause,
    this.onDownloadFinish,
    this.onDownloadFail,
    this.onInstall
  });
}