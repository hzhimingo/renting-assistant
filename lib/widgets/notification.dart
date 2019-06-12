import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// 官方通知
class OfficeNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

/// 回复通知
class ReplyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

/// 回答通知
class AnswerQuestionNotification extends StatelessWidget {
  final String nickname;
  final String avatar;

  AnswerQuestionNotification({Key key, this.nickname, this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.0
      ),
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: 16.0,
      ),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: 38.0,
            height: 38.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  avatar,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 50.0,
                  child: Text(
                    "$nickname",
                    style: TextStyle(fontSize: 16.0,),
                  ),
                ),
                Text("回答了你的问题", style: TextStyle(fontSize: 16.0,),),
              ],
            )
          ),
        ],
      ),
    );
  }
}
