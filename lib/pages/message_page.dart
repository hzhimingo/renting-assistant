import 'package:flutter/material.dart';
import 'package:renting_assistant/model/message.dart';
import 'package:renting_assistant/widgets/notification.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> _messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=> Navigator.of(context).pop()),
        title: Text('我的消息'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            AnswerQuestionNotification(
              avatar: "https://avatar.gitee.com/uploads/29/4790229_leonzm.png!avatar100?1548256827",
              nickname: "leon",
            ),
            AnswerQuestionNotification(
              avatar: "https://avatar.gitee.com/uploads/29/4790229_leonzm.png!avatar100?1548256827",
              nickname: "leon01",
            ),
          ],
        ),
      ),
    );
  }
}
