
import 'package:flutter/foundation.dart';

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

  bool isAutoLoad = true;
  bool adCustomMap = true;
  bool testDevice = true;

  String bannerSceneId = "";
  String interstitialSceneId = "";
  String rewardVideoSceneId = "";
  String nativeSceneId = "";

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
      appId = "6640E7E3BDAC951B8F28D4C8C50E50B5";
      nativeAdUnitId = "04D8F97E539A50D52E01BA0898135E02";
      interstitialAdUnitId = "788E1FCB278B0D7E97282231154458B7";
      rewardVideoAdUnitId = "702208A872E622C1729FC621025D4B1D";
      splashAdUnitId = "BCB107DF38F83F9F1B83E849FD01A63E";
      bannerAdUnitId = "E89A890466180B9215487530A8EB519F";
      offerwallAdUnitId = "423EB7FF56537295851D3359633F0182";
      bannerSceneId = "123";
      interstitialSceneId = "345";//测试
      rewardVideoSceneId = "567";//测试
      nativeSceneId = "789";//测试
    }
  }
}

