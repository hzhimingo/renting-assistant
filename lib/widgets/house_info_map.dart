import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HouseInfoMap extends StatefulWidget {
  final String geoInfo;

  HouseInfoMap(this.geoInfo);

  @override
  State<StatefulWidget> createState() {
    return _HouseInfoMapState();
  }
}

class _HouseInfoMapState extends State<HouseInfoMap> with AutomaticKeepAliveClientMixin{
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: "file:///android_asset/flutter_assets/assets/web/house_info_map.html",
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller = webViewController;
      },
      onPageFinished: (String url) {
        _controller.evaluateJavascript('toGeo("${widget.geoInfo}")');
      },
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
