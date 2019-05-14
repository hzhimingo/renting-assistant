import 'package:flutter/material.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/widgets/find_house_appbar.dart';
import 'package:renting_assistant/widgets/house_cover_vertical.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';

class FindHousePage extends StatefulWidget {
  @override
  _FindHousePageState createState() => _FindHousePageState();
}

class _FindHousePageState extends State<FindHousePage> {

  bool _isMask = false;
  bool _isShowContent = false;
  Widget contentWidget;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FindHouseAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            _body(),
            _filter(),
            _content(),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return FutureBuilder<List<HouseCoverModel>>(
      future: NetDataRepo().obtainHouseInfo(),
      builder: (BuildContext context, AsyncSnapshot<List<HouseCoverModel>> snap) {
        switch (snap.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return SpinKitRotatingCircle(
              color: Colors.cyan[300],
              size: 50.0,
            );
          case ConnectionState.done:
            if (snap.hasError)
              return Text('Error: ${snap.error}');
            return Container(
              margin: EdgeInsets.only(top: 32.0),
              color: Colors.grey[100],
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.all(10.0),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 9 / 14,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _houseCoverItemBuilder(context, index, snap),
                        childCount: snap.data.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
        }
        return null;
      },
    );
  }

  Widget _houseCoverItemBuilder(BuildContext context, int index, AsyncSnapshot<List<HouseCoverModel>> snap) {
    HouseCoverModel houseCoverModel = snap.data[index];
    return HouseCoverVertical(houseCoverModel);
  }

  Widget _content() {
    if (_isShowContent) {
      return Positioned(
        top: 32.0,
        child: Column(
          children: <Widget>[
            contentWidget,
            _mask()
          ],
        ),
      );
    } else {
      return Container(height: 0.0,);
    }
  }

  Widget _mask() {
    if (_isMask) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _isMask = !_isMask;
            _isShowContent = !_isShowContent;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(0, 0, 0, 0.5),
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  _triggerContent(Widget widget) {
    setState(() {
      contentWidget = widget;
      _isMask = !_isMask;
      _isShowContent = !_isShowContent;
    });
  }

  Widget _filter() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 8.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                _triggerContent(Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300.0,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Text("合租"),
                            Container(
                              child: Row(
                                children: <Widget>[

                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "合/整租",
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                _triggerContent(Container(
                  height: 500.0,
                  color: Colors.redAccent,
                  child: Text("1111"),
                ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "昌平区",
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "价格",
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: (){},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "更多",
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
