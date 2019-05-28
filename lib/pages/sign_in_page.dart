import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:renting_assistant/api/net_data_repo.dart';
import 'package:renting_assistant/even_bus/even_bus.dart';
import 'package:renting_assistant/localstore/local_store.dart';

import 'mine_page.dart';

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() {
    return SignInPageState();
  }
}

class SignInPageState extends State<SignInPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _checkCodeController = TextEditingController();
  String _checkTips = "获取验证码";
  Timer _countdownTimer;
  int _countDownNum  = 59;
  Color _checkTipsColor = Colors.cyan[300];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.all(45.0),
                  color: Colors.grey[100],
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]),
                          ),
                          hintText: "请输入手机号",
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          suffix: GestureDetector(
                            child: Text(
                              _checkTips,
                              style: TextStyle(
                                color: _checkTipsColor,
                              ),
                            ),
                            onTap: () {
                              _obtainCheckCode();
                            },
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]),
                          ),
                          hintText: "请输入手机验证码",
                        ),
                        keyboardType: TextInputType.number,
                        controller: _checkCodeController,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        width: 300.0,
                        height: 45.0,
                        child: FlatButton(
                          onPressed: () {
                            _signIn();
                          },
                          child: Text(
                            "登录",
                            style: TextStyle(
                                color: Colors.white, fontSize: 17.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          disabledColor: Colors.cyan[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, top: 32.0),
            child: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.grey[100],
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  _signIn() {
   if (_phoneController.value.text == "" || _checkCodeController.value.text == "") {
     if (_phoneController.value.text == "") {
       if (_checkCodeController.value.text == "") {
         _showToast("请输入手机号和验证码");
       } else {
         _showToast("请输入手机号");
       }
     } else if (_checkCodeController.value.text == "") {
       _showToast("请输入验证码");
     }
   } else {
     _showToast("登录中....");
     NetDataRepo().signIn(_phoneController.value.text, _checkCodeController.value.text).then((value) {
       if (value != null) {
         LocalStore.saveAccessToken(value);
         eventBus.fire(SignInEvent());
         Navigator.of(context).pop();
       } else {
         _showToast("登录失败");
       }
     });
   }
  }

  bool _validatePhone(String phone) {
    return false;
  }

  _obtainCheckCode() {
    if (_checkTips == "获取验证码") {
      if (_phoneController.value.text == "") {
        _showToast("请输入手机号");
      } else if (_validatePhone(_phoneController.value.text)) {

      } else {
        NetDataRepo().sendCheckCode(_phoneController.value.text);
        countdown();
        _showToast("发送成功");
      }
    }
  }

  void countdown(){
    setState(() {
      _checkTipsColor = Colors.grey[400];
    });
    _countdownTimer =  new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDownNum > 0) {
          _checkTips = "${_countDownNum--}s后重新获取";
        } else {
          _checkTips  = "获取验证码";
          _checkTipsColor = Colors.cyan[300];
          _countDownNum = 59;
          _countdownTimer.cancel();
          _countdownTimer = null;
        }
      });
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

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }
}
