import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class FindHouseMapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FindHouseMapPageState();
  }

}

class _FindHouseMapPageState extends State<FindHouseMapPage>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "https://m.amap.com/",
      withJavascript: true,
      geolocationEnabled: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


}