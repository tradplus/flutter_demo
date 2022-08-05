import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TPBannerViewWidget extends StatefulWidget {
  TPBannerViewWidget(this.adUnitId);

  String adUnitId;

  @override
  State<StatefulWidget> createState() {
    return TPBannerViewWidgetState();
  }
}

class TPBannerViewWidgetState extends State<TPBannerViewWidget> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        key: UniqueKey(),
        viewType: 'tp_banner_view',
        creationParams: <String, dynamic>{"adUnitId": widget.adUnitId},
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        key: UniqueKey(),
        viewType: 'tp_banner_view',
        creationParams: {"adUnitId": widget.adUnitId},
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return const Text("Unsupported platform");
    }
  }
}
