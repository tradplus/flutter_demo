import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'log.dart';

class PrivacyWidget extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return PrivacyWidgetState();
  }
}

class PrivacyWidgetState extends State<PrivacyWidget>
{
  static TPInitListener? listener;
  String gdprState = "";
  String ccpaState = "";
  String coppaState = "";
  String version = "";
  String isEUTraffic = "";
  String isCAString = "";
  String personalizedAd = "";

  void initState() {
    super.initState();
    addListener();
    updateState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('隐私设置'),
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
      body: ListView.builder(
      itemCount: 7,
      itemExtent: 50,
      itemBuilder: (BuildContext context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: childrenWithIndex(index),
          );
        }
      ),
      );
  }

  childrenWithIndex(int index)
  {
    switch(index)
    {
      case 0:
      {
          return[
              Text("SDK version : $version"),
          ];
      }
      case 1:
        {
          return[
            Text(isEUTraffic),
            Text(isCAString),
          ];
        }
      case 2:
      {
        return[
          Text(gdprState),
          Container(
            margin: const EdgeInsets.only(left: 50),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white70),
                onPressed: (){
                  setGDPR();
                },
                child: const Text("设置",
                    style: TextStyle(
                      color: Colors.black,
                    ))),
          ),
        ];
      }
      case 3:
      {
        return[
          Text(ccpaState),
          Container(
            margin: const EdgeInsets.only(left: 50),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white70),
                onPressed: (){
                  setCCPA();
                },
                child: const Text("设置",
                    style: TextStyle(
                      color: Colors.black,
                    ))),
          ),
        ];
      }
      case 4:
      {
        return[
          Text(coppaState),
          Container(
            margin: const EdgeInsets.only(left: 50),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white70),
                onPressed: (){
                  setCOPPA();
                },
                child: const Text("设置",
                    style: TextStyle(
                      color: Colors.black,
                    ))),
          ),
        ];
      }
      case 5:
        {
          return[
            Text(personalizedAd),
            Container(
              margin: const EdgeInsets.only(left: 50),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white70),
                  onPressed: (){
                    setPersonalizedAd();
                  },
                  child: const Text("设置",
                      style: TextStyle(
                        color: Colors.black,
                      ))),
            ),
          ];
        }
      case 6:
        {
          return[
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white70),
                onPressed: (){
                  showGDPRDialog();
                },
                child: const Text("showGDPRDialog",
                    style: TextStyle(
                      color: Colors.black,
                    ))),
          ];
        }
    }
    return null;
  }

  setPersonalizedAd() async
  {
    bool bo = await TPSDKManager.isOpenPersonalizedAd();
    bool state = !bo;
    print("bo $bo");
    print("state $state");
    TPSDKManager.setOpenPersonalizedAd(state);
    updateState();
  }

  setCOPPA() async
  {
    int coppa = await TPSDKManager.getCOPPAIsAgeRestrictedUser();
    bool coppaState = !(coppa == 0);
    TPSDKManager.setCOPPAIsAgeRestrictedUser(coppaState);
    updateState();
  }

  setCCPA() async
  {
    int ccpa = await TPSDKManager.getCCPADoNotSell();
    bool ccpaState = !(ccpa == 0);
    TPSDKManager.setCCPADoNotSell(ccpaState);
    updateState();
  }

  setGDPR() async
  {
    bool isEU = await TPSDKManager.isEUTraffic();
    int gdpr = await TPSDKManager.getGDPRDataCollection();
    bool gdprState = !(gdpr == 0);
    TPSDKManager.setGDPRDataCollection(gdprState);
    updateState();
    if(!isEU)
    {
      print("当前不在欧洲");
    }
  }

  showGDPRDialog() async
  {
    if (defaultTargetPlatform == TargetPlatform.iOS)
    {
      // int gdpr = await TPSDKManager.getGDPRDataCollection();
      bool isEU = await TPSDKManager.isEUTraffic();
      if(isEU)//未设置
      {
        TPSDKManager.showGDPRDialog();
      }
      else
      {
        print("当前不在欧洲");
      }
    }else{
      TPSDKManager.showGDPRDialog();
    }
  }

  updateState() async
  {
    version = await TPSDKManager.version();
    bool isEU = await TPSDKManager.isEUTraffic();
    bool isCa = await TPSDKManager.isCalifornia();
    isEUTraffic = "是否在欧洲: $isEU";
    isCAString = "是否在加州: $isCa";
    int gdpr = await TPSDKManager.getGDPRDataCollection();
    gdprState = "GDPR 未设置";
    if(gdpr == 0)
    {
      gdprState = "GDPR 允许上报";
    }
    else if(gdpr == 1)
    {
      gdprState = "GDPR 不允许上报";
    }
    int ccpa = await TPSDKManager.getCCPADoNotSell();
    ccpaState = "CCPA 未设置";
    if(ccpa == 0)
    {
      ccpaState = "CCPA 允许上报";
    }
    else if(ccpa == 1)
    {
      ccpaState = "CCPA 不允许上报";
    }
    int coppa = await TPSDKManager.getCOPPAIsAgeRestrictedUser();
    coppaState = "COPPA 未设置";
    if(coppa == 0)
    {
      coppaState = "COPPA 儿童";
    }
    else if(coppa == 1)
    {
      coppaState = "COPPA 不是儿童";
    }
    bool isOpenPersonalizedAd = await TPSDKManager.isOpenPersonalizedAd();
    personalizedAd = "是否开启个性化广告：$isOpenPersonalizedAd";
    setState((){});
  }


  addListener()
  {
    listener = TPInitListener(
        //iOS level固定为0，只做为关闭回调
        dialogClosed:(int level)
        {
          print("dialogClosed");
          updateState();
        },
        gdprSuccess: (String msg)
        {
          print("sdk init finish");
        },
        gdprFailed:(String msg)
        {
          print("sdk init finish");
        }
    );
    TPSDKManager.setInitListener(listener!);
  }
}