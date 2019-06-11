import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:renting_assistant/model/user_info.dart';

class EditUserInfoPage extends StatefulWidget {
  final UserInfo userInfo;

  EditUserInfoPage(this.userInfo);

  @override
  _EditUserInfoPageState createState() => _EditUserInfoPageState();
}

class _EditUserInfoPageState extends State<EditUserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "编辑资料",
          style: TextStyle(fontSize: 18.0),
        ),
        elevation: 0.4,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: 15.0,
                bottom: 15.0,
              ),
              margin: EdgeInsets.only(
                top: 10.0,
              ),
              child: ListTile(
                onTap: () {},
                leading: Text(
                  "头像",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                trailing: Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(65.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.userInfo.avatar,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10.0,
              ),
              color: Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return EditUserNickname(widget.userInfo.nickname);
                    }),
                  );
                },
                leading: Text(
                  "用户名",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                trailing: Text(
                  widget.userInfo.nickname,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 10.0,
              ),
              color: Colors.white,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return EditEmail(widget.userInfo.email);
                  }));
                },
                leading: Text(
                  "邮箱",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                trailing: Text(
                  widget.userInfo.email,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditUserNickname extends StatefulWidget {
  final String nickname;

  EditUserNickname(this.nickname);

  @override
  _EditUserNicknameState createState() => _EditUserNicknameState();
}

class _EditUserNicknameState extends State<EditUserNickname> {
  TextEditingController _nicknameEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        title: Text('编辑资料'),
        elevation: 0.4,
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 20.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 15.0,
              ),
              child: Text(
                "修改用户名",
                style: TextStyle(
                  fontSize: 19.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 15.0,
              ),
              child: Text(
                "您当前用户名为：${widget.nickname}",
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
            TextField(
              controller: _nicknameEditController,
              autofocus: false,
              maxLength: 12,
              decoration: InputDecoration(
                hintText: "请输入新用户名",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                contentPadding: EdgeInsets.all(15.0),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(26, 173, 25, 1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 15.0,
              ),
              child: FlatButton(
                onPressed: () {
                  if (_nicknameEditController.value.text == "") {
                    _showToast("用户名不能为空噢！");
                  } else {
                    _showDialog(context, _nicknameEditController.value.text);
                  }
                },
                child: Text(
                  "确认修改",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context, String newNickname) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20.0),
          title: Text("确定要将用户名修改为："),
          content: Container(
            height: 90.0,
            alignment: Alignment.center,
            child: Text(newNickname),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消", style: TextStyle(color: Colors.grey[500], fontSize: 15.0,),),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("确认修改", style: TextStyle(color: Color.fromRGBO(26, 173, 25, 1), fontSize: 15.0,),),
            )
          ],
        );
      },
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
        fontSize: 14.0);
  }
}

class EditEmail extends StatefulWidget {
  final String email;

  EditEmail(this.email);

  @override
  _EditEmailState createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {

  TextEditingController _emailEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        title: Text('编辑资料'),
        elevation: 0.4,
      ),
      body: Container(
        padding: EdgeInsets.only(
          top: 20.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 15.0,
              ),
              child: Text(
                "修改绑定邮箱",
                style: TextStyle(
                  fontSize: 19.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 15.0,
              ),
              child: Text(
                "您当前邮箱为：${widget.email}",
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
            TextField(
              controller: _emailEditController,
              autofocus: false,
              decoration: InputDecoration(
                hintText: "请输入新的邮箱",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]),
                ),
                contentPadding: EdgeInsets.all(15.0),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(26, 173, 25, 1),
                borderRadius: BorderRadius.circular(5.0),
              ),
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 30.0,
              ),
              child: FlatButton(
                onPressed: () {
                  if (_emailEditController.value.text == "") {
                    _showToast("邮箱不能为空噢！");
                  } else {
                    _showCheckCode(context);
                  }
                },
                child: Text(
                  "获取验证码",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showCheckCode(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20.0),
          title: Text("已经向您的现有邮箱发送了验证码"),
          content: Container(
            height: 70.0,
            alignment: Alignment.center,
            child: TextField(
              decoration: InputDecoration(
                hintText: "请输入验证码",
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消", style: TextStyle(color: Colors.grey[500], fontSize: 15.0,),),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("重新发送(120s)", style: TextStyle(color: Colors.grey[500], fontSize: 15.0,),),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("修改密码", style: TextStyle(color: Color.fromRGBO(26, 173, 25, 1), fontSize: 15.0,),),
            )
          ],
        );
      },
    );
  }

  _showDialog(BuildContext context, String newNickname) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(20.0),
          title: Text("确定要将用户名修改为："),
          content: Container(
            height: 90.0,
            alignment: Alignment.center,
            child: Text(newNickname),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("取消", style: TextStyle(color: Colors.grey[500], fontSize: 15.0,),),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("确认修改", style: TextStyle(color: Color.fromRGBO(26, 173, 25, 1), fontSize: 15.0,),),
            )
          ],
        );
      },
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
        fontSize: 14.0);
  }
}

class EditUserAvatar extends StatefulWidget {
  @override
  _EditUserAvatarState createState() => _EditUserAvatarState();
}

class _EditUserAvatarState extends State<EditUserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
