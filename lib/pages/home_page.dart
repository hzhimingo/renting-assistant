import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/widgets/home_page_appbar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:renting_assistant/widgets/house_cover_horizontal.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  Future<List<HouseCoverModel>> _houseCoverModelFuture;
  List<HouseCoverModel> houseCoverModels = [];
  List<String> banners = [
    "https://public.danke.com.cn/public-20180313-FjBjwyWZ2cAE_dsUTMRa3Li_8XMS",
    "https://public.danke.com.cn/public-20180602-Fj0xD4ACf_aWvGBKEvpokj0ZgENP",
  ];

  @override
  void initState() {
    _loadData(1, 10);
    super.initState();
    print("Reload");
  }

  _loadData(int page, int size) async {
    _houseCoverModelFuture = NetDataRepo().obtainHouseInfoFilter(page, size);
    setState(() {
      if (houseCoverModels.length != 0) {
        houseCoverModels = [];
      }
      _houseCoverModelFuture.then((value) => houseCoverModels.addAll(value));
    });
  }

  void _listen() {
    eventBus.on<RefreshHomeRecommendList>().listen((event) {
      _loadData(1, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
      appBar: HomePageAppBar(),
      body: RefreshIndicator(
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 8.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 160.0,
              child: Swiper(
                itemBuilder: _swiperItemBuilder,
                itemCount: banners.length,
                autoplay: true,
                duration: 500,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text(
                "为你推荐",
                style: TextStyle(
                    fontSize: 19.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder(
              future: _houseCoverModelFuture,
              builder: (BuildContext context, AsyncSnapshot<List<HouseCoverModel>> snap) {
                switch (snap.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Container(
                      height: 500.0,
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: Colors.cyan[300],
                          size: 30.0,
                        ),
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
                                  _loadData(0, 10);
                                },
                                child: Text("重新加载"),
                              ),
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            ),
                          ],
                        ),
                      );
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: houseCoverModels.length,
                      itemBuilder: _recommendHouseBuilder,
                    );
                }
              },
            ),
            Container(
              height: 45.0,
              margin: EdgeInsets.only(
                  left: 50.0, right: 50.0, top: 16.0, bottom: 16.0),
              child: FlatButton(
                onPressed: () => Navigator.of(context).pushNamed("/findHouse"),
                child: Text(
                  "更多品质房源",
                  style: TextStyle(fontSize: 15.0),
                ),
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
              ),
            )
          ],
        ),
        onRefresh: () {
          _onRefresh();
        },
      ),
    );
  }

  Future<Null> _onRefresh() async {
    houseCoverModels.clear();
    await _loadData(Random().nextInt(5), 10);
  }

  Widget _recommendHouseBuilder(BuildContext context, int index) {
    HouseCoverModel houseCoverModel = houseCoverModels[index];
    return HouseCoverHorizontal(houseCoverModel);
  }

  Widget _swiperItemBuilder(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: NetworkImage(
            banners[index],
          ),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
