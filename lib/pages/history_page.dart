import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/widgets/house_cover_horizontal.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<HouseCoverModel>> _houseCoverModelFuture;
  List<HouseCoverModel> houseCoverModels = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    _houseCoverModelFuture = NetDataRepo().obtainHistoryList();
    setState(() {
      _houseCoverModelFuture.then((value) {
        if (houseCoverModels.length != 0) {
          houseCoverModels = [];
        }
        houseCoverModels.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('我的足迹'),
        actions: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: 16.0),
              alignment: Alignment.center,
              child: Text("清除", style: TextStyle(fontSize: 17.0),),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0.4,
      ),
      body: FutureBuilder(
        future: _houseCoverModelFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<HouseCoverModel>> snap) {
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
                            _loadData();
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
                  child: Text("暂无任何浏览记录"),
                );
              } else {
                return ListView.builder(
                  itemCount: houseCoverModels.length,
                  itemBuilder: _historyHouseBuilder,
                );
              }
          }
        },
      ),
    );
  }

  Widget _historyHouseBuilder(BuildContext context, int index) {
    HouseCoverModel houseCoverModel = houseCoverModels[index];
    return HouseCoverHorizontal(houseCoverModel);
  }
}
