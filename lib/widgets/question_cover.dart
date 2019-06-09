import 'package:flutter/material.dart';
import 'package:renting_assistant/model/answer_cover.dart';
import 'package:renting_assistant/model/question_cover.dart';
import 'package:renting_assistant/pages/question_detail.dart';
import 'package:renting_assistant/widgets/answer_cover.dart';

class QuestionCoverBox extends StatelessWidget {
  final QuestionCover _questionCover;

  QuestionCoverBox(this._questionCover);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return QuestionDetailPage(_questionCover.questionId);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
        margin: EdgeInsets.only(bottom: 10.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserInfoBox(
              type: "Q",
              nickname: _questionCover.nickname,
              avatar: _questionCover.avatar,
              time: _questionCover.publishDate,
            ),
            Question(_questionCover.questionContent),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
              child: Text(
                _questionCover.answerCount == 0
                    ? "0人回答"
                    : "${_questionCover.answerCount}人回答",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
