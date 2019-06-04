import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/house_detail.dart';
import 'package:renting_assistant/widgets/house_cover_horizontal.dart';
import 'package:renting_assistant/widgets/house_info_label.dart';
import 'package:renting_assistant/widgets/house_info_map.dart';

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
  int collected = 0;

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
        collected = value.collectStatus;
      });
      print(value.collectStatus);
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
                child: SpinKitFadingCircle(
                  color: Colors.cyan[300],
                  size: 50.0,
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
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
                              child: Text(
                                houseDetailModel.houseTitle,
                                style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
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
                              padding:
                                  EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 70.0,
                                      margin: EdgeInsets.only(
                                          left: 2.0, right: 2.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey[200],
                                          )),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 2.0, right: 2.0),
                                      height: 70.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey[200],
                                          )),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text("户型"),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            houseDetailModel.houseType,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 70.0,
                                      margin: EdgeInsets.only(
                                          left: 2.0, right: 2.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          border: Border.all(
                                            color: Colors.grey[200],
                                          )),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(houseDetailModel.floor),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                            "有电梯",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
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
                              padding: EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 10.0),
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
                              padding: EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 10.0),
                              child: Text("租约信息",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 30.0,
                                  right: 30.0,
                                  top: 20.0,
                                  bottom: 20.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                              padding: EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 10.0),
                              child: Text("联系人信息",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 25.0,
                                right: 25.0,
                                top: 20.0,
                                bottom: 20.0,
                              ),
                              margin: EdgeInsets.only(
                                left: 25.0,
                                right: 25.0,
                                top: 15.0,
                                bottom: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[100]),
                                borderRadius: BorderRadius.circular(8.0)
                              ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '联系人：',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        '${houseDetailModel.contactName}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '联系方式：',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        '${houseDetailModel.contactTelephone}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 10.0),
                              child: Text("房屋设施",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                left: 25.0,
                                right: 25.0,
                                top: 20.0,
                                bottom: 20.0,
                              ),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: _buildHouseFacCover(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              child: Divider(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 10.0),
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
                              child: HouseInfoMap(
                                  "${houseDetailModel.longitude},${houseDetailModel.latitude}"),
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
                  Container(
                    height: 80.0,
                    padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 32.0,
                    ),
                    child: Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _buildHouseInfoBar(),
                    ),
                  ),
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

  List<Widget> _buildHouseInfoBar() {
    List<Widget> appbar = [];
    appbar.add(
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
    appbar.add(
      Expanded(
        flex: 1,
        child: Container(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: collected == 1
                ? Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                  )
                : Icon(
                    Icons.favorite_border,
                  ),
            onPressed: () {
              if (collected == 1) {
                //取消关注
                LocalStore.readAccessToken().then((value) {
                  if (value == null) {
                    Navigator.of(context).pushNamed("/sign-in");
                  } else {
                    NetDataRepo().collect(houseDetailModel.houseId, 0, value).then((value) {
                      if (value == false) {
                        _showToast("取消关注失败");
                      } else {
                        setState(() {
                          collected = 0;
                        });
                        eventBus.fire(UpdateCollect());
                        _showToast("取消关注成功");
                      }
                    });
                  }
                });
              } else {
                //关注
                LocalStore.readAccessToken().then((value) {
                  if (value == null) {
                    Navigator.of(context).pushNamed("/sign-in");
                  } else {
                    NetDataRepo().collect(houseDetailModel.houseId, 1, value).then((value) {
                      if (value == false) {
                        _showToast("关注失败");
                      } else {
                        setState(() {
                          collected = 1;
                        });
                        eventBus.fire(UpdateCollect());
                        _showToast("关注成功");
                      }
                    });
                  }
                });
              }
            },
          ),
        ),
      ),
    );
    if (appBarAlpha == 1) {
      appbar.insert(
        1,
        Expanded(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            child: Text(
              houseDetailModel.houseTitle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }
    return appbar;
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
        textColor: Colors.white,
        fontSize: 14.0
    );
  }

  _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 240.0,
          color: Colors.white,
          padding: EdgeInsets.only(
            top: 16.0,
            bottom: 16.0,
          ),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.0,
            ),
            itemBuilder: _houseFacItemBuilder,
            itemCount: _buildHouseFac().length,
          ),
        );
      },
    );
  }

  Widget _houseFacItemBuilder(BuildContext context, int index) {
    return _buildHouseFac()[index];
  }

  List<Widget> _buildHouseFac() {
    List<Widget> lists = [];
    if (houseDetailModel.hasBed == 1) {
      lists.add(Column(
        children: <Widget>[
          Image.asset(
            "assets/images/bed.png",
            width: _imageWidth,
            height: _imageHeight,
          ),
          Text("床"),
        ],
      ));
    }
    if (houseDetailModel.hasTv == 1) {
      lists.add(Column(
        children: <Widget>[
          Image.asset(
            "assets/images/tv.png",
            width: _imageWidth,
            height: _imageHeight,
          ),
          Text("电视"),
        ],
      ));
    }
    if (houseDetailModel.hasHeater == 1) {
      lists.add(Column(
        children: <Widget>[
          Image.asset(
            "assets/images/heater.png",
            width: _imageWidth,
            height: _imageHeight,
          ),
          Text("热水器"),
        ],
      ));
    }
    if (houseDetailModel.hasAircondition == 1) {
      lists.add(Column(
        children: <Widget>[
          Image.asset(
            "assets/images/aircondition.png",
            width: _imageWidth,
            height: _imageHeight,
          ),
          Text("空调"),
        ],
      ));
    }
    if (houseDetailModel.hasInternet == 1) {
      lists.add(Column(
        children: <Widget>[
          Image.asset(
            "assets/images/internet.png",
            width: _imageWidth,
            height: _imageHeight,
          ),
          Text("无线网络"),
        ],
      ));
    }
    if (houseDetailModel.hasRefrigertor == 1) {
      lists.add(Column(
        children: <Widget>[
          Image.asset(
            "assets/images/refrigertor.png",
            width: _imageWidth,
            height: _imageHeight,
          ),
          Text("冰箱"),
        ],
      ));
    }
    if (houseDetailModel.hasWardobe == 1) {
      lists.add(Column(
        children: <Widget>[
          Image.asset(
            "assets/images/wardobe.png",
            width: _imageWidth,
            height: _imageHeight,
          ),
          Text("衣柜"),
        ],
      ));
    }
    if (houseDetailModel.hasWasher == 1) {
      lists.add(Column(
        children: <Widget>[
          Image.asset(
            "assets/images/washer.png",
            width: _imageWidth,
            height: _imageHeight,
          ),
          Text("洗衣机"),
        ],
      ));
    }
    if (houseDetailModel.hasHeating == 1) {
      lists.add(Column(
        children: <Widget>[
          Image.asset(
            "assets/images/heating.png",
            width: _imageWidth,
            height: _imageHeight,
          ),
          Text("暖气"),
        ],
      ));
    }
    return lists;
  }

  List<Widget> _buildHouseFacCover() {
    if (_buildHouseFac().length <= 4) {
      List<Widget> lists = [];
      print("Length: ${_buildHouseFac().length}");
      if (_buildHouseFac().length != 0) {
        for (int i = 0; i < _buildHouseFac().length; i++) {
          lists.add(Expanded(child: _buildHouseFac()[i]));
        }
      }
      return lists;
    } else {
      List<Widget> lists = _buildHouseFac().sublist(0, 3);
      List<Widget> newLists = [];
      for (int i = 0; i < lists.length; i++) {
        newLists.add(Expanded(child: lists[i]));
      }
      newLists.add(Expanded(
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
      ));
      return newLists;
    }
  }

}
