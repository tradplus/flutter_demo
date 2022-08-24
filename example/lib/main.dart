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


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var listTitle = <String>["插屏", "激励视频", "横幅", "原生", "开屏", "积分墙", "隐私设置","测试设置"];
  static TPInitListener? listener;

  @override
  void initState() {
    super.initState();
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
            itemCount: listTitle.length,
            itemExtent: 80,
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
                        if (defaultTargetPlatform == TargetPlatform.iOS)
                        {
                          widget = SplashIOSWidget();
                        }
                        else
                        {
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

  canShowDialog() async {
    bool isEU = await TPSDKManager.isEUTraffic();
    if (isEU) {
      bool isFirst = await TPSDKManager.isFirstShowGDPR();
      if (!isFirst) {
        TPSDKManager.showGDPRDialog();
      }
    }
  }

  initTPSDK() {
    listener = TPInitListener(initFinish: (bool finish) {
      TPAdConfiguration.showLog("sdk init finish");
    }, gdprSuccess: (String msg) {
      TPAdConfiguration.showLog("gdprSuccess : msg = $msg");
      if (defaultTargetPlatform == TargetPlatform.android) {
        canShowDialog();
      }
    }, gdprFailed: (String msg) {
      TPAdConfiguration.showLog("gdprFailed : msg = $msg");
      if (defaultTargetPlatform == TargetPlatform.android) {
        canShowDialog();
      }
    }, dialogClosed: (int level) {
      TPAdConfiguration.showLog("dialogClosed");
      if (defaultTargetPlatform == TargetPlatform.android) {
        TPSDKManager.setFirstShowGDPR(true);
      }
    });
    TPSDKManager.setInitListener(listener!);
    String appId = TPAdConfiguration.appId;
    if (defaultTargetPlatform == TargetPlatform.iOS)
    {
      Map customMap = {
        "user_id":"test_user_id",
        "user_age":19,
        "segment_id":1571,
        "bucket_id":299,
        "custom_data":"TestIMP",
        "channel":"tp_channel",
        "sub_channel":"tp_sub_channel"
      };
      TPSDKManager.setCustomMap(customMap);
    }else{
      Map customMap = {
        "user_id":"test_user_id",
        "user_age":"19",
        "custom_data":"TestIMP",
        "channel":"tp_channel",
        "sub_channel":"tp_sub_channel"
      };
      TPSDKManager.setCustomMap(customMap);
      TPSDKManager.setTestDevice(TPAdConfiguration.testDevice);
    }


    TPSDKManager.init(appId);
  }
}
