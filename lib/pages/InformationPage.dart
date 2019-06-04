import 'package:flutter/material.dart';
import 'package:renting_assistant/pages/answer_all.dart';
import 'package:renting_assistant/pages/question_all.dart';
import 'package:renting_assistant/widgets/answer_cover.dart';

class InformationPage extends StatefulWidget {
  @override
  State<InformationPage> createState() {
    return InformationPageState();
  }
}

class InformationPageState extends State<InformationPage> with AutomaticKeepAliveClientMixin{

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
          AnswerCoverBox(),
          AnswerCoverBox(),
          AnswerCoverBox(),
          AnswerCoverBox(),
          AnswerCoverBox(),
          AnswerCoverBox(),
          AnswerCoverBox(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan[300],
        onPressed: () {},
      ),
    );
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
                  return QuestionAll();
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