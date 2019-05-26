import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HouseInfoMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HouseInfoMapState();
  }
}

class _HouseInfoMapState extends State<HouseInfoMap> {

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: "file:///android_asset/flutter_assets/assets/web/house_info_map.html",
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
