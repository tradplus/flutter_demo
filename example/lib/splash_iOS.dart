import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'configure.dart';
import 'log.dart';

class SplashIOSWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashIOSWidgetState();
  }
}

class SplashIOSWidgetState extends State<SplashIOSWidget> {
  String unitId = TPAdConfiguration.splashAdUnitId;
  static TPSplashAdListener? listener;
  String infoString = "";
  bool hasAd = false;
  bool useDef = true;
  String useDefText = "模版：默认";

  void initState() {
    super.initState();
    addListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('开屏-iOS'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: 'Log',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogWidget()),
            );
          },
        ),
      ]),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white70),
                      onPressed: () {
                        loadAd();
                      },
                      child: const Text("Load",
                          style: TextStyle(
                            color: Colors.black,
                          ))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white70),
                      onPressed: () {
                        checkAdReady();
                      },
                      child: const Text("isReady",
                          style: TextStyle(
                            color: Colors.black,
                          ))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white70),
                      onPressed: () {
                        showAd();
                      },
                      child: const Text("Show",
                          style: TextStyle(
                            color: Colors.black,
                          ))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white70),
                      onPressed: () {
                        changeClassName();
                      },
                      child:  Text(useDefText,
                          style: TextStyle(
                            color: Colors.black,
                          ))),
                ]),
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(top: 20),
                  child: Text(infoString, textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //加载广告
  loadAd() async {
    Map customMap = {};
    if (TPAdConfiguration.adCustomMap) {
      customMap = {
        "user_id": "test_splash_userid",
        "custom_data": "splash_TestIMP",
        "segment_tag": "splash_segment_tag"
      };
    }
    Map localParams = {
      "user_id": "splash_userId",
      "custom_data": "splash_customData"
    };
    Map extraMap = TPSplashManager.createSplashExtraMap(
        customMap: customMap, localParams: localParams);
    TPSplashManager.loadSplashAd(unitId, extraMap: extraMap);

    String time = DateTime.now().millisecondsSinceEpoch.toString();
    Map customAdInfo ={
      "act":"Load",
      "time":time
    };
    TPSplashManager.setCustomAdInfo(unitId, customAdInfo);
  }

  changeClassName()
  {
    setState(() {
      useDef = !useDef;
      if(useDef)
        useDefText = "模版：默认";
      else
        useDefText = "模版：自定义";
    });
  }

  //展示广告
  showAd() async {
    bool isReady = await TPSplashManager.splashAdReady(unitId);
    if (isReady) {

      String time = DateTime.now().millisecondsSinceEpoch.toString();
      Map customAdInfo ={
        "act":"Show",
        "time":time
      };
      TPSplashManager.setCustomAdInfo(unitId, customAdInfo);
      if(useDef)
      {
        TPSplashManager.showSplashAd(unitId);
      }
      else
      {
        //使用自定义模版
        TPSplashManager.showSplashAd(unitId,className: "NativeSplashTemplate");
      }
      print('ad show');
    } else {
      print('no ad');
    }
  }

  //广告是否已ready
  checkAdReady() async {
    bool isReady = await TPSplashManager.splashAdReady(unitId);
    print('isReady = $isReady');
    setState(() {
      infoString = "ad ready = $isReady";
    });
  }

  addListener() {
    listener = TPSplashAdListener(
      onAdLoaded: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onAdLoaded : adUnitId = $adUnitId, adInfo = $adInfo');
        setState(() {
          infoString = "Ad Loaded";
        });
      },
      onAdLoadFailed: (adUnitId, error) {
        TPAdConfiguration.showLog(
            'onAdLoadFailed : adUnitId = $adUnitId, error = $error');
        setState(() {
          infoString = "Load Failed";
        });
      },
      onAdImpression: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onAdImpression : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onAdShowFailed: (adUnitId, adInfo, error) {
        TPAdConfiguration.showLog(
            'onAdShowFailed : adUnitId = $adUnitId, adInfo = $adInfo, error = $error');
      },
      onAdClicked: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onAdClicked : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onAdClosed: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onAdClosed : adUnitId = $adUnitId, adInfo = $adInfo');
        setState(() {
          hasAd = false;
        });
      },
      oneLayerLoadFailed: (adUnitId, adInfo, error) {
        TPAdConfiguration.showLog(
            'oneLayerLoadFailed : adUnitId = $adUnitId, adInfo = $adInfo, error = $error');
      },
      //以下回调可选
      onAdStartLoad: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onAdStartLoad : adUnitId = $adUnitId, adInfo = $adInfo');
        setState(() {
          infoString = "start loading...";
        });
      },
      onBiddingStart: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onBiddingStart : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onBiddingEnd: (adUnitId, adInfo, error) {
        TPAdConfiguration.showLog(
            'onBiddingEnd : adUnitId = $adUnitId, adInfo = $adInfo, error = $error');
      },
      oneLayerStartLoad: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'oneLayerStartLoad : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      oneLayerLoaded: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'oneLayerLoaded : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onAdAllLoaded: (adUnitId, isSuccess) {
        TPAdConfiguration.showLog(
            'onAdAllLoaded : adUnitId = $adUnitId, isSuccess = $isSuccess');
      },
      onZoomOutStart:(adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onZoomOutStart : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onZoomOutEnd:(adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onZoomOutEnd : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onSkip:(adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onSkip : adUnitId = $adUnitId, adInfo = $adInfo');
      }
    );
    TPSplashManager.setSplashListener(listener!);
  }
}
