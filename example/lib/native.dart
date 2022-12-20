import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'part_refresh_view.dart';

import 'configure.dart';
import 'log.dart';

class NativeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NativeWidgetState();
  }
}

class NativeWidgetState extends State<NativeWidget> {
  String unitId = TPAdConfiguration.nativeAdUnitId;
  static TPNativeAdListener? listener;

  //0 没有广告 1 使用自渲染模版 2 使用自渲染自定义Map
  int showType = 0;
  String infoString = "";
  String sceneId = TPAdConfiguration.nativeSceneId;

  GlobalKey<PartRefreshWidgetState> globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    addListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('原生广告'), actions: <Widget>[
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
                      showClassname();
                    },
                    child: const Text("show classname",
                        style: TextStyle(
                          color: Colors.black,
                        ))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white70),
                    onPressed: () {
                      showExtraMap();
                    },
                    child: const Text("show extraMap",
                        style: TextStyle(
                          color: Colors.black,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                      entryAdScenario();
                    },
                    child: const Text("EntryScene",
                        style: TextStyle(
                          color: Colors.black,
                        ))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white70),
                    onPressed: () {
                      loadedCount();
                    },
                    child: const Text("ReadyCount",
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
                width: 320,
                height: 500,
                margin: const EdgeInsets.only(top: 10),
                child: getNativeView(),
              )),
        ],
      ),
    );
  }

  //加载广告
  loadAd() async {
    Map customMap = {};
    if (TPAdConfiguration.adCustomMap) {
      customMap = {
        "user_id": "test_native_userid",
        "custom_data": "native_TestIMP",
        "segment_tag": "native_segment_tag"
      };
    }
    Map localParams = {
      "user_id": "native_userId",
      "custom_data": "native_customData"
    };
    Map extraMap = TPNativeManager.createNativeExtraMap(
        templateHeight: 320,
        templateWidth: 320,
        customMap: customMap,
        localParams:localParams);
    TPNativeManager.loadNativeAd(unitId, extraMap: extraMap);

    String time = DateTime.now().millisecondsSinceEpoch.toString();
    Map customAdInfo ={
      "act":"Load",
      "time":time
    };
    TPNativeManager.setCustomAdInfo(unitId, customAdInfo);
  }

  //广告是否已ready
  checkAdReady() async {
    bool isReady = await TPNativeManager.nativeAdReady(unitId);
    print('isReady = $isReady');
    // setState(() {
      infoString = "ad ready = $isReady";
    globalKey.currentState?.update();
    // });
  }

  //展示广告 classname 方式
  showClassname() async {
    //展示广告
    bool isReady = await TPNativeManager.nativeAdReady(unitId);
    if (isReady) {
      print('ad show');
      setState(() {
        showType = 1;
      });
    } else {
      print('no ad');
    }
  }

  //展示广告 自定义Map 方式
  showExtraMap() async {
    //展示广告
    bool isReady = await TPNativeManager.nativeAdReady(unitId);
    if (isReady) {
      print('ad show');
      setState(() {
        showType = 2;
      });
    } else {
      print('no ad');
    }
  }

  //进入广告场景
  entryAdScenario() async {
    TPNativeManager.entryNativeAdScenario(unitId, sceneId: sceneId);
    print('entryNativeAdScenario');
  }

  //已缓存广告数量
  loadedCount() async {
    int count = await TPNativeManager.nativeLoadedCount(unitId);
    print('count = $count');
    infoString = "ready ad count = $count";
    globalKey.currentState?.update();
  }

  getNativeView()
  {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    Map customAdInfo ={
      "act":"Show",
      "time":time
    };
    if (showType == 0)
    {
      return null;
    }
    else if (showType == 1) //使用布局
    {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return TPNativeViewWidget(unitId, 320, 320,
            className: "TPNativeTemplate", sceneId: sceneId,customAdInfo:customAdInfo);
      } else //android
      {
        return TPNativeViewWidget(unitId, 320, 540,
            className: "native_ad_list_item",sceneId: sceneId,customAdInfo:customAdInfo);
      }
    } else if (showType == 2) //使用自定义Map
    {
      return TPNativeViewWidget(
        unitId,
        320,
        320,
        sceneId: sceneId,
        extraMap: {
          "parent": TPNativeManager.createNativeSubViewAttribute(320, 320,
              backgroundColorStr: "#FFFFFF"),
          "appIcon": TPNativeManager.createNativeSubViewAttribute(50, 50,
              x: 10, y: 10),
          "mainTitle": TPNativeManager.createNativeSubViewAttribute(
              320 - 190, 20,
              x: 70, y: 40),
          "desc": TPNativeManager.createNativeSubViewAttribute(320 - 190, 20,
              x: 70, y: 70),
          "cta": TPNativeManager.createNativeSubViewAttribute(100, 50,
              x: 320 - 110, y: 40, backgroundColorStr: "#AAF7DC6F"),
          "mainImage": TPNativeManager.createNativeSubViewAttribute(
              320, 320 * 0.6,
              x: 0, y: 100),
          "adLogo": TPNativeManager.createNativeSubViewAttribute(20, 20,
              x: 320 - 30, y: 10)
        },
          customAdInfo:customAdInfo,
      );

    }
  }

  addListener() {
    listener = TPNativeAdListener(
      onAdLoaded: (adUnitId, adInfo) {
        TPAdConfiguration.showLog(
            'onAdLoaded : adUnitId = $adUnitId, adInfo = $adInfo');
        infoString = "Ad Loaded";
        globalKey.currentState?.update();
      },
      onAdLoadFailed: (adUnitId, error) {
        TPAdConfiguration.showLog(
            'onAdLoadFailed : adUnitId = $adUnitId, error = $error');
          infoString = "Load Failed";
          globalKey.currentState?.update();
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
          showType = 0;
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
          infoString = "start loading...";
          globalKey.currentState?.update();
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
    TPNativeManager.setNativeAdListener(listener!);
  }
}
