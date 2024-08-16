import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TPInterActiveViewWidget extends StatefulWidget {
  TPInterActiveViewWidget(this.adUnitId, {Key? key});

  final String adUnitId;

  @override
  State<StatefulWidget> createState() {
    return TPInterActiveViewWidgetState();
  }
}

class TPInterActiveViewWidgetState extends State<TPInterActiveViewWidget> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        key: UniqueKey(),
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
