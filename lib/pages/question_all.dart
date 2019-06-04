import 'package:flutter/material.dart';
import 'package:renting_assistant/widgets/question_cover.dart';

class QuestionAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: Text('全部回答'),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: ListView(
        children: <Widget>[
          QuestionCoverBox(),
          QuestionCoverBox(),
          QuestionCoverBox(),
          QuestionCoverBox(),
          QuestionCoverBox(),
        ],
      ),
    );
  }
}

