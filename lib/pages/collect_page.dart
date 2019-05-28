import 'package:flutter/material.dart';

class CollectPage extends StatefulWidget {
  @override
  _CollectPageState createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: ()=> Navigator.of(context).pop()),
        title: Text('我的关注'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: Center(
          child: Text("我的关注"),
        ),
      ),
    );
  }
}
