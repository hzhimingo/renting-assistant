import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/model/house_cover_model.dart';
import 'package:renting_assistant/widgets/house_cover_horizontal.dart';

class SearchResultPage extends StatefulWidget {

  final String keyword;

  SearchResultPage(this.keyword);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {

  Future<List<HouseCoverModel>> _houseCoverModelFuture;
  List<HouseCoverModel> houseCoverModels = [];


  @override
  void initState() {
    super.initState();
    searchData(widget.keyword);
  }

  searchData(String keyword) {
    setState(() {
      _houseCoverModelFuture = NetDataRepo().search(keyword);
      _houseCoverModelFuture.then((value) {
        houseCoverModels = [];
        houseCoverModels.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=> Navigator.of(context).pop(),),
        title: Text("搜索结果", style: TextStyle(fontSize: 18.0,),),
        elevation: 0.4,
      ),
      body: FutureBuilder(
        future: _houseCoverModelFuture,
        builder: (BuildContext context, AsyncSnapshot<List<HouseCoverModel>> snap) {
          switch(snap.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Container(
                child: Center(
                  child: SpinKitThreeBounce(
                    color: Colors.cyan[300],
                    size: 30.0,
                  ),
                ),
              );
            case ConnectionState.done:
              if (snap.hasError) {
                return Container(
                  child: Center(
                    child: Text("网络错误"),
                  ),
                );
              }
              if (houseCoverModels.length == 0) {
                return Container(
                  child: Center(
                    child: Text("没有你想要的结果"),
                  ),
                );
              } else {
                return Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: houseCoverModels.length,
                    itemBuilder: _buildSearchResult,
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget _buildSearchResult(BuildContext context, int index) {
    HouseCoverModel _houseCoverModel = houseCoverModels[index];
    return HouseCoverHorizontal(_houseCoverModel);
  }
}
