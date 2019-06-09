import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';

class EditAnswer extends StatefulWidget {
  final String question;
  final String questionId;

  EditAnswer({Key key, this.questionId, this.question}):super(key: key);

  @override
  _EditAnswerState createState() => _EditAnswerState();
}

class _EditAnswerState extends State<EditAnswer> {

  TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.4,
        title: Text('写回答'),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              if (_answerController.value.text != "") {
                NetDataRepo().publishAnswer(widget.questionId, _answerController.value.text).then((value) {
                  if(value) {
                    _answerController.text = "";
                    eventBus.fire(RefreshQuestion());
                    Navigator.of(context).pop();
                  } else {
                    _showToast("发布失败");
                  }
                });
              } else {
                _showToast("请填写正文再发布!");
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: 16.0,),
              alignment: Alignment.center,
              child: Text(
                '发布',
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.cyan[400],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.grey[200],
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0,),
              child: Text(
                widget.question,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 17.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextField(
              controller: _answerController,
              maxLines: 10,
              style: TextStyle(
                fontSize: 16.0,
                letterSpacing: 0.9,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                hintText: '描述你的回答...',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
