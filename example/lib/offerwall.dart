import 'package:flutter/material.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'configure.dart';
import 'log.dart';

class OfferWallWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OfferWallWidgetState();
  }
}

class OfferWallWidgetState extends State<OfferWallWidget> {
  String unitId = TPAdConfiguration.offerwallAdUnitId;
  static TPOfferwallAdListener? listener;
  String infoString = "";

  void initState() {
    super.initState();
    addListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('积分墙'),
            actions:<Widget>[
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
            ]
        ),
        body: Column(children: [
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
                      entryOfferWallAdScenario();
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
                      setUserId();
                    },
                    child: const Text("setUserId",
                        style: TextStyle(
                          color: Colors.black,
                        ))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white70),
                    onPressed: () {
                      getCurrencyBalance();
                    },
                    child: const Text("currency",
                        style: TextStyle(
                          color: Colors.black,
                        ))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white70),
                    onPressed: () {
                      spendBalance();
                    },
                    child: const Text("spend20",
                        style: TextStyle(
                          color: Colors.black,
                        ))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white70),
                    onPressed: () {
                      awardBalance();
                    },
                    child: const Text("award20",
                        style: TextStyle(
                          color: Colors.black,
                        ))),
              ],
            ),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.only(top: 20),
            child: Text(
                infoString,
                textAlign:TextAlign.center
            ),
          )
        ]));
  }

  loadAd() {
    Map customMap = {};
    if (TPAdConfiguration.adCustomMap) {
      customMap = {
        "user_id": "test_offerWall_userid",
        "custom_data": "offerWall_TestIMP",
        "segment_tag": "offerWall_segment_tag"
      };
    }
    Map localParams = {
      "user_id": "offerwall_userId",
      "custom_data": "offerwall_customData"
    };
    Map extraMap = TPOfferWallManager.createOfferwallExtraMap(
        isAutoLoad: TPAdConfiguration.isAutoLoad,
        customMap: customMap,
        localParams:localParams);
    TPOfferWallManager.loadOfferwallAd(unitId,extraMap: extraMap);

    String time = DateTime.now().millisecondsSinceEpoch.toString();
    Map customAdInfo ={
      "act":"Load",
      "time":time
    };
    TPOfferWallManager.setCustomAdInfo(unitId, customAdInfo);
  }

  showAd() async {
    bool isReady = await TPOfferWallManager.offerwallAdReady(unitId);
    if (isReady) {

      String time = DateTime.now().millisecondsSinceEpoch.toString();
      Map customAdInfo ={
        "act":"Show",
        "time":time
      };
      TPOfferWallManager.setCustomAdInfo(unitId, customAdInfo);

      TPOfferWallManager.showOfferwallAd(unitId);
    }
  }

  checkAdReady() async {
    bool isReady = await TPOfferWallManager.offerwallAdReady(unitId);
    print('isReady = $isReady');
    setState(() {
      infoString = "ad ready = $isReady";
    });
  }

  entryOfferWallAdScenario() async {
    TPOfferWallManager.entryOfferwallAdScenario(unitId, sceneId: "12333");
    print(' entryOfferWallAdScenario');
  }

  setUserId() async
  {
    TPOfferWallManager.setUserId(unitId,"test_userid");
  }

  getCurrencyBalance() async {
    TPOfferWallManager.getCurrencyBalance(unitId);
    print(' getCurrencyBalance');
  }

  spendBalance() async {
    TPOfferWallManager.spendBalance(unitId, 20);
    print(' spendBalance');
  }

  awardBalance() async {
    TPOfferWallManager.awardBalance(unitId, 20);
    print(' awardBalance');
  }

  addListener() {
    listener = TPOfferwallAdListener(
      onAdLoaded: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('onAdLoaded : adUnitId = $adUnitId, adInfo = $adInfo');
        setState((){
          infoString = "Ad Loaded";
        });
      },
      onAdLoadFailed: (adUnitId, error) {
        TPAdConfiguration.showLog('onAdLoadFailed : adUnitId = $adUnitId, error = $error');
        setState((){
          infoString = "Load Failed";
        });
      },
      onAdImpression: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('onAdImpression : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onAdShowFailed: (adUnitId, adInfo, error) {
        TPAdConfiguration.showLog(
            'onAdShowFailed : adUnitId = $adUnitId, adInfo = $adInfo, error = $error');
      },
      onAdClicked: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('onAdClicked : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onAdClosed: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('onAdClosed : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      oneLayerLoadFailed: (adUnitId, adInfo, error) {
        TPAdConfiguration.showLog(
            'oneLayerLoadFailed : adUnitId = $adUnitId, adInfo = $adInfo, error = $error');
      },
      //以下回调可选
      onAdStartLoad: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('onAdStartLoad : adUnitId = $adUnitId, adInfo = $adInfo');
        setState((){
          infoString = "start loading...";
        });
      },
      onBiddingStart: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('onBiddingStart : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onBiddingEnd: (adUnitId, adInfo, error) {
        TPAdConfiguration.showLog(
            'onBiddingEnd : adUnitId = $adUnitId, adInfo = $adInfo, error = $error');
      },
      oneLayerStartLoad: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('oneLayerStartLoad : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      oneLayerLoaded: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('oneLayerLoaded : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onVideoPlayStart: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('onVideoPlayStart : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onVideoPlayEnd: (adUnitId, adInfo) {
        TPAdConfiguration.showLog('onVideoPlayEnd : adUnitId = $adUnitId, adInfo = $adInfo');
      },
      onAdAllLoaded: (adUnitId, isSuccess) {
        TPAdConfiguration.showLog('onAdAllLoaded : adUnitId = $adUnitId, isSuccess = $isSuccess');
      },
      currencyBalanceSuccess: (adUnitId, amount, msg) {
        TPAdConfiguration.showLog('currencyBalanceSuccess : adUnitId = $adUnitId, amount = $amount, msg = $msg');
        setState((){
          infoString = "当前用户积分：amount = $amount";
        });
      },
      currencyBalanceFailed: (adUnitId, msg) {
        TPAdConfiguration.showLog('currencyBalanceFailed : adUnitId = $adUnitId, msg = $msg');
        setState((){
          infoString = "当前用户积分获取失败";
        });
      },
      spendCurrencySuccess: (adUnitId, amount, msg) {
        TPAdConfiguration.showLog('spendCurrencySuccess : adUnitId = $adUnitId, amount = $amount, msg = $msg');
        setState((){
          infoString = "扣除用户积分成功，当前用户积分：amount = $amount";
        });
      },
      spendCurrencyFailed: (adUnitId, msg) {
        TPAdConfiguration.showLog('spendCurrencyFailed : adUnitId = $adUnitId, msg = $msg');
        setState((){
          infoString = "扣除积分失败";
        });
      },
      awardCurrencySuccess: (adUnitId, amount, msg) {
        TPAdConfiguration.showLog('awardCurrencySuccess : adUnitId = $adUnitId, amount = $amount, msg = $msg');
        setState((){
          infoString = "增加用户积分成功，当前用户积分：amount = $amount";
        });
      },
      awardCurrencyFailed: (adUnitId, msg) {
        TPAdConfiguration.showLog('awardCurrencyFailed : adUnitId = $adUnitId, msg = $msg');
        setState((){
          infoString = "增加积分失败";
        });
      },
      setUserIdFinish: (adUnitId , isSuccess)
      {
        TPAdConfiguration.showLog('setUserIdFinish : adUnitId = $adUnitId, isSuccess = $isSuccess');
        setState((){
          infoString = "设置 userId $isSuccess";
        });
      },
    );
    TPOfferWallManager.setOfferwallListener(listener!);
  }
}
