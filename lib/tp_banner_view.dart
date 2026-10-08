import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TPBannerViewWidget extends StatefulWidget {
  const TPBannerViewWidget(this.adUnitId, {Key? key, this.className = ""})
      : super(key: key);

  final String adUnitId;
  final String? className;

  @override
  State<StatefulWidget> createState() {
    return TPBannerViewWidgetState();
  }
}

class TPBannerViewWidgetState extends State<TPBannerViewWidget> {
  Key _platformViewKey = UniqueKey();

  @override
  void didUpdateWidget(TPBannerViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adUnitId != widget.adUnitId ||
        oldWidget.className != widget.className) {
      _platformViewKey = UniqueKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        key: _platformViewKey,
        viewType: 'tp_banner_view',
        creationParams: <String, dynamic>{
          "adUnitId": widget.adUnitId,
          "layoutName": widget.className
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        key: _platformViewKey,
        viewType: 'tp_banner_view',
        creationParams: {
          "adUnitId": widget.adUnitId,
          "className": widget.className
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return const Text("Unsupported platform");
    }
  }
}
