import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/widgets/find_house_appbar.dart';
import 'package:renting_assistant/widgets/house_cover_vertical.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';
import 'package:renting_assistant/model/filter_condition.dart';
import 'package:path_provider/path_provider.dart';

class FindHouseFix extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FindHouseFixState();
  }
}

class FindHouseFixState extends State<FindHouseFix>
    with AutomaticKeepAliveClientMixin {
  List<Widget> contentWidget = [
    HouseTypeFilterBox(),
    HouseRegion(),
    HousePriceFilterBox(),
    HouseMoreFilterBox(),
  ];
  List<String> filterTitle = [
    "合/整租",
    "昌平区",
    "价格",
    "更多",
  ];
  bool isMaskOpen = false;
  int currentContentIndex = 0;
  FilterCondition condition = FilterCondition();
  Future<List<HouseCoverModel>> _houseCoverModelFuture;
  List<HouseCoverModel> houseCoverModels = [];
  ScrollController _controller = ScrollController();

  @override
  bool get wantKeepAlive => true;

  void _listen() {
    eventBus.on<SendHouseTypeFilterEvent>().listen((event) {
      setState(() {
        condition.isSelectAllSharedRent = event.isSelectAllSharedRent;
        condition.isSelectAllEntireRent = event.isSelectAllEntireRent;
        condition.entireRents = event.entireRents;
        condition.sharedRents = event.sharedRents;
      });
      LocalStore.saveFilterCondition(condition);
      reloadData();
      closeFilterContent();
      print("GetMessage-----> SendHouse");
    });
    eventBus.on<SendHouseMoreFilterEvent>().listen((event) {
      setState(() {
        condition.isNearBySubway = event.isNearBySubway;
        condition.hasLift = event.hasLift;
        condition.houseAreas = event.houseAreas;
      });
      LocalStore.saveFilterCondition(condition);
      reloadData();
      closeFilterContent();
      print("GetMessage-----> SendHouseMOre");
    });
    eventBus.on<ResetHouseTypeFilterEvent>().listen((event) {
      setState(() {
        condition.resetHouseTypeFilter();
      });
      LocalStore.saveFilterCondition(condition);
      print("GetMessage-----> HouseType");
    });
    eventBus.on<ResetHouseMoreFilterEvent>().listen((event) {
      setState(() {
        condition.resetHouseMoreFilter();
      });
      LocalStore.saveFilterCondition(condition);
      print("GetMessage-----> RestHouseMore");
    });
    eventBus.on<PriceFilterContentEvent>().listen((event) {
      setState(() {
        condition.priceClass = event.level;
        switch (event.level) {
          case 0:
            filterTitle[2] = "价格";
            break;
          case 1:
            filterTitle[2] = "1000以下";
            break;
          case 2:
            filterTitle[2] = "1000-2000";
            break;
          case 3:
            filterTitle[2] = "2000-3000";
            break;
          case 4:
            filterTitle[2] = "3000-4000";
            break;
          case 5:
            filterTitle[2] = "4000-5000";
            break;
          case 6:
            filterTitle[2] = "5000以上";
            break;
        }
      });
      LocalStore.saveFilterCondition(condition);
      reloadData();
      closeFilterContent();
      print("GetMessage-----> Price");
    });
  }

  @override
  void initState() {
    _houseCoverModelFuture = NetDataRepo().obtainHouseInfoFilter(1, 30);
    _houseCoverModelFuture.then((value) => houseCoverModels.addAll(value));
    int page = 1;
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _loadMore(++page);
      }
    });
    super.initState();
  }

  void reloadData() {
    _houseCoverModelFuture = NetDataRepo().obtainHouseInfoFilter(1, 20);
    _houseCoverModelFuture.then((value) {
      houseCoverModels.clear();
      houseCoverModels.addAll(value);
    });
  }

  _loadMore(int page) {
    print("加载更多");
    NetDataRepo().obtainHouseInfoFilter(page, 30).then((value) {
      setState(() {
        houseCoverModels.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
      appBar: FindHouseAppBar(),
      body: Stack(
        children: <Widget>[
          FutureBuilder<List<HouseCoverModel>>(
            future: _houseCoverModelFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<HouseCoverModel>> snap) {
              switch (snap.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                    child: SpinKitRotatingCircle(
                      color: Colors.cyan[300],
                      size: 50.0,
                    ),
                  );
                case ConnectionState.done:
                  if (snap.hasError)
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("网络异常！检查网络后重试"),
                          Padding(
                            child: RaisedButton(
                              onPressed: () {
                                reloadData();
                              },
                              child: Text("重新加载"),
                            ),
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          ),
                        ],
                      ),
                    );
                  if (houseCoverModels.length == 0) {
                    return Center(
                      child: Text("暂时没有你想要的房源噢！"),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: 32.0),
                      color: Colors.grey[100],
                      child: new StaggeredGridView.countBuilder(
                        controller: _controller,
                        crossAxisCount: 4,
                        itemCount: houseCoverModels.length,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        padding:
                            EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                        itemBuilder: _houseCoverItemBuilder,
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.fit(2),
                      ),
                    );
                  }
              }
              return Container(
                child: Text("没有找到你想要的内容"),
              );
            },
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 8.0),
            child: Flex(
              direction: Axis.horizontal,
              children: _buildFilterSwitch(),
            ),
          ),
          buildFilterContainer(),
        ],
      ),
    );
  }

  Widget _houseCoverItemBuilder(BuildContext context, int index) {
    HouseCoverModel houseCoverModel = houseCoverModels[index];
    return HouseCoverVertical(houseCoverModel);
  }

  List<Widget> _buildFilterSwitch() {
    List<Widget> switches = [
      SwitchItem(
        title: filterTitle[0],
        onPressed: () => onTapFilterWidget(0),
      ),
      SwitchItem(
        title: filterTitle[1],
        onPressed: () => onTapFilterWidget(1),
      ),
      SwitchItem(
        title: filterTitle[2],
        onPressed: () => onTapFilterWidget(2),
      ),
      SwitchItem(
        title: filterTitle[3],
        onPressed: () => onTapFilterWidget(3),
      ),
    ];
    return switches;
  }

  Widget buildFilterContainer() {
    if (isMaskOpen) {
      return Positioned(
        top: 32.0,
        child: Column(
          children: <Widget>[
            buildFilterWidget(),
            buildMask(),
          ],
        ),
      );
    } else {
      return Container(
        width: 0.0,
        height: 0.0,
      );
    }
  }

  onTapFilterWidget(int index) {
    if (isMaskOpen) {
      if (index == currentContentIndex) {
        closeFilterContent();
      } else {
        switchFilterWidget(index);
      }
    } else {
      openFilterContent(index);
    }
  }

  openFilterContent(int index) {
    setState(() {
      isMaskOpen = true;
      currentContentIndex = index;
    });
  }

  closeFilterContent() {
    setState(() {
      isMaskOpen = false;
    });
  }

  Widget buildMask() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(0, 0, 0, 0.5),
      ),
      onTap: closeFilterContent,
    );
  }

  Widget buildFilterWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: contentWidget[currentContentIndex],
    );
  }

  switchFilterWidget(int index) {
    setState(() {
      currentContentIndex = index;
    });
  }
}

class SwitchItem extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  SwitchItem({Key key, this.onPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              overflow: TextOverflow.ellipsis,
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class HouseTypeFilterBox extends StatefulWidget {
  @override
  _HouseTypeFilterBoxState createState() => _HouseTypeFilterBoxState();
}

class _HouseTypeFilterBoxState extends State<HouseTypeFilterBox> {
  bool isSelectAllEntireRent = false;
  bool isSelectAllSharedRent = false;
  List<bool> entireRents = [false, false, false, false];
  List<bool> sharedRents = [false, false, false, false];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    LocalStore.readFilterCondition().then((filterCondition) {
      setState(() {
        isSelectAllSharedRent = filterCondition.isSelectAllSharedRent;
        isSelectAllEntireRent = filterCondition.isSelectAllEntireRent;
        entireRents = filterCondition.entireRents;
        sharedRents = filterCondition.sharedRents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: FilterTag(
                        filterTag: "全部",
                        isActivate: isSelectAllSharedRent,
                        onPressed: () {
                          setState(() {
                            if (isSelectAllSharedRent) {
                              isSelectAllSharedRent = false;
                              for (int i = 0; i < sharedRents.length; i++) {
                                sharedRents[i] = false;
                              }
                            } else {
                              isSelectAllSharedRent = true;
                              for (int i = 0; i < sharedRents.length; i++) {
                                sharedRents[i] = true;
                              }
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "2居",
                        isActivate: sharedRents[0],
                        onPressed: () {
                          setState(() {
                            sharedRents[0] = !sharedRents[0];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "3居",
                        isActivate: sharedRents[1],
                        onPressed: () {
                          setState(() {
                            sharedRents[1] = !sharedRents[1];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "4居",
                        isActivate: sharedRents[2],
                        onPressed: () {
                          setState(() {
                            sharedRents[2] = !sharedRents[2];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "4居+",
                        isActivate: sharedRents[3],
                        onPressed: () {
                          setState(() {
                            sharedRents[3] = !sharedRents[3];
                          });
                        },
                      ),
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
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: FilterTag(
                        filterTag: "全部",
                        isActivate: isSelectAllEntireRent,
                        onPressed: () {
                          setState(() {
                            if (isSelectAllEntireRent) {
                              isSelectAllEntireRent = false;
                              for (int i = 0; i < entireRents.length; i++) {
                                entireRents[i] = false;
                              }
                            } else {
                              isSelectAllEntireRent = true;
                              for (int i = 0; i < entireRents.length; i++) {
                                entireRents[i] = true;
                              }
                            }
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "2居",
                        isActivate: entireRents[0],
                        onPressed: () {
                          setState(() {
                            entireRents[0] = !entireRents[0];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "3居",
                        isActivate: entireRents[1],
                        onPressed: () {
                          setState(() {
                            entireRents[1] = !entireRents[1];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "4居",
                        isActivate: entireRents[2],
                        onPressed: () {
                          setState(() {
                            entireRents[2] = !entireRents[2];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "4居+",
                        isActivate: entireRents[3],
                        onPressed: () {
                          setState(() {
                            entireRents[3] = !entireRents[3];
                          });
                        },
                      ),
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
                    margin: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          isSelectAllEntireRent = false;
                          isSelectAllSharedRent = false;
                          for (int i = 0; i < entireRents.length; i++) {
                            entireRents[i] = false;
                          }
                          for (int i = 0; i < sharedRents.length; i++) {
                            sharedRents[i] = false;
                          }
                        });
                        eventBus.fire(ResetHouseTypeFilterEvent("reset"));
                      },
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
                    margin: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      onPressed: () {
                        eventBus.fire(
                          SendHouseTypeFilterEvent(
                            isSelectAllEntireRent,
                            isSelectAllSharedRent,
                            entireRents,
                            sharedRents,
                          ),
                        );
                      },
                      child: Text(
                        "确定",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
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
  List<String> regions = [];

  @override
  void initState() {
    _loadRegion();
    super.initState();
  }

  _loadRegion() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    print(appDocDir.path);
    AssetBundle rootBundle = PlatformAssetBundle();
    String appDocPath = appDocDir.path;
    DefaultAssetBundle.of(context)
        .loadString(
            "/data/user/0/com.leon.renting_assistant/code_cache/renting_assistantHSRJHT/renting_assistant/build/flutter/assets//data/region.json")
        .then((value) {
      Map<String, dynamic> map = jsonDecode(value);
      LocalStore.readCurrentCity().then((value) {
        List<dynamic> origin = map[value];
        List<String> region = [];
        for (int i = 0; i < origin.length; i++) {
          region.add(origin[i] as String);
        }
        region.insert(0, "不限");
        setState(() {
          regions = region;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      color: Colors.white,
      child: ListView.builder(
        itemBuilder: _regionListBuild,
        itemCount: regions.length,
      ),
    );
  }

  Widget _regionListBuild(BuildContext context, int index) {
    return FlatButton(
      onPressed: () {},
      child: Text(
        regions[index],
        style: TextStyle(fontSize: 15.0),
      ),
    );
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
              onPressed: () {
                eventBus.fire(PriceFilterContentEvent(0));
              },
              child: Text(
                "不限",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                eventBus.fire(PriceFilterContentEvent(1));
              },
              child: Text(
                "1000元以下",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                eventBus.fire(PriceFilterContentEvent(2));
              },
              child: Text(
                "1000-2000元",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                eventBus.fire(PriceFilterContentEvent(3));
              },
              child: Text(
                "2000-3000元",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                eventBus.fire(PriceFilterContentEvent(4));
              },
              child: Text(
                "3000-4000元",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                eventBus.fire(PriceFilterContentEvent(5));
              },
              child: Text(
                "4000-5000元",
                style: TextStyle(color: Colors.cyan[300]),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: FlatButton(
              onPressed: () {
                eventBus.fire(PriceFilterContentEvent(6));
              },
              child: Text(
                "5000元以上",
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
  bool isNearBySubway = false;
  bool hasLift = false;
  List<bool> houseAreas = [false, false, false, false, false];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    LocalStore.readFilterCondition().then((filterCondition) {
      setState(() {
        isNearBySubway = filterCondition.isNearBySubway;
        hasLift = filterCondition.hasLift;
        houseAreas = filterCondition.houseAreas;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: FilterTag(
                        filterTag: "近地铁",
                        isActivate: isNearBySubway,
                        onPressed: () {
                          setState(() {
                            isNearBySubway = !isNearBySubway;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "电梯",
                        isActivate: hasLift,
                        onPressed: () {
                          setState(() {
                            hasLift = !hasLift;
                          });
                        },
                      ),
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
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      child: FilterTag(
                        filterTag: "10-20㎡",
                        isActivate: houseAreas[0],
                        onPressed: () {
                          setState(() {
                            houseAreas[0] = !houseAreas[0];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "20-30㎡",
                        isActivate: houseAreas[1],
                        onPressed: () {
                          setState(() {
                            houseAreas[1] = !houseAreas[1];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "30-40㎡",
                        isActivate: houseAreas[2],
                        onPressed: () {
                          setState(() {
                            houseAreas[2] = !houseAreas[2];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "40-50㎡",
                        isActivate: houseAreas[3],
                        onPressed: () {
                          setState(() {
                            houseAreas[3] = !houseAreas[3];
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FilterTag(
                        filterTag: "50㎡以上",
                        isActivate: houseAreas[4],
                        onPressed: () {
                          setState(() {
                            houseAreas[4] = !houseAreas[4];
                          });
                        },
                      ),
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
                    margin: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          isNearBySubway = false;
                          hasLift = false;
                          for (int i = 0; i < houseAreas.length; i++) {
                            houseAreas[i] = false;
                          }
                        });
                        eventBus.fire(ResetHouseMoreFilterEvent("reset"));
                      },
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
                    margin: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: FlatButton(
                      onPressed: () {
                        eventBus.fire(SendHouseMoreFilterEvent(
                            isNearBySubway, hasLift, houseAreas));
                      },
                      child: Text(
                        "确定",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
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

class FilterTag extends StatelessWidget {
  final String filterTag;
  final bool isActivate;
  final VoidCallback onPressed;

  FilterTag({Key key, this.filterTag, this.isActivate, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: LimitedBox(
        child: Container(
          child: Text(
            filterTag,
            style:
                TextStyle(color: isActivate ? Colors.cyan[400] : Colors.black),
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
      onTap: onPressed,
    );
  }
}
