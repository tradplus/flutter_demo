import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'part_refresh_view.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'configure.dart';
import 'log.dart';

class InterActiveWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InterActiveWidgetState();
  }
}

class InterActiveWidgetState extends State<InterActiveWidget> {
  String unitId = TPAdConfiguration.interActiveAdUnitId;
  static TPInterActiveAdListener? listener;
  bool hasAd = false;
  String infoString = "";
  String sceneId = TPAdConfiguration.interActiveSceneId;

  GlobalKey<PartRefreshWidgetState> globalKey = new GlobalKey();
  @override
  void initState() {
    super.initState();
    addListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('互动'), actions: <Widget>[
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
              ],
            ),
          ),
         PartRefreshWidget(globalKey, () {
            ///创建需要局部刷新的widget
            return Text(
              infoString,
              style: TextStyle(color: Colors.green),
            );
          }),
          Container(
              child: Container(
                // height: 100,
                width: 50,
                height: 50,

                // color: Colors.deepPurple,
                margin: const EdgeInsets.only(top: 20),
                child: getInterActive(),
              ))
        ],
      ),
    );
  }

  //加载广告
  loadAd() async {
    Map customMap = {};
    if (TPAdConfiguration.adCustomMap) {
      customMap = {
        "user_id": "test_interactive_userid",
        "segment_tag": "interactive_segment_tag"
      };
    }
    Map localParams = {
      "user_id": "interactive_userId",
      "custom_data": "interactive_customData"
    };
    Map extraMap = TPInteractiveManager.createInterActiveExtraMap(
        height: 50, width: 50,customMap:customMap,sceneId: sceneId,localParams:localParams);
    TPInteractiveManager.loadInterActiveAd(unitId, extraMap: extraMap);
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    Map customAdInfo ={
      "act":"Load",
      "time":time
    };
    TPInteractiveManager.setCustomAdInfo(unitId, customAdInfo);
  }


  //展示广告
  showAd() async {
    bool isReady = await TPInteractiveManager.interActiveAdReady(unitId);
    if (isReady) {
      setState(() {
        String time = DateTime.now().millisecondsSinceEpoch.toString();
        Map customAdInfo ={
          "act":"Show",
          "time":time
        };
        TPInteractiveManager.setCustomAdInfo(unitId, customAdInfo);
        hasAd = true;
      });
    }
  }

  //广告是否已ready
  checkAdReady() async {
    bool isReady = await TPInteractiveManager.interActiveAdReady(unitId);
    print('isReady = $isReady');
    // setState(() {
      infoString = "ad ready = $isReady";
    globalKey.currentState?.update();
    // });
  }


  addListener() {
    listener = TPInterActiveAdListener(
      onAdLoaded: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onAdLoaded : adUnitId = $adUnitId, adInfo = $adInfo');
        // setState(() {
          infoString = "Ad Loaded";
        globalKey.currentState?.update();
        // });
      },
      onAdLoadFailed: (adUnitId, error) {
        TPAdConfiguration.showLog(
            'onAdLoadFailed : adUnitId = $adUnitId, error = $error');
        // setState(() {
          infoString = "Load Failed";
        globalKey.currentState?.update();
        // });
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
        // setState(() {
          infoString = "start loading...";
        globalKey.currentState?.update();
        // });
      },
      onBiddingStart: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onBiddingStart : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onBiddingEnd: (adUnitId, adInfo, error) {
        TPAdConfiguration.showLog(
            'onBiddingEnd : adUnitId = $adUnitId, adInfo = $adInfo, error = $error');
      },
      onAdIsLoading: (adUnitId) {
        TPAdConfiguration.showLog(
            'onAdIsLoading : adUnitId = $adUnitId');
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
    );
    TPInteractiveManager.setInterActiveAdListener(listener!);
  }

  getInterActive() {
    if (!hasAd) {
      return null;
    }
    return TPInterActiveViewWidget(unitId);
  }
}
