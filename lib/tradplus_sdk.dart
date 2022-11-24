export 'package:tradplus_sdk/tp_native.dart';
export 'package:tradplus_sdk/tp_native_view.dart';
export 'package:tradplus_sdk/tp_interstitial.dart';
export 'package:tradplus_sdk/tp_rewardVideo.dart';
export 'package:tradplus_sdk/tp_banner.dart';
export 'package:tradplus_sdk/tp_banner_view.dart';
export 'package:tradplus_sdk/tp_splash.dart';
export 'package:tradplus_sdk/tp_offerwall.dart';
export 'package:tradplus_sdk/tp_splash_view.dart';
export 'package:tradplus_sdk/tp_listener.dart';

import 'package:tradplus_sdk/tp_listener.dart';
import 'package:flutter/services.dart';

final TPSDKManager = TradplusSdk();

class TradplusSdk {
  static MethodChannel channel = const MethodChannel('tradplus_sdk');

  ///TradplusSDK 设置删除数据库最大限制数
  Future<void> setMaxDatabaseSize(num size) async{
    Map arguments = {};
    arguments['size'] = size;
    TradplusSdk.channel.invokeMethod('tp_setMaxDatabaseSize',arguments);
  }
  ///TradplusSDK 获取地区api
  Future<void> checkCurrentArea() async{
    TradplusSdk.channel.invokeMethod('tp_checkCurrentArea');
  }

  ///TradplusSDK 初始化 传入 appId
  Future<void> init(String appId) async{
    Map arguments = {};
    arguments['appId'] = appId;
    TradplusSdk.channel.invokeMethod('tp_init', arguments);
  }

  ///设置流量分组等自定数据，需要在初始化前设置
  Future<void> setCustomMap(Map customMap) async{
    Map arguments = {};
    arguments['customMap'] = customMap;
    TradplusSdk.channel.invokeMethod('tp_setCustomMap', arguments);
  }

  ///设置初始化监听
  setInitListener(TPInitListener listener)
  {
    TPListenerManager.initListener = listener;
  }

  setGlobalAdImpressionListener(TPGlobalAdImpressionListener listener)
  {
    TradplusSdk.channel.invokeMethod('tp_addGlobalAdImpressionListener');
    TPListenerManager.globalAdImpressionListener = listener;
  }

  ///获取 TradplusSDK 版本号
  Future<String> version() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_version');
  }

  //android 国内隐私权限开关
  Future<bool>isPrivacyUserAgree() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_isPrivacyUserAgree');
  }


  ///设置 是否是测试设备: ture 是, false 否 ，仅支持 android
  Future<void>setPrivacyUserAgree(bool open) async
  {
    Map arguments = {};
    arguments['open'] = open;
    TradplusSdk.channel.invokeMethod('tp_setPrivacyUserAgree',arguments);
  }


  ///是否在欧盟地区 需要在初始化成功后调用
  Future<bool>isEUTraffic() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_isEUTraffic');
  }


  ///是否在加州地区 需要在初始化成功后调用
  Future<bool>isCalifornia() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_isCalifornia');
  }

  ///设置 是否是测试设备: ture 是, false 否 ，仅支持 android
  Future<void>setTestDevice(bool testDevice,{String? testModeId}) async
  {
    Map arguments = {};
    arguments['testDevice'] = testDevice;
    if(testModeId != null) {
      arguments['testModeId'] = testModeId;
    }
    TradplusSdk.channel.invokeMethod('tp_setTestDevice',arguments);
  }

  ///设置 GDPR等级 是否允许数据上报: ture 设备数据允许上报, false 设备数据不允许上报
  Future<void>setGDPRDataCollection(bool canDataCollection) async
  {
    Map arguments = {};
    arguments['canDataCollection'] = canDataCollection;
    TradplusSdk.channel.invokeMethod('tp_setGDPRDataCollection',arguments);
  }

  /// 获取当前 GDPR等级：  0 允许上报 , 1 不允许上报, 2 未设置
  Future<int>getGDPRDataCollection() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_getGDPRDataCollection');
  }

  ///设置 LGPD等级 是否允许数据上报: ture 设备数据允许上报, false 设备数据不允许上报
  Future<void>setLGPDDataCollection(bool canDataCollection) async
  {
    Map arguments = {};
    arguments['canDataCollection'] = canDataCollection;
    TradplusSdk.channel.invokeMethod('tp_setLGPDConsent',arguments);
  }

  /// 获取当前 LGPD等级：  0 允许上报 , 1 不允许上报, 2 未设置
  Future<int>getLGPDDataCollection() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_getLGPDConsent');
  }

  ///设置 CCPA等级 是否允许数据上报: ture 加州用户接受上报数据, false 加州用户均不上报数据
  Future<void>setCCPADoNotSell(bool canDataCollection) async
  {
    Map arguments = {};
    arguments['canDataCollection'] = canDataCollection;
    TradplusSdk.channel.invokeMethod('tp_setCCPADoNotSell',arguments);
  }

  /// 获取当前 CCPA等级： 0 允许上报 , 1 不允许上报, 2 未设置
  Future<int>getCCPADoNotSell() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_getCCPADoNotSell');
  }

  ///设置 COPPA等级 是否允许数据上报: ture 表明儿童, false 表明不是儿童
  Future<void>setCOPPAIsAgeRestrictedUser(bool isChild) async
  {
    Map arguments = {};
    arguments['isChild'] = isChild;
    TradplusSdk.channel.invokeMethod('tp_setCOPPAIsAgeRestrictedUser',arguments);
  }

  /// 获取当前 COPPA等级： 0 表明儿童 , 1 表明不是儿童, 2 未设置
  Future<int>getCOPPAIsAgeRestrictedUser() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_getCOPPAIsAgeRestrictedUser');
  }

  ///TradplusSDK GDPR隐私授权页面
  Future<void>showGDPRDialog() async
  {
    TradplusSdk.channel.invokeMethod('tp_showGDPRDialog');
  }

  ///设置是否开启个性化推荐广告。 false 关闭 ，true 开启。SDK默认 true 开启
  Future<void>setOpenPersonalizedAd(bool open) async
  {
    Map arguments = {};
    arguments['open'] = open;
    TradplusSdk.channel.invokeMethod('tp_setOpenPersonalizedAd',arguments);
  }

  ///当前的个性化状态  false 关闭 ，true 开启
  Future<bool>isOpenPersonalizedAd() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_isOpenPersonalizedAd');
  }

  ///设置是否第一次show GDPR弹框, 仅支持 android
  Future<void>setFirstShowGDPR(bool first) async
  {
    Map arguments = {};
    arguments['first'] = first;
    TradplusSdk.channel.invokeMethod('tp_setFirstShowGDPR',arguments);
  }

  ///获取是否是第一次show GDPR弹框 true 是，false 否,仅支持 android
  Future<bool>isFirstShowGDPR() async
  {
    return await TradplusSdk.channel.invokeMethod('tp_isFirstShowGDPR');
  }

  ///清理指定广告位下的广告缓存，一般使用场景：用于切换用户后清除激励视频的缓存广告
  Future<void>clearCache(String adUnitId) async
  {
    Map arguments = {};
    arguments['adUnitId'] = adUnitId;
    TradplusSdk.channel.invokeMethod('tp_clearCache',arguments);
  }

  ///设置 是否开启close后自动加载delay 2S: ture 是, false 否
  Future<void>setOpenDelayLoadAds(bool isOpen) async
  {
    Map arguments = {};
    arguments['isOpen'] = isOpen;
    TradplusSdk.channel.invokeMethod('tp_setOpenDelayLoadAds',arguments);
  }

  globalAdImpressionCallback(TPGlobalAdImpressionListener listener,String method,Map arguments)
  {
    Map adInfo = {};
    if (arguments.containsKey("adInfo"))
    {
      adInfo = arguments['adInfo'];
    }
    listener.onGlobalAdImpression(adInfo);
  }

  callback(TPInitListener listener,String method,Map arguments)
  {
    if(method == 'tp_initFinish')
    {
      bool success = false;
      if(arguments.containsKey("success"))
      {
        success = arguments["success"];
      }
      listener.initFinish!(success);
    }
    else if(method == 'tp_dialogClosed')
    {
      int level = 0;
      if(arguments.containsKey("level"))
      {
        level = arguments["level"];
      }
      listener.dialogClosed!(level);
    }
    else if(method == 'tp_gdpr_success')
    {
      String msg = arguments["msg"];
      listener.gdprSuccess!(msg);
    }
    else if(method == 'tp_gdpr_failed')
    {
      String msg = arguments["msg"];
      listener.gdprFailed!(msg);
    }else if(method == 'tp_currentarea_success')
    {
      bool isEu = arguments["iseu"];
      bool isCn = arguments["iscn"];
      bool isCa = arguments["isca"];
      listener.currentAreaSuccess!(isEu,isCn,isCa);
    }else if(method == 'tp_currentarea_failed')
    {
      listener.currentAreaFailed!();
    }
  }
}

class TPInitListener
{
  final Function(bool success)? initFinish;
  //iOS level固定为0，只做为关闭回调
  final Function(int level)? dialogClosed;
  //android 支持
  final Function(String msg)? gdprSuccess;
  //android 支持
  final Function(String msg)? gdprFailed;
  final Function(bool isEu,bool isCn,bool isCa)? currentAreaSuccess;
  final Function? currentAreaFailed;
  const TPInitListener({
    this.initFinish,
    this.dialogClosed,
    this.gdprSuccess,
    this.gdprFailed,
    this.currentAreaSuccess,
    this.currentAreaFailed,
  });
}

class TPGlobalAdImpressionListener
{
  final Function(Map adInfo) onGlobalAdImpression;

  const TPGlobalAdImpressionListener(
      {
        required this.onGlobalAdImpression
      });
}