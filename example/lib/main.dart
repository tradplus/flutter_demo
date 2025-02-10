import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'configure.dart';
import 'interstitial.dart';
import 'native.dart';
import 'rewardVideo.dart';
import 'splash.dart';
import 'banner.dart';
import 'offerwall.dart';
import 'privacy.dart';
import 'other.dart';
import 'splash_iOS.dart';
import 'interactive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var listTitle = <String>[
    "插屏",
    "激励视频",
    "横幅",
    "原生",
    "开屏",
    "积分墙",
    "隐私设置",
    "测试设置",
     "互动"
  ];
  static TPInitListener? listener;
  static TPGlobalAdImpressionListener? globalAdImpressionListener;
  String appId = TPAdConfiguration.appId;
  int itemCount = 9;

  @override
  void initState() {
    super.initState();
    if(defaultTargetPlatform == TargetPlatform.iOS)
    {
      itemCount = 8;
    }
    initTPSDK();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tradplus Demo'),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: itemCount,
            itemExtent: 90,
            itemBuilder: (BuildContext context, int index) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white70),
                onPressed: () {
                  var widget;
                  switch (index) {
                    case 0:
                      {
                        widget = InterstitialWidget();
                        break;
                      }
                    case 1:
                      {
                        widget = RewardVideoWidget();
                        break;
                      }
                    case 2:
                      {
                        widget = BannerWidget();
                        break;
                      }
                    case 3:
                      {
                        widget = NativeWidget();
                        break;
                      }
                    case 4:
                      {
                        if (defaultTargetPlatform == TargetPlatform.iOS) {
                          widget = SplashIOSWidget();
                        } else {
                          widget = SplashWidget();
                        }
                        break;
                      }
                    case 5:
                      {
                        widget = OfferWallWidget();
                        break;
                      }
                    case 6:
                      {
                        widget = PrivacyWidget();
                        break;
                      }
                    case 7:
                      {
                        widget = OtherWidget();
                        break;
                      }
                    case 8:
                      {
                        if (defaultTargetPlatform == TargetPlatform.android) {
                          widget = InterActiveWidget();
                        }
                        widget = InterActiveWidget();
                        break;
                      }
                  }
                  if (widget != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => widget),
                    );
                  }
                },
                child: Text(listTitle[index],
                    style: const TextStyle(
                      color: Colors.black,
                    )),
              );
            },
          ),
        ),
      ),
    );
  }

  initTPSDK() {
    listener = TPInitListener(initFinish: (bool finish) {
      TPAdConfiguration.showLog("sdk init finish");
    }, currentAreaSuccess: (bool isEu, bool isCn, bool isCa) {
      TPAdConfiguration.showLog(
          "sdk currentAreaSuccess isEu = $isEu,isCn = $isCn, isCa = $isCa");
      //在获取到相关地域配置后设置相关隐私API（GDPR，COPPA，CCPA等） 然后初始化SDK
    }, currentAreaFailed: () {
      TPAdConfiguration.showLog("currentAreaFailed");
      //一般为网络问题导致查询失败 不设置相关隐私API 直接初始化SDK
    });
    TPSDKManager.setInitListener(listener!);
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      Map customMap = {
        "user_id": "test_user_id",
        "user_age": 19,
        "segment_id": 1571,
        "bucket_id": 299,
        "custom_data": "TestIMP",
        "channel": "tp_channel",
        "sub_channel": "tp_sub_channel"
      };
      TPSDKManager.setCustomMap(customMap);
    } else {
      Map customMap = {
        "user_id": "test_user_id",
        "user_age": "19",
        "custom_data": "TestIMP",
        "channel": "tp_channel",
        "sub_channel": "tp_sub_channel"
      };
      TPSDKManager.setCustomMap(customMap);
    }

    TPSDKManager.checkCurrentArea();
    TPSDKManager.init(appId);

    globalAdImpressionListener = TPGlobalAdImpressionListener(
        onGlobalAdImpression: (adInfo) {
          TPAdConfiguration.showLog(
              'onGlobalAdImpression :  adInfo = $adInfo');
        });

    TPSDKManager.setGlobalAdImpressionListener(globalAdImpressionListener!);
  }
}
