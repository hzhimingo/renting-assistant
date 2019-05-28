import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
    return WebView(
      initialUrl: "https://m.amap.com/",
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


}