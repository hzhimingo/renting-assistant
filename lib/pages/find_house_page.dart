import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/widgets/find_house_appbar.dart';
import 'package:renting_assistant/widgets/house_cover_vertical.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';

class FindHousePage extends StatefulWidget {
  @override
  _FindHousePageState createState() => _FindHousePageState();
}

class _FindHousePageState extends State<FindHousePage> with AutomaticKeepAliveClientMixin{
  bool _isMask = false;
  bool _isShowContent = false;
  Widget contentWidget;
  Future<List<HouseCoverModel>> _houseCoverModelFuture;
  List<HouseCoverModel> houseCoverModels = [];

  @override
  void initState() {
    _houseCoverModelFuture = NetDataRepo().obtainHouseInfo();
    _houseCoverModelFuture.then((value) => houseCoverModels.addAll(value));
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
      future: _houseCoverModelFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<HouseCoverModel>> snap) {
        switch (snap.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return SpinKitRotatingCircle(
              color: Colors.cyan[300],
              size: 50.0,
            );
          case ConnectionState.done:
            if (snap.hasError) return Text('Error: ${snap.error}');
            return Container(
              margin: EdgeInsets.only(top: 40.0),
              color: Colors.grey[100],
              child: new StaggeredGridView.countBuilder(
                crossAxisCount: 4,
                itemCount: 26,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
               /* itemBuilder: (BuildContext context, int index) =>
                    _houseCoverItemBuilder(context, index, snap),*/
               itemBuilder: _houseCoverItemBuilder,
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
              ),
            );
        }
        return Container(
          child: Text("没有找到你想要的内容"),
        );
      },
    );
  }

  Widget _houseCoverItemBuilder(BuildContext context, int index) {
    HouseCoverModel houseCoverModel = houseCoverModels[index];
    return HouseCoverVertical(houseCoverModel);
  }

  Widget _content() {
    if (_isShowContent) {
      return Positioned(
        top: 32.0,
        child: Column(
          children: <Widget>[contentWidget, _mask()],
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
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
                _triggerContent(
                  HouseTypeFilterBox()
                );
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
                  width: MediaQuery.of(context).size.width,
                  height: 500.0,
                  color: Colors.redAccent,
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
              onTap: () {
                _triggerContent(
                  HousePriceFilterBox(),
                );
              },
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
              onTap: () {
                _triggerContent(
                  HouseMoreFilterBox(),
                );
              },
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

  @override
  bool get wantKeepAlive => true;
}

class HouseTypeFilterBox extends StatefulWidget {
  @override
  _HouseTypeFilterBoxState createState() => _HouseTypeFilterBoxState();
}

class _HouseTypeFilterBoxState extends State<HouseTypeFilterBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: Text(
                    "合租",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 10.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: FilterTag("全部"),
                    ),
                    Expanded(
                      child: FilterTag("2居"),
                    ),
                    Expanded(
                      child: FilterTag("3居"),
                    ),
                    Expanded(
                      child: FilterTag("4居"),
                    ),
                    Expanded(
                      child: FilterTag("4居+"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: Text(
                    "整租",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 10.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: FilterTag("全部"),
                    ),
                    Expanded(
                      child: FilterTag("2居"),
                    ),
                    Expanded(
                      child: FilterTag("3居"),
                    ),
                    Expanded(
                      child: FilterTag("4居"),
                    ),
                    Expanded(
                      child: FilterTag("4居+"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    margin:
                    EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        "重置",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 40.0,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin:
                    EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        "确定",
                        style: TextStyle(
                            color: Colors.white, fontSize: 16.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyan[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 40.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HouseRegion extends StatefulWidget {
  @override
  _HouseRegionState createState() => _HouseRegionState();
}

class _HouseRegionState extends State<HouseRegion> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HousePriceFilterBox extends StatefulWidget {
  @override
  _HousePriceFilterBoxState createState() => _HousePriceFilterBoxState();
}

class _HousePriceFilterBoxState extends State<HousePriceFilterBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "不限",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "1000元以下",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "1000-1500元",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "2000-2500元",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "2500-3000元",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "3000-4000元",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {},
              child: Text(
                "4000元以上",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HouseMoreFilterBox extends StatefulWidget {
  @override
  _HouseMoreFilterBoxState createState() => _HouseMoreFilterBoxState();
}

class _HouseMoreFilterBoxState extends State<HouseMoreFilterBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: Text(
                    "房屋特色",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 10.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: FilterTag("近地铁"),
                    ),
                    Expanded(
                      child: FilterTag("电梯"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            margin: EdgeInsets.only(bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  child: Text(
                    "房屋面积",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 10.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: FilterTag("10-20㎡"),
                    ),
                    Expanded(
                      child: FilterTag("20-30㎡"),
                    ),
                    Expanded(
                      child: FilterTag("20-40㎡"),
                    ),
                    Expanded(
                      child: FilterTag("40-60㎡"),
                    ),
                    Expanded(
                      child: FilterTag("60㎡以上"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    margin:
                    EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        "重置",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 40.0,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin:
                    EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        "确定",
                        style: TextStyle(
                            color: Colors.white, fontSize: 16.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyan[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 40.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterTag extends StatefulWidget {
  final String filterTag;

  FilterTag(this.filterTag);

  @override
  _FilterTagState createState() => _FilterTagState();
}

class _FilterTagState extends State<FilterTag> {
  bool isActivate = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LimitedBox(
        child: Container(
          child: Text(
            widget.filterTag,
            style: TextStyle(color: isActivate ? Colors.cyan[400] : Colors.black),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isActivate ? Colors.cyan[200] : Colors.grey[300],
            ),
            borderRadius: BorderRadius.circular(
              15.0,
            ),
            color: isActivate ? Colors.cyan[100] : Colors.white,
          ),
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            left: 4.0,
            right: 4.0,
          ),
          padding: EdgeInsets.only(
            top: 4.0,
            bottom: 4.0,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          isActivate = !isActivate;
        });
      },
    );
  }
}




