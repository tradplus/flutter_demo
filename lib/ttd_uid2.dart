import 'package:tradplus_sdk/tradplus_sdk.dart';

final ttdUID2Manager = TTDUID2Manager();

class TTDUID2Manager {

  Map? createUID2ExtraMap({
    String? subscriptionID,
    String? serverPublicKey,
    String? email,
    String? emailHash,
    String? phone,
    String? phoneHash,
    String? appName,
    String? customURLString,
    bool isTestMode = false,
  }) {
    Map extraMap = {};
    if (subscriptionID != null)
    {
      extraMap['subscriptionID'] = subscriptionID;
    }
    else
    {
      print("---UID2ExtraMap.subscriptionID can not be null ---");
      return null;
    }
    if (serverPublicKey != null)
    {
      extraMap['serverPublicKey'] = serverPublicKey;
    }
    else
    {
      print("---UID2ExtraMap.serverPublicKey can not be null ---");
      return null;
    }
    if(email == null && emailHash == null && phone == null && phoneHash == null)
    {
      print("---UID2ExtraMap email,emailHash,phone,phoneHash set at least one---");
      return null;
    }
    if (email != null)
    {
      extraMap['email'] = email;
    }
    if (emailHash != null)
    {
      extraMap['emailHash'] = emailHash;
    }
    if (phone != null)
    {
      extraMap['phone'] = phone;
    }
    if (phoneHash != null)
    {
      extraMap['phoneHash'] = phoneHash;
    }
    if (appName != null)
    {
      extraMap['appName'] = appName;
    }
    extraMap['isTestMode'] = isTestMode;
    if (customURLString != null)
    {
      extraMap['customURLString'] = customURLString;
    }
    return extraMap;
  }
  //开启UID2
  Future<void> start(Map? extraMap) async {
      if(extraMap != null)
      {
        TradplusSdk.channel.invokeMethod('uid2_start', extraMap);
      }
      else
      {
         print("---extraMap is null---");
      }
  }
  //重置所有的配置
  Future<void> resetSetting() async {
    TradplusSdk.channel.invokeMethod('uid2_reset');
  }

  setInitListener(TTDUID2Listener listener) {
    TPListenerManager.uid2Listener = listener;
  }

  callback(TTDUID2Listener listener, String method, Map arguments) {
    Map? error;
    if (arguments.containsKey("adError")) {
      error = arguments['adError'];
    }
    listener.startFinish(error);
  }
}

class TTDUID2Listener {
  final Function(Map? error) startFinish;
  const TTDUID2Listener({required this.startFinish});
}