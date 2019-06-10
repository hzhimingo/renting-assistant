import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/model/answer_cover.dart';
import 'package:renting_assistant/pages/answer_all.dart';
import 'package:renting_assistant/pages/edit_question.dart';
import 'package:renting_assistant/pages/question_all.dart';
import 'package:renting_assistant/pages/question_filter_page.dart';
import 'package:renting_assistant/widgets/answer_cover.dart';

import 'answe_filter_page.dart';

class InformationPage extends StatefulWidget {
  @override
  State<InformationPage> createState() {
    return InformationPageState();
  }
}

class InformationPageState extends State<InformationPage> with AutomaticKeepAliveClientMixin{

  Future<List<AnswerCover>> _answerCoversFuture;
  List<AnswerCover> _answerCovers = [];

  @override
  void initState() {
    _loadData(0, 10);
    super.initState();
  }

  _loadData(int page, int size) {
    _answerCoversFuture = NetDataRepo().obtainAnswerCovers();
    setState(() {
      _answerCoversFuture.then((value) {
        _answerCovers = [];
        _answerCovers.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('问答'),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: ListView(
        children: <Widget>[
          _qAOptionBox(),
          _answerCoverBox(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan[300],
        onPressed: () async{
          await LocalStore.readAccessToken().then((value) {
            if (value == null) {
              Navigator.of(context).pushNamed("/sign-in");
            } else {
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return EditQuestionTitle();
              }));
            }
          });
        },
      ),
    );
  }

  Widget _answerCoverBox() {
    return FutureBuilder(
      future: _answerCoversFuture,
      builder: (BuildContext context, AsyncSnapshot<List<AnswerCover>> snap) {
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
            if (_answerCovers.length == 0) {
              return Container(
                height: 500.0,
                child: Center(
                  child: Text('这里什么都没有噢'),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _answerCovers.length,
                itemBuilder: _buildAnswerCover,
              );
            }

        }
      },
    );
  }

  Widget _buildAnswerCover(BuildContext context, int index) {
    AnswerCover answerCover = _answerCovers[index];
    return AnswerCoverBox(answerCover);
  }

  Widget _qAOptionBox() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 10.0),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return QuestionFilterPage();
                }));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 28.0,
                    height: 28.0,
                    margin: EdgeInsets.only(bottom: 2.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/q&a_1.png"),
                      ),
                    ),
                  ),
                  Text('问题精选', style: TextStyle(fontSize: 12.0),),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return AnswerFilterPage();
                }));
              },
              child: Column(
                children: <Widget>[
                  Container(
                    width: 25.0,
                    height: 25.0,
                    margin: EdgeInsets.only(bottom: 2.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/q&a_2.png"),
                      ),
                    ),
                  ),
                  Text('回答精选', style: TextStyle(fontSize: 12.0),),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return QuestionAll();
                }));
              },
              child: Column(
                children: <Widget>[
                  Container(
                    width: 25.0,
                    height: 25.0,
                    margin: EdgeInsets.only(bottom: 2.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/q&a_3.png"),
                      ),
                    ),
                  ),
                  Text('全部问题', style: TextStyle(fontSize: 12.0),),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return AnswerAll();
                }));
              },
              child: Column(
                children: <Widget>[
                  Container(
                    width: 25.0,
                    height: 25.0,
                    margin: EdgeInsets.only(bottom: 2.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/q&a_4.png"),
                      ),
                    ),
                  ),
                  Text('全部回答', style: TextStyle(fontSize: 12.0),),
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