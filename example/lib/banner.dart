import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'part_refresh_view.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'configure.dart';
import 'log.dart';

class BannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BannerWidgetState();
  }
}

class BannerWidgetState extends State<BannerWidget> {
  String unitId = TPAdConfiguration.bannerAdUnitId;
  static TPBannerAdListener? listener;
  bool hasAd = false;
  bool useDef = true;
  String useDefText = "模版：默认";
  String infoString = "";
  String sceneId = TPAdConfiguration.bannerSceneId;

  GlobalKey<PartRefreshWidgetState> globalKey = new GlobalKey();
  @override
  void initState() {
    super.initState();
    addListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('横幅'), actions: <Widget>[
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
                      entryAdScenario();
                    },
                    child: const Text("EntryScene",
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
                  changeClassName();
                },
                child: Text(useDefText,
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
                width: 320,
                height: 60,

                // color: Colors.deepPurple,
                margin: const EdgeInsets.only(top: 20),
                child: getBanner(),
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
        "user_id": "test_banner_userid",
        "custom_data": "banner_TestIMP",
        "segment_tag": "banner_segment_tag"
      };
    }
    Map localParams = {
      "user_id": "banner_userId",
      "custom_data": "banner_customData"
    };
    Map extraMap = TPBannerManager.createBannerExtraMap(
        height: 60, width: 320, customMap: customMap,localParams:localParams, sceneId: sceneId);
    TPBannerManager.loadBannerAd(unitId, extraMap: extraMap);
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    Map customAdInfo ={
      "act":"Load",
      "time":time
    };
    TPBannerManager.setCustomAdInfo(unitId, customAdInfo);
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
    bool isReady = await TPBannerManager.bannerAdReady(unitId);
    if (isReady) {
      setState(() {
        String time = DateTime.now().millisecondsSinceEpoch.toString();
        Map customAdInfo ={
          "act":"Show",
          "time":time
        };
        TPBannerManager.setCustomAdInfo(unitId, customAdInfo);
        hasAd = true;
      });
    }
  }

  //广告是否已ready
  checkAdReady() async {
    bool isReady = await TPBannerManager.bannerAdReady(unitId);
    print('isReady = $isReady');
    // setState(() {
      infoString = "ad ready = $isReady";
    globalKey.currentState?.update();
    // });
  }

  entryAdScenario() async {
    TPBannerManager.entryBannerAdScenario(unitId, sceneId: sceneId);
  }

  addListener() {
    listener = TPBannerAdListener(
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
    TPBannerManager.setBannerListener(listener!);
  }

  getBanner() {
    if (!hasAd) {
      return null;
    }
    if(useDef)
    {
      return TPBannerViewWidget(unitId);
    }
    else
    {
      //使用自定义模版
      String className = "";
      if(defaultTargetPlatform == TargetPlatform.iOS)
      {
        className = "NativeBannerTemplate";
      }
      else
      {
        className = "native_banner_ad_unit";
      }
      return TPBannerViewWidget(unitId,className:className);
    }
  }
}
