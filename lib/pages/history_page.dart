import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
        title: Text('我的足迹'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        child: Center(
          child: Text("我的足迹"),
        ),
      ),
    );
  }
}
