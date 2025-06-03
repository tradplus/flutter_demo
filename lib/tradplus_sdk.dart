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
export 'package:tradplus_sdk/tp_interactive.dart';
export 'package:tradplus_sdk/tp_interactive_view.dart';
export 'package:tradplus_sdk/ttd_uid2.dart';
import 'package:tradplus_sdk/tp_listener.dart';
import 'package:flutter/services.dart';

final TPSDKManager = TradplusSdk();

class TradplusSdk {
  static MethodChannel channel = const MethodChannel('tradplus_sdk');

  /// TPPAGPAConsentType.Consent 填充
  /// TPPAGPAConsentType.NoConsent 不填充
  /// 设置 Pangle 是否填充广告 （PangleSDK V7.1+）
  Future<void> setPAConsent(int consentType) async {
    Map arguments = {};
    arguments['consentType'] = consentType;
    TradplusSdk.channel.invokeMethod('tp_setPAConsent', arguments);
  }

  ///TradplusSDK 设置自定义测试ID 配置后台测试模式使用
  Future<void> setCustomTestID(String customTestID) async {
    Map arguments = {};
    arguments['customTestID'] = customTestID;
    TradplusSdk.channel.invokeMethod('tp_setCustomTestID', arguments);
  }

  ///TradplusSDK 设置删除数据库最大限制数
  Future<void> setMaxDatabaseSize(num size) async {
    Map arguments = {};
    arguments['size'] = size;
    TradplusSdk.channel.invokeMethod('tp_setMaxDatabaseSize', arguments);
  }

  ///TradplusSDK 获取地区api
  Future<void> checkCurrentArea() async {
    TradplusSdk.channel.invokeMethod('tp_checkCurrentArea');
  }

  ///设置指定广告平台展示频限次数 可配合TPPlatformLimit 使用
  Future<void> setPlatformLimit(List<Map> list) async {
    TradplusSdk.channel.invokeMethod('tp_setPlatformLimit', list);
  }

  ///TradplusSDK 初始化 传入 appId
  Future<void> init(String appId) async {
    Map arguments = {};
    arguments['appId'] = appId;
    TradplusSdk.channel.invokeMethod('tp_init', arguments);
  }

  ///设置流量分组等自定数据，需要在初始化前设置
  Future<void> setCustomMap(Map customMap) async {
    Map arguments = {};
    arguments['customMap'] = customMap;
    TradplusSdk.channel.invokeMethod('tp_setCustomMap', arguments);
  }

  ///设置流量分组等自定数据，需要在初始化前设置
  Future<void> setSettingDataParam(Map settingMap) async {
    Map arguments = {};
    arguments['setting'] = settingMap;
    TradplusSdk.channel.invokeMethod('tp_setSettingDataParam', arguments);
  }

  ///设置预配置 adUnitId 广告位ID config 从TP后台导出的预配置（base64格式）
  Future<void> setDefaultConfig(String adUnitId,String config) async {
    Map arguments = {};
    arguments['adUnitId'] = adUnitId;
    arguments['config'] = config;
    TradplusSdk.channel.invokeMethod('tp_setDefaultConfig', arguments);
  }

  ///设置初始化监听
  setInitListener(TPInitListener listener) {
    TPListenerManager.initListener = listener;
  }

  setGlobalAdImpressionListener(TPGlobalAdImpressionListener listener) {
    TradplusSdk.channel.invokeMethod('tp_addGlobalAdImpressionListener');
    TPListenerManager.globalAdImpressionListener = listener;
  }

  ///获取 TradplusSDK 版本号
  Future<String> version() async {
    return await TradplusSdk.channel.invokeMethod('tp_version');
  }

  //android 国内隐私权限开关
  Future<bool> isPrivacyUserAgree() async {
    return await TradplusSdk.channel.invokeMethod('tp_isPrivacyUserAgree');
  }

  ///设置 是否是测试设备: ture 是, false 否 ，仅支持 android
  Future<void> setPrivacyUserAgree(bool open) async {
    Map arguments = {};
    arguments['open'] = open;
    TradplusSdk.channel.invokeMethod('tp_setPrivacyUserAgree', arguments);
  }

  ///是否在欧盟地区 需要在初始化成功后调用
  Future<bool> isEUTraffic() async {
    return await TradplusSdk.channel.invokeMethod('tp_isEUTraffic');
  }

  ///是否在加州地区 需要在初始化成功后调用
  Future<bool> isCalifornia() async {
    return await TradplusSdk.channel.invokeMethod('tp_isCalifornia');
  }

  ///设置 GDPR等级 是否允许数据上报: ture 设备数据允许上报, false 设备数据不允许上报
  Future<void> setGDPRDataCollection(bool canDataCollection) async {
    Map arguments = {};
    arguments['canDataCollection'] = canDataCollection;
    TradplusSdk.channel.invokeMethod('tp_setGDPRDataCollection', arguments);
  }

  /// 获取当前 GDPR等级：  0 允许上报 , 1 不允许上报, 2 未设置
  Future<int> getGDPRDataCollection() async {
    return await TradplusSdk.channel.invokeMethod('tp_getGDPRDataCollection');
  }

  ///设置 LGPD等级 是否允许数据上报: ture 设备数据允许上报, false 设备数据不允许上报
  Future<void> setLGPDDataCollection(bool canDataCollection) async {
    Map arguments = {};
    arguments['canDataCollection'] = canDataCollection;
    TradplusSdk.channel.invokeMethod('tp_setLGPDConsent', arguments);
  }

  /// 获取当前 LGPD等级：  0 允许上报 , 1 不允许上报, 2 未设置
  Future<int> getLGPDDataCollection() async {
    return await TradplusSdk.channel.invokeMethod('tp_getLGPDConsent');
  }

  ///设置 CCPA等级 是否允许数据上报: ture 加州用户接受上报数据, false 加州用户均不上报数据
  Future<void> setCCPADoNotSell(bool canDataCollection) async {
    Map arguments = {};
    arguments['canDataCollection'] = canDataCollection;
    TradplusSdk.channel.invokeMethod('tp_setCCPADoNotSell', arguments);
  }

  /// 获取当前 CCPA等级： 0 允许上报 , 1 不允许上报, 2 未设置
  Future<int> getCCPADoNotSell() async {
    return await TradplusSdk.channel.invokeMethod('tp_getCCPADoNotSell');
  }

  ///设置 COPPA等级 是否允许数据上报: ture 表明儿童, false 表明不是儿童
  Future<void> setCOPPAIsAgeRestrictedUser(bool isChild) async {
    Map arguments = {};
    arguments['isChild'] = isChild;
    TradplusSdk.channel
        .invokeMethod('tp_setCOPPAIsAgeRestrictedUser', arguments);
  }

  /// 获取当前 COPPA等级： 0 表明儿童 , 1 表明不是儿童, 2 未设置
  Future<int> getCOPPAIsAgeRestrictedUser() async {
    return await TradplusSdk.channel
        .invokeMethod('tp_getCOPPAIsAgeRestrictedUser');
  }

  ///设置是否开启个性化推荐广告。 false 关闭 ，true 开启。SDK默认 true 开启
  Future<void> setOpenPersonalizedAd(bool open) async {
    Map arguments = {};
    arguments['open'] = open;
    TradplusSdk.channel.invokeMethod('tp_setOpenPersonalizedAd', arguments);
  }

  ///当前的个性化状态  false 关闭 ，true 开启
  Future<bool> isOpenPersonalizedAd() async {
    return await TradplusSdk.channel.invokeMethod('tp_isOpenPersonalizedAd');
  }

  ///调用测试工具 传入 appId
  ///集成参考
  ///iOS https://docs.tradplusad.com/docs/integration_ios/sdk_test_android/test_tool/
  ///android https://docs.tradplusad.com/docs/tradplussdk_android_doc_v6/sdk_test_android/test_tool
  Future<void> openTradPlusTool(String appId) async {
    Map arguments = {};
    arguments['appId'] = appId;
    return await TradplusSdk.channel
        .invokeMethod('tp_openTradPlusTool', arguments);
  }

  ///清理指定广告位下的广告缓存，一般使用场景：用于切换用户后清除激励视频的缓存广告
  Future<void> clearCache(String adUnitId) async {
    Map arguments = {};
    arguments['adUnitId'] = adUnitId;
    TradplusSdk.channel.invokeMethod('tp_clearCache', arguments);
  }

  ///设置 是否开启close后自动加载delay 2S: ture 是, false 否
  Future<void> setOpenDelayLoadAds(bool isOpen) async {
    Map arguments = {};
    arguments['isOpen'] = isOpen;
    TradplusSdk.channel.invokeMethod('tp_setOpenDelayLoadAds', arguments);
  }

  globalAdImpressionCallback(
      TPGlobalAdImpressionListener listener, String method, Map arguments) {
    Map adInfo = {};
    if (arguments.containsKey("adInfo")) {
      adInfo = arguments['adInfo'];
    }
    listener.onGlobalAdImpression(adInfo);
  }

  callback(TPInitListener listener, String method, Map arguments) {
    if (method == 'tp_initFinish') {
      bool success = false;
      if (arguments.containsKey("success")) {
        success = arguments["success"];
      }
      listener.initFinish!(success);
    } else if (method == 'tp_currentarea_success') {
      bool isEu = arguments["iseu"];
      bool isCn = arguments["iscn"];
      bool isCa = arguments["isca"];
      listener.currentAreaSuccess!(isEu, isCn, isCa);
    } else if (method == 'tp_currentarea_failed') {
      listener.currentAreaFailed!();
    }
  }
}

class TPInitListener {
  final Function(bool success)? initFinish;
  final Function(bool isEu, bool isCn, bool isCa)? currentAreaSuccess;
  final Function? currentAreaFailed;
  const TPInitListener({
    this.initFinish,
    this.currentAreaSuccess,
    this.currentAreaFailed,
  });
}

class TPGlobalAdImpressionListener {
  final Function(Map adInfo) onGlobalAdImpression;

  const TPGlobalAdImpressionListener({required this.onGlobalAdImpression});
}

class TPPAGPAConsentType
{
  static final int NoConsent = 0;
  static final int Consent = 1;
}

class TPPlatformID
{
  static final int Meta = 1;
  static final int Admob = 2;
  static final int AdColony = 4;
  static final int UnityAds = 5;
  static final int Tapjoy = 6;
  static final int Liftoff = 7;
  static final int AppLovin = 9;
  static final int IronSource = 10;
  static final int Chartboost = 15;
  static final int TencentAds = 16;//优量汇
  static final int CSJ = 17;//穿山甲
  static final int Mintegral = 18;
  static final int Pangle = 19;
  static final int KuaishouAds = 20;
  static final int Sigmob = 21;
  static final int Inmobi = 23;
  static final int Fyber = 24;
  static final int YouDao = 25;
  static final int CrossPromotion = 27;//交叉推广
  static final int StartIO = 28;
  static final int Helium = 30;
  static final int Maio = 31;
  static final int Criteo = 32;
  static final int MyTarget = 33;
  static final int Ogury = 34;
  static final int AppNext = 35;
  static final int Kidoz = 37;
  static final int Smaato = 38;
  static final int ADX = 40;
  static final int HuaWei = 41;
  static final int Baidu = 43;//百度
  static final int Klevin = 44;//游可赢
  static final int A4G = 45;
  static final int Mimo = 46;//米盟
  static final int SuperAwesome = 47;
  static final int GoogleAdManager = 48;
  static final int Yandex = 50;
  static final int Verve = 53;
  static final int ZMaticoo = 55;
  static final int ReklamUp = 56;
  static final int Bigo = 57;
  static final int Beizi = 58;
  static final int TapTap = 63;
  static final int ONEMOB = 60;
  static final int PremiumAds = 64;
  static final int GreedyGame = 67;
  static final int AlgoriX = 68;
  static final int BeesAds = 69;
  static final int Amazon = 70;
  static final int MangoX = 71;
  static final int Sailoff = 72;
  static final int TanX = 73;//阿里妈妈
  static final int TaurusX = 74;
  static final int KwaiAds = 75;
  static final int Columbus = 76;
  static final int YSO = 77;
  static final int VivoAds = 78;
  static final int OppoAds = 79;
  static final int HONOR = 80;
}

class TPPlatformLimit
{
  var list = <Map>[];
  setLimit(int platform,int num)
  {
    list.add({"platform":platform,"num":num});
  }
}