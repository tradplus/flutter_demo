import 'package:flutter/material.dart';
import 'configure.dart';

class LogWidget extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return LogWidgetState();
  }
}

class LogWidgetState extends State<LogWidget>
{


  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
          actions:<Widget>[
      IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Log',
          onPressed: () {
            TPAdConfiguration.showInfo = "";
            setState((){});
          },
        ),
        ]
      ),
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
            TPAdConfiguration.showInfo
        ),
      )
    );
  }
}