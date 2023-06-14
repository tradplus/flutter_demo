
import 'package:flutter/foundation.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';

final TPAdConfiguration = AdConfiguration();

class AdConfiguration
{
  String appId = "";
  String nativeAdUnitId = "";
  String interstitialAdUnitId = "";
  String rewardVideoAdUnitId = "";
  String splashAdUnitId = "";
  String bannerAdUnitId = "";
  String offerwallAdUnitId = "";
  String interActiveAdUnitId = "";

  bool isAutoLoad = true;
  bool adCustomMap = true;
  bool testDevice = true;

  String bannerSceneId = "";
  String interstitialSceneId = "";
  String rewardVideoSceneId = "";
  String nativeSceneId = "";
  String interActiveSceneId = "";

  String showInfo ="";

  showLog(String log)
  {
    TPAdConfiguration.showInfo += "\n$log\n";
    print(log);
  }
  AdConfiguration()
  {
    if(defaultTargetPlatform == TargetPlatform.iOS)
    {
      appId = "75AA158112F1EFA29169E26AC63AFF94";
      nativeAdUnitId = "E8D198EBD7FDC4F8A725066C82D707E1";
      interstitialAdUnitId = "55F5F4147CC829BD18DB8F7E5136872E";
      rewardVideoAdUnitId = "28DF1B5D3D9F6AF3EDB2FCBC21C20EA8";
      splashAdUnitId = "E5BC6369FC7D96FD47612B279BC5AAE0";
      bannerAdUnitId = "6008C47DF1201CC875F2044E88FCD287";
      offerwallAdUnitId = "470166B2D4DEA9A7DCD3F42C5CE658B0";
      bannerSceneId = "009513B2A78F64";
      interstitialSceneId = "A54829DC948F7D";
      rewardVideoSceneId = "828F88157D28F8";
      nativeSceneId = "2D064EC9EF4106";
    }else//android
       {
      // 测试ID。正式上线需要替换
      appId = "44273068BFF4D8A8AFF3D5B11CBA3ADE";
      nativeAdUnitId = "DDBF26FBDA47FBE2765F1A089F1356BF";
      interstitialAdUnitId = "E609A0A67AF53299F2176C3A7783C46D";
      rewardVideoAdUnitId = "39DAC7EAC046676C5404004A311D1DB1";
      splashAdUnitId = "D9118E91DD06DF6D322369455CAED618";
      bannerAdUnitId = "A24091715B4FCD50C0F2039A5AF7C4BB";
      offerwallAdUnitId = "0704BA87BDE496D391E5174CDD6B5E08";
      interActiveAdUnitId = "EA55BF39C860B46B2E92B48F4C521368";
      bannerSceneId = "bannerSceneId";
      interstitialSceneId = "interstitialSceneId";//测试
      rewardVideoSceneId = "rewardVideoSceneId";//测试
      nativeSceneId = "nativeSceneId";//测试
      interActiveSceneId = "112233";
    }
  }
}

