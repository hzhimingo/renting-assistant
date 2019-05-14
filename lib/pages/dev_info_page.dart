import 'package:flutter/material.dart';

class DevInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DevInfoPageState();
  }
}

class _DevInfoPageState extends State<DevInfoPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "取消",
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        centerTitle: true,
        title: Text("开发者设置", style: TextStyle(fontSize: 17.0),),
        actions: <Widget>[
          GestureDetector(
            onTap: () => print("Save And Pop"),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                right: 16.0,
              ),
              child: Text(
                "完成",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40.0,
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Text("服务器地址设置", style: TextStyle(fontSize: 16.0),),
            ),
            Row(
              children: <Widget>[

              ],
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 1,
                maxLength: 15,
                decoration: InputDecoration(
                  labelText: "服务器地址",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
