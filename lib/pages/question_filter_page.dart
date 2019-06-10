import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/model/question_cover.dart';
import 'package:renting_assistant/widgets/question_cover.dart';

class QuestionFilterPage extends StatefulWidget {
  @override
  _QuestionFilterPageState createState() => _QuestionFilterPageState();
}

class _QuestionFilterPageState extends State<QuestionFilterPage> {
  Future<List<QuestionCover>> _questionsFuture;
  List<QuestionCover> _questionCovers;

  _loadData(int page, int size) {
    _questionsFuture = NetDataRepo().obtainQuestionCovers();
    setState(() {
      _questionsFuture.then((value) {
        _questionCovers = [];
        _questionCovers.addAll(value);
      });
    });
  }

  @override
  void initState() {
    _loadData(0, 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: Text('问题精选', style: TextStyle(fontSize: 18.0),),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: FutureBuilder(
        future: _questionsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<QuestionCover>> snap) {
          switch(snap.connectionState) {
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
              if (snap.hasError) {
                Center(
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
              }
              if (_questionCovers.length == 0) {
                return Container(
                  height: 500.0,
                  child: Center(
                    child: Text('这里什么都没有噢'),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: _questionCovers.length,
                  itemBuilder: _buildQuestions,
                );
              }

          }
        },
      ),
    );
  }

  Widget _buildQuestions(BuildContext context, int index) {
    QuestionCover _question = _questionCovers[index];
    return QuestionCoverBox(_question);
  }
}
