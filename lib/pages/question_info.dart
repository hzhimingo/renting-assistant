import 'package:flutter/material.dart';
import 'package:renting_assistant/pages/answer_info.dart';
import 'package:renting_assistant/widgets/answer_cover.dart';

class QuestionInfo extends StatefulWidget {
  @override
  _QuestionInfoState createState() => _QuestionInfoState();
}

class _QuestionInfoState extends State<QuestionInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('全部回答'),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _questionInfoTop(),
            _answerList(),
          ],
        ),
      ),
    );
  }

  Widget _questionInfoTop() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
              bottom: 10.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Text(
              '你为什么更喜欢用京东而不是淘宝?或者反过来？',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _questionUserInfo(),
          _questionContent(),
        ],
      ),
    );
  }

  Widget _questionContent() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
      child: Text('内容内容', style: TextStyle(fontSize: 16.0,),),
    );
  }

  Widget _questionUserInfo() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://avatar.gitee.com/uploads/29/4790229_leonzm.png!avatar100?1548256827"),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "leon.",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                '一天前',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerList() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        _answer(),
        _answer(),
        _answer(),
      ],
    );
  }

  Widget _answerUserInfo() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://avatar.gitee.com/uploads/29/4790229_leonzm.png!avatar100?1548256827"),
              ),
              shape: BoxShape.circle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "leon.",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "21小时前",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[500]),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _answer() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AnswerInfo();
        }));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            _answerUserInfo(),
            AnswerContent(),
            AnswerOption(),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}
