import 'package:flutter/material.dart';
import 'package:renting_assistant/pages/question_info.dart';
import 'package:renting_assistant/widgets/answer_cover.dart';

class QuestionCoverBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return QuestionInfo();
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 10.0),
        margin: EdgeInsets.only(bottom: 10.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UserInfoBox("Q"),
            Question(),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
              child: Text('36人回答', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
