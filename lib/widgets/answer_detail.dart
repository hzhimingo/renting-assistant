import 'package:flutter/material.dart';
import 'package:renting_assistant/widgets/answer_cover.dart';

class AnswerDetailBox extends StatelessWidget {
  final String nickname;
  final String avatar;
  final String time;
  final String answerContent;

  AnswerDetailBox({Key key, this.nickname, this.avatar, this.time, this.answerContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding:
          EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0, bottom: 15.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          UserInfoBox(
            type: "A",
            nickname: nickname,
            avatar: avatar,
            time: time,
          ),
          AnswerRichText(
            answerContent: answerContent,
          ),
        ],
      ),
    );
  }
}

class AnswerRichText extends StatelessWidget {

  final String answerContent;

  AnswerRichText({Key key, this.answerContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0, right: 10.0),
      alignment: Alignment.centerLeft,
      child: Text(
        answerContent,
        style: TextStyle(
          fontSize: 17.0,
          letterSpacing: 0.9,
        ),
      ),
    );
  }
}


