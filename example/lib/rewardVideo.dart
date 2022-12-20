import 'package:flutter/material.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'configure.dart';
import 'log.dart';

class RewardVideoWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RewardVideoWidgetState();
  }
}

class RewardVideoWidgetState extends State<RewardVideoWidget> {
  String unitId = TPAdConfiguration.rewardVideoAdUnitId;
  static TPRewardVideoAdListener? listener;
  String infoString = "";
  String sceneId = TPAdConfiguration.rewardVideoSceneId;

  void initState() {
    super.initState();
    addListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('激励视频'), actions: <Widget>[
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
                      entryRewardAdScenario();
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
        "user_id": "test_rewardVideo_userid",
        "custom_data": "rewardVideo_TestIMP",
        "segment_tag": "rewardVideo_segment_tag"
      };
    }
    Map localParams = {
      "user_id": "rewardVideo_userId",
      "custom_data": "rewardVideo_customData"
    };
    Map extraMap = TPRewardVideoManager.createRewardVideoExtraMap(
        customMap: customMap,
        localParams : localParams,
        userId: "rewardVideo_userId",
        customData: "rewardVideo_customData");
    TPRewardVideoManager.loadRewardVideoAd(unitId, extraMap: extraMap);

    String time = DateTime.now().millisecondsSinceEpoch.toString();
    Map customAdInfo ={
      "act":"Load",
      "time":time
    };
    TPRewardVideoManager.setCustomAdInfo(unitId, customAdInfo);
  }

  //展示广告
  showAd() async {
    bool isReady = await TPRewardVideoManager.rewardVideoAdReady(unitId);
    if (isReady) {

      String time = DateTime.now().millisecondsSinceEpoch.toString();
      Map customAdInfo ={
        "act":"Show",
        "time":time
      };
      TPRewardVideoManager.setCustomAdInfo(unitId, customAdInfo);

      TPRewardVideoManager.showRewardVideoAd(unitId, sceneId: sceneId);
      print('ad show');
    } else {
      print('no ad');
    }
  }

  //广告是否已ready
  checkAdReady() async {
    bool isReady = await TPRewardVideoManager.rewardVideoAdReady(unitId);
    print('isReady = $isReady');
    setState(() {
      infoString = "ad ready = $isReady";
    });
  }

  //进入广告场景
  entryRewardAdScenario() async {
    TPRewardVideoManager.entryRewardVideoAdScenario(unitId, sceneId: sceneId);
    print(' entryRewardAdScenario');
  }

  addListener() {
    listener = TPRewardVideoAdListener(
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
      },
      oneLayerLoadFailed: (adUnitId, adInfo, error) {
        TPAdConfiguration.showLog(
            'oneLayerLoadFailed : adUnitId = $adUnitId, adInfo = $adInfo, error = $error');
      },
      onAdReward: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onAdReward : adUnitId = $adUnitId, adInfo = $adInfo');
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
      //国内 穿山甲 快手 再看一个相关回调
      onPlayAgainImpression: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onPlayAgainImpression : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onPlayAgainReward: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onPlayAgainReward : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onPlayAgainClicked: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onPlayAgainClicked : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onPlayAgainVideoPlayStart: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onPlayAgainVideoPlayStart : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onPlayAgainVideoPlayEnd: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onPlayAgainVideoPlayEnd : adUnitId = $adUnitId, adInfo = $adInfo');
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
    TPRewardVideoManager.setRewardVideoListener(listener!);
  }
}
