import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  final _boxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border(
      bottom: BorderSide(
        color: Colors.grey[100],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "系统设置",
          style: TextStyle(fontSize: 17.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration: _boxDecoration,
            child: ListTile(
              title: Text("清理缓存"),
              trailing: IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () => print("清理缓存"),
              ),
            ),
          ),
          Container(
            decoration: _boxDecoration,
            child: ListTile(
              title: Text("关于租房助手"),
              trailing: IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () => print("关于租房助手"),
              ),
            ),
          ),
          Container(
            decoration: _boxDecoration,
            child: ListTile(
              title: Text("开发设置"),
              trailing: IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () => Navigator.of(context).pushNamed("/dev-info"),
              ),
            ),
          ),
          Container(
            decoration: _boxDecoration,
            child: ListTile(
              title: Text("推送设置"),
              trailing: IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () => print("推送设置"),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15.0),
            color: Colors.white,
            child: FlatButton(
              onPressed: () => print("退出登录"),
              child: Text(
                "退出登录",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
