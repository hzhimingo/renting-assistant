import 'package:flutter/material.dart';
import 'package:renting_assistant/widgets/answer_cover.dart';

class AnswerAll extends StatefulWidget {
  @override
  _AnswerAllState createState() => _AnswerAllState();
}

class _AnswerAllState extends State<AnswerAll> {
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
          AnswerCoverBox(),
          AnswerCoverBox(),
          AnswerCoverBox(),
          AnswerCoverBox(),
          AnswerCoverBox(),
        ],
      ),
    );
  }
}
