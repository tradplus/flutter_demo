import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TPInterActiveViewWidget extends StatefulWidget {
  const TPInterActiveViewWidget(this.adUnitId, {Key? key}) : super(key: key);

  final String adUnitId;

  @override
  State<StatefulWidget> createState() {
    return TPInterActiveViewWidgetState();
  }
}

class TPInterActiveViewWidgetState extends State<TPInterActiveViewWidget> {
  Key _platformViewKey = UniqueKey();

  @override
  void didUpdateWidget(TPInterActiveViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.adUnitId != widget.adUnitId) {
      _platformViewKey = UniqueKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        key: _platformViewKey,
        viewType: 'tp_interactive_view',
        creationParams: <String, dynamic>{
          "adUnitId": widget.adUnitId,
        },
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return const Text("Unsupported platform");
    }
  }
}
