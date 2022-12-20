import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tradplus_sdk/tradplus_sdk.dart';
import 'configure.dart';
import 'log.dart';
import 'configure.dart';

class OtherWidget extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return OtherWidgetState();
  }
}

class OtherWidgetState extends State<OtherWidget>
{
  int itemCount = 3;
  void initState() {
    super.initState();
    if(defaultTargetPlatform == TargetPlatform.iOS)
    {
      itemCount = 2;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试设置'),
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
      itemCount: itemCount,
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
        bool adCustomMap = TPAdConfiguration.adCustomMap;
        return[
          Text("是否设置广告位 流量分组 $adCustomMap"),
          Container(
            margin: const EdgeInsets.only(left: 50),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white70),
                onPressed: (){
                  setAdCustomMap();
                },
                child: const Text("设置",
                    style: TextStyle(
                      color: Colors.black,
                    ))),
          ),
        ];
      }
      case 1:
        {
          return[
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white70),
                onPressed: (){
                  clearCache();
                },
                child: const Text("清理激励视频缓存",
                    style: TextStyle(
                      color: Colors.black,
                    ))),
          ];
        }
      case 2:
      {
        bool testDevice = TPAdConfiguration.testDevice;
        return[
          Text("是否测试设备 $testDevice"),
          Container(
            margin: const EdgeInsets.only(left: 50),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white70),
                onPressed: (){
                  setTestDevice();
                },
                child: const Text("设置",
                    style: TextStyle(
                      color: Colors.black,
                    ))),
          ),
        ];
      }
    }
    return null;
  }

  clearCache() async
  {
    TPSDKManager.clearCache(TPAdConfiguration.rewardVideoAdUnitId);
  }

  setAutoload() async
  {
    TPAdConfiguration.isAutoLoad = !TPAdConfiguration.isAutoLoad;
    setState((){});
  }

  setAdCustomMap() async
  {
    TPAdConfiguration.adCustomMap = !TPAdConfiguration.adCustomMap;
    setState((){});
  }
  setTestDevice() async
  {
    TPAdConfiguration.testDevice = !TPAdConfiguration.testDevice;
    setState((){});
  }
}