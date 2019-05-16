import 'package:flutter/material.dart';
import 'package:amap_base/amap_base.dart';

class FindHouseMapPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FindHouseMapPageState();
  }

}

class _FindHouseMapPageState extends State<FindHouseMapPage> with AutomaticKeepAliveClientMixin{
  Location _result;
  final _amapLocation = AMapLocation();


  @override
  void initState() {
    super.initState();
    _amapLocation.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () async{
                final options = LocationClientOptions(
                  isOnceLocation: true,
                  locatingWithReGeocode: true,
                );

                if (await Permissions().requestPermission()) {
                  _amapLocation.getLocation(options)
                      .then((value) {
                        setState(() {
                          _result = value;
                        });
                  });
                } else {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('权限不足')));
                }
              },
              child: Text("获取定位"),
            ),
            Text("当前位置是${_result != null ? _result.city : "失败"}")
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}