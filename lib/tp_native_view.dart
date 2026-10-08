import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TPNativeViewWidget extends StatefulWidget {
  const TPNativeViewWidget(this.adUnitId, this.width, this.height,
      {Key? key,
      this.sceneId = "",
      this.className = "",
      this.extraMap,
      this.customAdInfo})
      : super(key: key);
  final String adUnitId;
  final double? width;
  final double? height;
  final String? sceneId;
  final String? className;
  final Map? extraMap;
  final Map? customAdInfo;
  @override
  State<StatefulWidget> createState() {
    return TPNativeViewWidgetState();
  }
}

class TPNativeViewWidgetState extends State<TPNativeViewWidget> {
  Key _platformViewKey = UniqueKey();

  @override
  void didUpdateWidget(TPNativeViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adUnitId != widget.adUnitId ||
        oldWidget.className != widget.className ||
        oldWidget.sceneId != widget.sceneId ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        !mapEquals(oldWidget.extraMap, widget.extraMap) ||
        !mapEquals(oldWidget.customAdInfo, widget.customAdInfo)) {
      _platformViewKey = UniqueKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        key: _platformViewKey,
        viewType: 'tp_native_view',
        creationParams: <String, dynamic>{
          "adUnitId": widget.adUnitId,
          "sceneId": widget.sceneId,
          "extraMap": widget.extraMap,
          "width": widget.width,
          "height": widget.height,
          "layoutName": widget.className,
          "customAdInfo": widget.customAdInfo
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        key: _platformViewKey,
        viewType: 'tp_native_view',
        creationParams: {
          "adUnitId": widget.adUnitId,
          "width": widget.width,
          "height": widget.height,
          "className": widget.className,
          "extraMap": widget.extraMap,
          "sceneId": widget.sceneId,
          "customAdInfo": widget.customAdInfo
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return const Text("Unsupported platform");
    }
  }
}
