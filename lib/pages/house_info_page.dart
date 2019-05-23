import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/model/HouseInfo.dart';
import 'package:renting_assistant/model/house_detail.dart';
import 'package:renting_assistant/widgets/house_cover_horizontal.dart';
import 'package:renting_assistant/widgets/house_info_appbar.dart';
import 'package:renting_assistant/widgets/house_info_label.dart';
import 'package:renting_assistant/widgets/house_info_map.dart';
import 'package:renting_assistant/api/net_data_repo.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HouseInfoPage extends StatefulWidget {
  final String houseId;
  HouseInfoPage(this.houseId);

  @override
  State<HouseInfoPage> createState() {
    return _HouseInfoPageState();
  }
}

class _HouseInfoPageState extends State<HouseInfoPage> {
  double appBarAlpha = 0;
  final _imageWidth = 30.0;
  final _imageHeight = 30.0;
  final _bottomSheetScaffoldKey = GlobalKey<ScaffoldState>();
  Future<HouseDetailModel> _houseDetailFuture;
  HouseDetailModel houseDetailModel;

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }

  @override
  void initState() {
    _loadData(widget.houseId);
    super.initState();
  }

  _loadData(String houseId) {
    _houseDetailFuture = NetDataRepo().obtainHouseDetailInfo(houseId);
    _houseDetailFuture.then((value) {
      setState(() {
        houseDetailModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bottomSheetScaffoldKey,
      backgroundColor: Colors.white,
      body: FutureBuilder<HouseDetailModel>(
        future: _houseDetailFuture,
        builder: (BuildContext context, AsyncSnapshot<HouseDetailModel> snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: SpinKitThreeBounce(
                  color: Colors.cyan[300],
                  size: 30.0,
                ),
              );
            case ConnectionState.done:
              return Stack(
                children: <Widget>[
                  MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: NotificationListener(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification &&
                              scrollNotification.depth == 0) {
                            _onScroll(scrollNotification.metrics.pixels);
                          }
                        },
                        child: ListView(
                          children: <Widget>[
                            Container(
                              height: 260.0,
                              child: Swiper(
                                itemBuilder: (BuildContext context, int index) {
                                  return new Image.network(
                                    houseDetailModel.houseImages[index],
                                    fit: BoxFit.fill,
                                  );
                                },
                                itemCount: houseDetailModel.houseImages.length,
                                autoplay: false,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
                              child: Text(
                                houseDetailModel.houseTitle,
                                style: TextStyle(
                                    fontSize: 19.0, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                              child: Text.rich(
                                TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "￥",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                        text: "${houseDetailModel.housePrice}",
                                        style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 19.0,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: "/月",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 70.0,
                                      margin: EdgeInsets.only(left: 2.0, right: 2.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey[200],
                                          )),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "面积",
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            "${houseDetailModel.houseArea}㎡",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 2.0, right: 2.0),
                                      height: 70.0,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey[200],
                                          )),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("户型"),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            houseDetailModel.houseType,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 70.0,
                                      margin: EdgeInsets.only(left: 2.0, right: 2.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey[200],
                                          )),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(houseDetailModel.floor),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            "有电梯",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              child: Divider(),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                              child: Text("房屋信息",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  )),
                            ),
                            HouseInfoLabel(houseDetailModel),
                            Padding(
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              child: Divider(),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                              child: Text("租约信息",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 20.0, bottom: 20.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        size: 17.0,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        "签约时长：",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Text(
                                        houseDetailModel.tenancy,
                                        style: TextStyle(fontSize: 16.0),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 13.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.home,
                                        size: 17.0,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        "入住状态：",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Text(
                                        houseDetailModel.checkin,
                                        style: TextStyle(fontSize: 16.0),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 13.0,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.trip_origin,
                                        size: 17.0,
                                      ),
                                      SizedBox(
                                        width: 8.0,
                                      ),
                                      Text(
                                        "信息来源：",
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        width: 12.0,
                                      ),
                                      Text(
                                        "链家",
                                        style: TextStyle(fontSize: 16.0),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              child: Divider(),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                              child: Text("房屋设施",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 20.0, bottom: 20.0),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/bed.png",
                                          width: _imageWidth,
                                          height: _imageHeight,
                                        ),
                                        Text("床"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/aircondition.png",
                                          width: _imageWidth,
                                          height: _imageHeight,
                                        ),
                                        Text("空调"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/wardrobe.png",
                                          width: _imageWidth,
                                          height: _imageHeight,
                                        ),
                                        Text("衣柜"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "assets/images/tv.png",
                                          width: _imageWidth,
                                          height: _imageHeight,
                                        ),
                                        Text("电视"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.menu),
                                          onPressed: () {
                                            _openBottomSheet();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              child: Divider(),
                            ),
                            Padding(
                              padding:
                              EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                              child: Text(
                                "小区周边",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 12.0),
                              height: 250.0,
                              child: HouseInfoMap(),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              height: 10.0,
                              color: Colors.grey[100],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Text(
                                "看过此房间的人还看了",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            /*ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: _itemBuilder,
                    ),*/
                          ],
                        ),
                      )),
                  Opacity(
                    opacity: appBarAlpha,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  HouseInfoAppBar(),
                ],
              );
          }
        },
      ),
    );
  }

  /*Widget _itemBuilder(BuildContext context, int index) {
    return HouseCoverHorizontal();
  }*/

  _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 300.0,
          color: Colors.orange,
        );
      },
    );
  }
}
