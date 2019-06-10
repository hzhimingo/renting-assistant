import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:renting_assistant/localstore/local_store.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  bool isSignIn = false;
  final _boxDecoration = BoxDecoration(
    color: Colors.white,
    border: Border(
      bottom: BorderSide(
        color: Colors.grey[100],
      ),
    ),
  );

  @override
  void initState() {
    _isSignIn();
    super.initState();
  }

  _isSignIn() async {
    await LocalStore.readAccessToken().then((value) {
      if (value != null) {
        setState(() {
          isSignIn = true;
        });
      }
    });
  }

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
        children: _buildListView(),
      ),
    );
  }

  List<Widget> _buildListView() {
    List<Widget> lists = [
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
    ];
    if (isSignIn) {
      lists.add(Container(
        margin: EdgeInsets.only(top: 15.0),
        color: Colors.white,
        child: FlatButton(
          onPressed: () => _logOut(),
          child: Text(
            "退出登录",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16.0,
            ),
          ),
        ),
      ));
    }
    return lists;
  }

  _logOut() async {
    await LocalStore.removeAccessToken().then((value) {
      eventBus.fire(LogOutEvent());
      LocalStore.removeAccessToken();
      LocalStore.removeUserInfo();
      _showToast("成功退出登录");
      Navigator.of(context).pop();
    });
  }

  _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
        textColor: Colors.white,
        fontSize: 14.0
    );
  }

}
