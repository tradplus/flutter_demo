import 'package:flutter/material.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'configure.dart';
import 'log.dart';

class InterstitialWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InterstitialWidgetState();
  }
}

class InterstitialWidgetState extends State<InterstitialWidget> {
  String unitId = TPAdConfiguration.interstitialAdUnitId;
  static TPInterstitialAdListener? listener;
  String infoString = "";
  String sceneId = TPAdConfiguration.interstitialSceneId;

  void initState() {
    super.initState();
    addListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('插屏'), actions: <Widget>[
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
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
                      entryInterstitialAdScenario();
                    },
                    child: const Text("EntryScene",
                        style: TextStyle(
                          color: Colors.black,
                        ))),
              ],
            ),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.only(top: 20),
            child: Text(infoString, textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }

  //加载广告
  loadAd() async {
    Map customMap = {};
    if (TPAdConfiguration.adCustomMap) {
      customMap = {
        "user_id": "test_interstitial_userid",
        "custom_data": "interstitial_TestIMP",
        "segment_tag": "interstitial_segment_tag"
      };
    }
    Map localParams = {
      "user_id": "interstitial_userId",
      "custom_data": "interstitial_customData"
    };
    Map extraMap = TPInterstitialManager.createInterstitialExtraMap(
        customMap: customMap,localParams:localParams);
    TPInterstitialManager.loadInterstitialAd(unitId, extraMap: extraMap);

    String time = DateTime.now().millisecondsSinceEpoch.toString();
    Map customAdInfo ={
      "act":"Load",
      "time":time
    };
    TPInterstitialManager.setCustomAdInfo(unitId, customAdInfo);
  }

  //展示广告
  showAd() async {
    bool isReady = await TPInterstitialManager.interstitialAdReady(unitId);
    if (isReady) {

      String time = DateTime.now().millisecondsSinceEpoch.toString();
      Map customAdInfo ={
        "act":"Show",
        "time":time
      };
      TPInterstitialManager.setCustomAdInfo(unitId, customAdInfo);

      TPInterstitialManager.showInterstitialAd(unitId, sceneId: sceneId);
      print('ad show');
    } else {
      print('no ad');
    }
  }

  //广告是否已ready
  checkAdReady() async {
    bool isReady = await TPInterstitialManager.interstitialAdReady(unitId);
    print('isReady = $isReady');
    setState(() {
      infoString = "ad ready = $isReady";
    });
  }

  //进入广告场景
  entryInterstitialAdScenario() async {
    TPInterstitialManager.entryInterstitialAdScenario(unitId, sceneId: sceneId);
    print('entryInterstitialAdScenario');
  }

  addListener() {
    listener = TPInterstitialAdListener(
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
      oneLayerLoadFailed: (adUnitId, adInfo, error) {
        TPAdConfiguration.showLog(
            'oneLayerLoadFailed : adUnitId = $adUnitId, adInfo = $adInfo, error = $error');
      },
      onAdClosed: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onAdClosed : adUnitId = $adUnitId, adInfo = $adInfo');
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
      onVideoPlayStart: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onVideoPlayStart : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onVideoPlayEnd: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onVideoPlayEnd : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onAdAllLoaded: (adUnitId, isSuccess) {
        TPAdConfiguration.showLog(
            'onAdAllLoaded : adUnitId = $adUnitId, isSuccess = $isSuccess');
      },
      onDownloadStart: (adUnitId, totalBytes,currBytes,fileName,appName) {
        TPAdConfiguration.showLog(
            'onDownloadStart : adUnitId = $adUnitId, totalBytes = $totalBytes, currBytes = $currBytes, fileName = $fileName, appName = $appName');
      },
      onDownloadUpdate: (adUnitId, totalBytes,currBytes,fileName,appName, progress) {
        TPAdConfiguration.showLog(
            'onDownloadStart : adUnitId = $adUnitId, totalBytes = $totalBytes, currBytes = $currBytes, fileName = $fileName, appName = $appName, progress = $progress');
      },
      onDownloadPause: (adUnitId, totalBytes,currBytes,fileName,appName) {
        TPAdConfiguration.showLog(
            'onDownloadPause : adUnitId = $adUnitId, totalBytes = $totalBytes, currBytes = $currBytes, fileName = $fileName, appName = $appName');
      },
      onDownloadFinish: (adUnitId, totalBytes,currBytes,fileName,appName) {
        TPAdConfiguration.showLog(
            'onDownloadFinish : adUnitId = $adUnitId, totalBytes = $totalBytes, currBytes = $currBytes, fileName = $fileName, appName = $appName');
      },
      onDownloadFail: (adUnitId, totalBytes,currBytes,fileName,appName) {
        TPAdConfiguration.showLog(
            'onDownloadFail : adUnitId = $adUnitId, totalBytes = $totalBytes, currBytes = $currBytes, fileName = $fileName, appName = $appName');
      },
      onInstall: (adUnitId, totalBytes,currBytes,fileName,appName) {
        TPAdConfiguration.showLog(
            'onInstall : adUnitId = $adUnitId, totalBytes = $totalBytes, currBytes = $currBytes, fileName = $fileName, appName = $appName');
      },
    );
    TPInterstitialManager.setInterstitialListener(listener!);
  }
}
