import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TPSplashViewWidget extends StatefulWidget {
  const TPSplashViewWidget(this.adUnitId, {Key? key, this.layoutName = ""})
      : super(key: key);

  final String adUnitId;
  final String? layoutName;

  @override
  State<StatefulWidget> createState() {
    return TPSplashViewWidgetState();
  }
}

class TPSplashViewWidgetState extends State<TPSplashViewWidget> {
  Key _platformViewKey = UniqueKey();

  @override
  void didUpdateWidget(TPSplashViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adUnitId != widget.adUnitId ||
        oldWidget.layoutName != widget.layoutName) {
      _platformViewKey = UniqueKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        key: _platformViewKey,
        viewType: 'tp_splash_view',
        creationParams: <String, dynamic>{
          "adUnitId": widget.adUnitId,
          "layoutName": widget.layoutName
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return const Text("Unsupported platform");
    }
  }
}
