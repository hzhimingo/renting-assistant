import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/widgets/house_cover_horizontal.dart';

class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  Future<List<HouseCoverModel>> _houseCoverModelFuture;
  List<HouseCoverModel> houseCoverModels = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    _houseCoverModelFuture = NetDataRepo().obtainCollectList();
    setState(() {
      _houseCoverModelFuture.then((value) {
        if (houseCoverModels.length != 0) {
          houseCoverModels = [];
        }
        houseCoverModels.addAll(value);
      });
    });
  }

  _listen() {
    eventBus.on<UpdateCollect>().listen((event) {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    _listen();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=> Navigator.of(context).pop()),
        title: Text('我的关注'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: _houseCoverModelFuture,
        builder: (BuildContext context, AsyncSnapshot<List<HouseCoverModel>> snap) {
          switch(snap.connectionState) {
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
                  child: Text("还没有关注任何房源噢！"),
                );
              } else {
                return ListView.builder(
                  itemCount: houseCoverModels.length,
                  itemBuilder: _collectedHouseBuilder,
                );
              }
          }
        },
      ),
    );
  }

  Widget _collectedHouseBuilder(BuildContext context, int index) {
    HouseCoverModel houseCoverModel = houseCoverModels[index];
    return HouseCoverHorizontal(houseCoverModel);
  }
}
