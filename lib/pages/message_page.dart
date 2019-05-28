import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
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
      body: Center(
        child: Text('Message'),
      ),
    );
  }
}
