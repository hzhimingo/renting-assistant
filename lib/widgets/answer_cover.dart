import 'package:flutter/material.dart';
import 'package:renting_assistant/pages/answer_info.dart';
import 'package:renting_assistant/widgets/answer_detail.dart';

class AnswerCoverBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AnswerInfo();
        }));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            UserInfoBox("A"),
            Question(),
            AnswerContent(),
            AnswerOption(),
          ],
        ),
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        decoration: BoxDecoration(color: Colors.white),
      ),
    );
  }
}

/// 用户信息部分
class UserInfoBox extends StatelessWidget {

  final String type;
  UserInfoBox(this.type);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 35.0,
            height: 35.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://avatar.gitee.com/uploads/29/4790229_leonzm.png!avatar100?1548256827"),
              ),
              shape: BoxShape.circle
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "leon.",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      "21小时前",
                      style: TextStyle(fontSize: 12.0, color: Colors.grey[500]),
                    ),
                    Container(
                      child: Text(
                        type == "Q" ? '提问' : '回答',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      padding: EdgeInsets.only(
                          left: 4.0, right: 4.0, top: 1.0, bottom: 1.0),
                      decoration: BoxDecoration(
                        color: type == 'Q' ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 问题部分
class Question extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
      child: Text(
        '总金额675万，90-110平两居，南向，近地铁，小区环境好,总金额675万?',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// 内嵌的第一个回答，简略信息
class AnswerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
      child: Text(
        '谢谢邀请，哈桑上的卡号是打开哈萨克德哈（卡速度很快爱上电话）卡就是对话框哈桑上的卡号是打开哈萨克德哈卡速度很快爱上电话卡就是对话框哈桑上的卡号是打开哈萨克德哈卡速度很快爱上电话卡就是对话框',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.0,
          letterSpacing: 0.9,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]
          )
        ),
      ),
    );
  }
}

/// 点赞、回复、分享部分
class AnswerOption extends StatefulWidget {
  @override
  _AnswerOptionState createState() => _AnswerOptionState();
}

class _AnswerOptionState extends State<AnswerOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      IconData(0xe756, fontFamily: 'iconfont'),
                      color: Colors.grey[400],
                      size: 20.0,
                    ),
                    SizedBox(
                      width: 3.0,
                    ),
                    Text(
                      '10',
                      style: TextStyle(color: Colors.grey[400], fontSize: 15.0),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return AnswerInfo();
                }));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    IconData(0xe603, fontFamily: 'iconfont'),
                    color: Colors.grey[400],
                    size: 28.0,
                  ),
                  SizedBox(
                    width: 3.0,
                  ),
                  Text(
                    '10',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.share,
                    color: Colors.grey[400],
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
